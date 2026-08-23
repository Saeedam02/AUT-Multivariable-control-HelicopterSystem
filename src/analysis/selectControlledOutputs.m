function selection = selectControlledOutputs(G, varargin)
%SELECTCONTROLLEDOUTPUTS Select a numerically well-conditioned 4-output subset.
%
% The original repository does not identify which of the ten outputs should be
% controlled. For reproducible controller demonstrations, this helper searches
% all combinations of nu outputs and chooses the full-rank DC-gain submatrix
% with the smallest condition number.
%
% This is a NUMERICAL demonstration choice, not a physical control objective.
% When the true output meanings are recovered, pass those physical output
% indices explicitly to the example/controller scripts instead.

    parser = inputParser;
    addParameter(parser, "Frequency", 0, @(x) isnumeric(x) && isscalar(x) && x >= 0);
    parse(parser, varargin{:});
    w = parser.Results.Frequency;

    [ny, nu] = size(G);
    if ny < nu
        error("HelicopterAnalysis:TooFewOutputs", ...
            "Output-subset selection requires ny >= nu.");
    end

    if w == 0
        gain = dcgain(G);
    else
        gain = evalfr(G, 1i*w);
    end

    combos = nchoosek(1:ny, nu);
    bestCond = Inf;
    bestRows = [];
    bestGain = [];

    for k = 1:size(combos,1)
        rows = combos(k,:);
        sub = gain(rows,:);
        if all(isfinite(sub), "all") && rank(sub) == nu
            c = cond(sub);
            if c < bestCond
                bestCond = c;
                bestRows = rows;
                bestGain = sub;
            end
        end
    end

    if isempty(bestRows)
        error("HelicopterAnalysis:NoFullRankOutputSubset", ...
            "No full-rank %d-by-%d output subset was found.", nu, nu);
    end

    selection = struct();
    selection.outputIndices = bestRows;
    selection.conditionNumber = bestCond;
    selection.gainMatrix = bestGain;
    selection.frequency = w;
    selection.method = "minimum condition number among full-rank output subsets";
    selection.isPhysicalRecommendation = false;
end
