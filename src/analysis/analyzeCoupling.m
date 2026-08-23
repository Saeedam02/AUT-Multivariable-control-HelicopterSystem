function result = analyzeCoupling(Gsquare, varargin)
%ANALYZECOUPLING Quantify MIMO interaction using RGA and conditioning.

    parser = inputParser;
    addParameter(parser, "Frequency", logspace(-2, 3, 300), @isnumeric);
    addParameter(parser, "Plot", true, @(x) islogical(x) || isnumeric(x));
    parse(parser, varargin{:});

    [ny, nu] = size(Gsquare);
    if ny ~= nu
        error("HelicopterAnalysis:CouplingRequiresSquarePlant", ...
            "Coupling analysis expects a square controlled subplant.");
    end

    rga0 = computeRGA(Gsquare);
    w = parser.Results.Frequency(:).';
    kappa = nan(size(w));
    for k = 1:numel(w)
        Gw = freqresp(Gsquare, w(k));
        singular = svd(Gw(:,:,1));
        if isempty(singular) || min(singular) <= eps
            kappa(k) = Inf;
        else
            kappa(k) = max(singular)/min(singular);
        end
    end

    result = struct();
    result.dcRGA = rga0.rga;
    result.dcPairing = rga0.pairing;
    result.dcConditionNumber = rga0.conditionNumber;
    result.niederlinski = computeNiederlinskiIndex(Gsquare, "Pairing", rga0.pairing);
    result.frequency = w;
    result.conditionNumber = kappa;

    if logical(parser.Results.Plot)
        figure('Name','MIMO coupling condition number');
        loglog(w, kappa, 'LineWidth', 1.5);
        grid on;
        xlabel('Frequency (rad/s)');
        ylabel('Condition number');
        title('Directional conditioning of the controlled subplant');
    end
end
