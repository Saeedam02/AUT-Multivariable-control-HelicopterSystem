function result = analyzeRobustStability(Gunc, K)
%ANALYZEROBUSTSTABILITY Compute structured robust-stability margins.
%
% Unlike the legacy script, which only inspected nominal singular values, this
% function calls ROBSTAB on an uncertain closed-loop model. The reported margin
% therefore respects the uncertainty blocks present in Gunc.

    ny = size(Gunc,1);
    L = Gunc*K;
    Tunc = feedback(L, eye(ny));

    [margin, worstCase] = robstab(Tunc);

    result = struct();
    result.closedLoop = Tunc;
    result.margin = margin;
    result.worstCaseUncertainty = worstCase;
    result.nominalStable = isstable(usubs(Tunc));
    result.interpretation = [ ...
        "A robust-stability margin above 1 indicates that the modeled normalized ", ...
        "uncertainty can be enlarged before destabilization. A margin below 1 ", ...
        "means the specified uncertainty set is not certified stable."];
end
