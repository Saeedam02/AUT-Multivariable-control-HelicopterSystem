function result = computeMuBounds(uncertainSystem, varargin)
%COMPUTEMUBOUNDS Compute structured singular-value bounds for robust stability.
%
% LFTDATA returns M and normalized Delta such that the uncertain system is an
% LFT. Robust stability concerns the M11 block seen directly by Delta. MUSSV is
% therefore applied to that block, not indiscriminately to the full external
% input/output interconnection.

    parser = inputParser;
    addParameter(parser, "Frequency", logspace(-2,3,250), @isnumeric);
    addParameter(parser, "Plot", true, @(x) islogical(x) || isnumeric(x));
    parse(parser, varargin{:});

    [M, Delta, blk] = lftdata(uncertainSystem);
    [deltaRows, deltaCols] = size(Delta);

    % For upper-LFT convention, M11 maps Delta output back to Delta input and
    % therefore has dimensions deltaCols-by-deltaRows.
    M11 = M(1:deltaCols, 1:deltaRows);

    w = parser.Results.Frequency(:).';
    M11frd = frd(M11, w);
    bounds = mussv(M11frd, blk, 'c');
    data = squeeze(bounds.ResponseData);

    if size(data,1) == 2
        upper = real(data(1,:));
        lower = real(data(2,:));
    elseif size(data,2) == 2
        upper = real(data(:,1)).';
        lower = real(data(:,2)).';
    else
        error("HelicopterRobustness:UnexpectedMuShape", ...
            "Unexpected MUSSV bound dimensions.");
    end

    result = struct();
    result.frequency = w;
    result.upperBound = upper;
    result.lowerBound = lower;
    result.blockStructure = blk;
    result.M11 = M11;

    if logical(parser.Results.Plot)
        figure('Name','Structured singular value bounds');
        semilogx(w, upper, 'LineWidth', 1.5); hold on;
        semilogx(w, lower, '--', 'LineWidth', 1.2);
        yline(1, ':', '\mu = 1');
        grid on;
        xlabel('Frequency (rad/s)');
        ylabel('\mu bound');
        legend('Upper bound','Lower bound','Critical value', 'Location','best');
        title('Structured robust-stability \mu bounds');
    end
end
