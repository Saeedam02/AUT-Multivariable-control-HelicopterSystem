function result = analyzeRobustPerformance(Gunc, K, varargin)
%ANALYZEROBUSTPERFORMANCE Evaluate weighted robust closed-loop performance.
%
% The uncertain weighted map is
%       [ Ws*S ; Wu*K*S ; Wt*T ]
% and ROBGAIN checks whether its worst-case H-infinity gain remains below the
% requested performance level (default gamma = 1).

    parser = inputParser;
    addParameter(parser, "Weights", struct(), @isstruct);
    addParameter(parser, "PerformanceLevel", 1, @isPositiveScalar);
    parse(parser, varargin{:});

    ny = size(Gunc,1);
    weights = parser.Results.Weights;
    if isempty(fieldnames(weights))
        weights = makePerformanceWeights(ny);
    end

    L = Gunc*K;
    S = feedback(eye(ny), L);
    T = feedback(L, eye(ny));
    KS = K*S;
    Perf = [weights.Ws*S; weights.Wu*KS; weights.Wt*T];

    gamma = parser.Results.PerformanceLevel;
    [margin, worstCase] = robgain(Perf, gamma);
    [worstCaseGain, gainUncertainty] = wcgain(Perf);

    result = struct();
    result.performanceSystem = Perf;
    result.performanceLevel = gamma;
    result.margin = margin;
    result.worstCaseUncertainty = worstCase;
    result.worstCaseGain = worstCaseGain;
    result.worstCaseGainUncertainty = gainUncertainty;
    result.weights = weights;
    result.interpretation = [ ...
        "For a requested gain bound gamma, a robust-performance margin above 1 ", ...
        "indicates the modeled uncertainty set satisfies that bound."];
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
