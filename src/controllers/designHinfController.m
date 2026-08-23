function design = designHinfController(Gsquare, varargin)
%DESIGNHINFCONTROLLER Mixed-sensitivity H-infinity controller synthesis.
%
% The synthesis minimizes the weighted closed-loop objective
%
%   || [ Ws*S ; Wu*K*S ; Wt*T ] ||_inf,
%
% where S=(I+GK)^-1 and T=GK(I+GK)^-1.
%
% Requires: Robust Control Toolbox.

    parser = inputParser;
    addParameter(parser, "Weights", struct(), @isstruct);
    parse(parser, varargin{:});

    [ny, nu] = size(Gsquare);
    if ny ~= nu
        error("HelicopterController:HinfRequiresSquareControlledPlant", ...
            "Select a square controlled subplant before H-infinity synthesis.");
    end

    weights = parser.Results.Weights;
    if isempty(fieldnames(weights))
        weights = makePerformanceWeights(ny);
    end

    design = struct();
    design.success = false;
    design.K = [];
    design.weightedClosedLoop = [];
    design.gamma = NaN;
    design.closedLoop = [];
    design.nominalStable = false;
    design.weights = weights;
    design.message = "";

    try
        [K, CLperf, gamma] = mixsyn(Gsquare, weights.Ws, weights.Wu, weights.Wt);
        T = feedback(Gsquare*K, eye(ny));
        design.success = true;
        design.K = K;
        design.weightedClosedLoop = CLperf;
        design.gamma = gamma;
        design.closedLoop = T;
        design.nominalStable = isstable(T);
        design.message = "Synthesis completed.";
    catch ME
        design.message = string(ME.message);
        warning("HelicopterController:HinfSynthesisFailed", ...
            "H-infinity synthesis failed: %s", ME.message);
    end

    design.note = "Mixed-sensitivity H-infinity synthesis on the selected nominal square subplant.";
end
