function result = worstCaseAnalysis(Gunc, K, varargin)
%WORSTCASEANALYSIS Collect worst-case gain and time-domain samples.
%
% The function reports WCGain on the uncertain complementary sensitivity and
% returns the associated uncertainty realization when available. It is useful
% for turning abstract robustness margins into a concrete worst-case model.

    parser = inputParser;
    addParameter(parser, "SimulationTime", 10, @isPositiveScalar);
    parse(parser, varargin{:});

    ny = size(Gunc,1);
    Tunc = feedback(Gunc*K, eye(ny));
    [wcg, wcu] = wcgain(Tunc);

    Tworst = usubs(Tunc, wcu);
    t = linspace(0, parser.Results.SimulationTime, 1000);
    [y, t] = step(Tworst, t);

    result = struct();
    result.worstCaseGain = wcg;
    result.worstCaseUncertainty = wcu;
    result.worstCaseModel = Tworst;
    result.stepResponse = y;
    result.time = t;
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
