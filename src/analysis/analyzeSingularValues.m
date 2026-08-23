function result = analyzeSingularValues(G, varargin)
%ANALYZESINGULARVALUES Compute and optionally plot all singular-value traces.
%
% This function fixes a bug in the legacy RobustStability/RobustPerformance
% scripts, which computed a "maximum" using only the first three singular
% values. Here the maximum is taken over EVERY singular value at each frequency.

    parser = inputParser;
    addParameter(parser, "Frequency", logspace(-2, 3, 400), @isnumeric);
    addParameter(parser, "Plot", true, @(x) islogical(x) || isnumeric(x));
    addParameter(parser, "FigureTitle", "Singular-value analysis", @(x) ischar(x) || isstring(x));
    parse(parser, varargin{:});

    w = parser.Results.Frequency(:).';
    sv = sigma(G, w);
    sv = squeeze(sv);
    if isvector(sv)
        sv = reshape(sv, 1, []);
    end

    sigmaMax = max(sv, [], 1);
    sigmaMin = min(sv, [], 1);

    result = struct();
    result.frequency = w;
    result.singularValues = sv;
    result.sigmaMax = sigmaMax;
    result.sigmaMin = sigmaMin;
    result.conditionNumber = sigmaMax ./ max(sigmaMin, eps);

    if logical(parser.Results.Plot)
        figure('Name', char(parser.Results.FigureTitle));
        semilogx(w, 20*log10(max(sv.', realmin)), 'LineWidth', 1.0);
        grid on;
        xlabel('Frequency (rad/s)');
        ylabel('Singular value (dB)');
        title(parser.Results.FigureTitle);
    end
end
