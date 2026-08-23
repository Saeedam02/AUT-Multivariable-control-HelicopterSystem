function metrics = evaluateController(Gsquare, K, varargin)
%EVALUATECONTROLLER Compute comparable nominal MIMO closed-loop metrics.
%
% Metrics include stability, peak singular values of S/T/KS over a frequency
% grid, and per-output unit-step tracking statistics for the diagonal reference
% channels. These are summary diagnostics; they do not replace robust analysis.

    parser = inputParser;
    addParameter(parser, "Frequency", logspace(-3,3,600), @isnumeric);
    addParameter(parser, "StepHorizon", 10, @isPositiveScalar);
    parse(parser, varargin{:});

    ny = size(Gsquare,1);
    L = Gsquare*K;
    S = feedback(eye(ny), L);
    T = feedback(L, eye(ny));
    KS = K*S;

    sS = analyzeSingularValues(S, "Frequency", parser.Results.Frequency, "Plot", false);
    sT = analyzeSingularValues(T, "Frequency", parser.Results.Frequency, "Plot", false);
    sKS = analyzeSingularValues(KS, "Frequency", parser.Results.Frequency, "Plot", false);

    CL = T;
    t = linspace(0, parser.Results.StepHorizon, 1200);
    y = step(CL, t);
    diagonalInfo = repmat(struct("RiseTime",NaN,"SettlingTime",NaN, ...
        "Overshoot",NaN,"Peak",NaN), ny, 1);

    for i = 1:ny
        yi = squeeze(y(:,i,i));
        try
            info = stepinfo(yi, t, 1);
            diagonalInfo(i).RiseTime = info.RiseTime;
            diagonalInfo(i).SettlingTime = info.SettlingTime;
            diagonalInfo(i).Overshoot = info.Overshoot;
            diagonalInfo(i).Peak = info.Peak;
        catch
            % Keep NaNs for channels whose response does not admit standard
            % step-info interpretation (e.g., unstable/non-settling).
        end
    end

    metrics = struct();
    metrics.nominalStable = isstable(CL);
    metrics.peakSensitivity = max(sS.sigmaMax);
    metrics.peakComplementarySensitivity = max(sT.sigmaMax);
    metrics.peakControlSensitivity = max(sKS.sigmaMax);
    metrics.diagonalStepInfo = diagonalInfo;
    metrics.closedLoop = CL;
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
