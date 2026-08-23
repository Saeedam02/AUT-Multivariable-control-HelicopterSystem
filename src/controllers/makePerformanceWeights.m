function weights = makePerformanceWeights(n, varargin)
%MAKEPERFORMANCEWEIGHTS Construct transparent mixed-sensitivity weights.
%
% Ws penalizes low-frequency tracking error, Wu penalizes control effort, and
% Wt penalizes high-frequency complementary sensitivity. These are illustrative
% starting weights, not experimentally justified helicopter specifications.

    parser = inputParser;
    addParameter(parser, "SensitivityLowGain", 10, @isPositiveScalar);
    addParameter(parser, "SensitivityCrossover", 1, @isPositiveScalar);
    addParameter(parser, "SensitivityHighGain", 0.1, @isPositiveScalar);
    addParameter(parser, "ControlWeight", 0.2, @isPositiveScalar);
    addParameter(parser, "ComplementaryLowGain", 0.01, @isPositiveScalar);
    addParameter(parser, "ComplementaryCrossover", 15, @isPositiveScalar);
    addParameter(parser, "ComplementaryHighGain", 5, @isPositiveScalar);
    parse(parser, varargin{:});

    Ws0 = makeweight(parser.Results.SensitivityLowGain, ...
        parser.Results.SensitivityCrossover, parser.Results.SensitivityHighGain);
    Wt0 = makeweight(parser.Results.ComplementaryLowGain, ...
        parser.Results.ComplementaryCrossover, parser.Results.ComplementaryHighGain);

    weights = struct();
    weights.Ws = Ws0 * eye(n);
    weights.Wu = parser.Results.ControlWeight * eye(n);
    weights.Wt = Wt0 * eye(n);
    weights.note = "Illustrative design weights; replace with physical requirements.";
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
