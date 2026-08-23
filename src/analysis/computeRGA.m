function result = computeRGA(Gsquare, varargin)
%COMPUTERGA Compute the Relative Gain Array and a pairing recommendation.
%
% Lambda = G .* transpose(inv(G)) for a nonsingular square steady-state gain.
% PINV is used instead of INV to make the diagnostic numerically safer near
% singularity. The returned conditioning metric tells the user when the RGA
% should be interpreted cautiously.

    parser = inputParser;
    addParameter(parser, "Frequency", 0, @(x) isnumeric(x) && isscalar(x) && x >= 0);
    parse(parser, varargin{:});
    w = parser.Results.Frequency;

    [ny, nu] = size(Gsquare);
    if ny ~= nu
        error("HelicopterAnalysis:RGARequiresSquarePlant", ...
            "RGA requires a square plant; received %d-by-%d.", ny, nu);
    end

    if w == 0
        gain = dcgain(Gsquare);
    else
        gain = evalfr(Gsquare, 1i*w);
    end

    lambda = gain .* pinv(gain).';
    n = ny;
    candidates = perms(1:n);
    scores = inf(size(candidates,1),1);

    % A good pairing has selected RGA elements near +1. Negative selected RGA
    % elements are penalized heavily because they often indicate pairing risk.
    for k = 1:size(candidates,1)
        p = candidates(k,:);
        chosen = zeros(1,n);
        for i = 1:n
            chosen(i) = lambda(i,p(i));
        end
        scores(k) = sum(abs(chosen - 1)) + 10*nnz(real(chosen) < 0);
    end

    [score, idx] = min(scores);
    pairing = candidates(idx,:);  % pairing(outputIndex) = inputIndex

    result = struct();
    result.frequency = w;
    result.gain = gain;
    result.rga = lambda;
    result.conditionNumber = cond(gain);
    result.pairing = pairing;
    result.pairingScore = score;
    result.note = "Pairing is mathematical; physical actuator/output meaning must still be checked.";
end
