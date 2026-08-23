function design = designMuController(GuncSquare, varargin)
%DESIGNMUCONTROLLER Perform D-K iteration (mu synthesis) on an uncertain plant.
%
% The uncertain plant is first augmented with the same tracking/control/noise
% weights used by mixed-sensitivity design. MUSYN then performs D-K iteration.
% This can be computationally expensive and is intentionally kept out of the
% default unit-test path.
%
% Requires: Robust Control Toolbox.

    parser = inputParser;
    addParameter(parser, "Weights", struct(), @isstruct);
    parse(parser, varargin{:});

    [ny, nu] = size(GuncSquare);
    if ny ~= nu
        error("HelicopterController:MuRequiresSquareControlledPlant", ...
            "Mu synthesis requires a square selected plant in this project architecture.");
    end

    weights = parser.Results.Weights;
    if isempty(fieldnames(weights))
        weights = makePerformanceWeights(ny);
    end

    generalizedPlant = augw(GuncSquare, weights.Ws, weights.Wu, weights.Wt);
    [K, CLperf, info] = musyn(generalizedPlant, ny, nu);

    design = struct();
    design.K = K;
    design.weightedClosedLoop = CLperf;
    design.info = info;
    design.weights = weights;
    design.nominalClosedLoop = feedback(usubs(GuncSquare)*K, eye(ny));
    design.nominalStable = isstable(design.nominalClosedLoop);
    design.note = "D-K iteration on an illustrative uncertainty model; physical uncertainty identification remains required.";
end
