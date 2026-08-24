function [Gunc, uncertainty] = buildUncertainPlant(Gnom, varargin)
%BUILDUNCERTAINPLANT Add normalized output-multiplicative dynamic uncertainty.
%
%   Gunc = (I + WDelta*DeltaY) * Gnom
%
% where ||DeltaY||_inf <= 1. This is a transparent uncertainty model used for
% robust-control demonstrations. It is NOT claimed to be physically identified
% from helicopter experiments; the weighting function must be replaced when
% measured/model-validation data become available.
%
% Name-value options:
%   LowFrequencyFraction  default 0.05  (5 percent)
%   CrossoverFrequency   default 10 rad/s
%   HighFrequencyFraction default 0.30 (30 percent)
%
% Requires: Robust Control Toolbox.

    parser = inputParser;
    addParameter(parser, "LowFrequencyFraction", 0.05, @isPositiveScalar);
    addParameter(parser, "CrossoverFrequency", 10, @isPositiveScalar);
    addParameter(parser, "HighFrequencyFraction", 0.30, @isPositiveScalar);
    parse(parser, varargin{:});

    [ny, ~] = size(Gnom);
    low = parser.Results.LowFrequencyFraction;
    wc = parser.Results.CrossoverFrequency;
    high = parser.Results.HighFrequencyFraction;

    Wscalar = makeweight(low, wc, high);
    WDelta = Wscalar * eye(ny);
    DeltaY = ultidyn('DeltaY', [ny ny], 'Bound', 1);

    Gunc = (eye(ny) + WDelta * DeltaY) * Gnom;
    Gunc.InputName = Gnom.InputName;
    Gunc.OutputName = Gnom.OutputName;
    Gunc.Name = char(string(Gnom.Name) + " with output-multiplicative uncertainty");

    uncertainty = struct();
    uncertainty.type = "output multiplicative";
    uncertainty.WDelta = WDelta;
    uncertainty.DeltaY = DeltaY;
    uncertainty.lowFrequencyFraction = low;
    uncertainty.crossoverFrequency = wc;
    uncertainty.highFrequencyFraction = high;
    uncertainty.note = [ ...
        "Illustrative robust-control uncertainty model only. ", ...
        "Replace the weight using experimental model-validation data."];
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
