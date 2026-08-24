function report = validatePlantModel(G, meta, varargin)
%VALIDATEPLANTMODEL Perform structural sanity checks on the helicopter model.
%
% This function intentionally checks what can be established from the model
% itself without inventing undocumented physics. Transmission-zero computation
% is optional because converting a large transfer matrix to one realization can
% be expensive on CI runners.

    if nargin < 2 || isempty(meta)
        meta = struct();
    end

    parser = inputParser;
    addParameter(parser, "ComputeTransmissionZeros", false, ...
        @(x) islogical(x) || isnumeric(x));
    parse(parser, varargin{:});

    [ny, nu] = size(G);
    report = struct();
    report.size = [ny, nu];
    report.hasExpectedDimensions = isequal([ny, nu], [10, 4]);
    report.isProper = isproper(G);

    p = pole(G);
    report.poles = p;
    report.numberOfPoles = numel(p);
    report.numberOfOpenLoopUnstablePoles = nnz(real(p) > 1e-8);
    report.numberOfNearImaginaryAxisPoles = nnz(abs(real(p)) <= 1e-8);
    report.openLoopStable = report.numberOfOpenLoopUnstablePoles == 0 && ...
        report.numberOfNearImaginaryAxisPoles == 0;

    if logical(parser.Results.ComputeTransmissionZeros)
        try
            report.transmissionZeros = tzero(ss(G));
            report.transmissionZeroStatus = "computed";
        catch ME
            report.transmissionZeros = NaN;
            report.transmissionZeroStatus = "failed: " + string(ME.message);
        end
    else
        report.transmissionZeros = [];
        report.transmissionZeroStatus = "not requested";
    end

    g0 = dcgain(G);
    report.dcGain = g0;
    report.dcGainFinite = all(isfinite(g0), "all");
    report.dcRank = rank(g0);

    if isfield(meta, "knownAnomaly")
        report.knownCoefficientAnomaly = meta.knownAnomaly;
    else
        report.knownCoefficientAnomaly = struct();
    end

    if ~report.hasExpectedDimensions
        error("HelicopterModel:UnexpectedDimensions", ...
            "Expected a 10-by-4 plant but received %d-by-%d.", ny, nu);
    end

    if ~report.isProper
        warning("HelicopterModel:ImproperPlant", ...
            "At least one transfer-function channel is improper.");
    end
end
