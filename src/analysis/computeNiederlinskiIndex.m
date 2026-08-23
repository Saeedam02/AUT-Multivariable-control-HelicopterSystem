function result = computeNiederlinskiIndex(Gsquare, varargin)
%COMPUTENIEDERLINSKIINDEX Compute the steady-state Niederlinski Index (NI).
%
% For a chosen decentralized pairing, the columns are permuted so the paired
% channels lie on the diagonal and
%
%       NI = det(G0) / prod(diag(G0)).
%
% A negative NI is a classical warning that integral decentralized control with
% that pairing cannot yield a stable closed loop under the standard assumptions.
% A positive NI is NOT by itself a stability guarantee.

    parser = inputParser;
    addParameter(parser, "Pairing", [], @isnumeric);
    parse(parser, varargin{:});

    [ny, nu] = size(Gsquare);
    if ny ~= nu
        error("HelicopterAnalysis:NIRequiresSquarePlant", ...
            "Niederlinski Index requires a square steady-state gain matrix.");
    end

    if isempty(parser.Results.Pairing)
        rga = computeRGA(Gsquare);
        pairing = rga.pairing;
    else
        pairing = parser.Results.Pairing(:).';
    end

    G0 = dcgain(Gsquare);
    Gpaired = G0(:, pairing);
    diagonalProduct = prod(diag(Gpaired));

    result = struct();
    result.pairing = pairing;
    result.pairedGain = Gpaired;
    result.diagonalProduct = diagonalProduct;
    if abs(diagonalProduct) <= eps * max(1, norm(Gpaired,1)^ny)
        result.value = NaN;
        result.interpretation = "Undefined/ill-conditioned because a paired steady-state gain is near zero.";
    else
        result.value = det(Gpaired) / diagonalProduct;
        if real(result.value) < 0
            result.interpretation = "Negative NI: classical decentralized integral-control warning.";
        else
            result.interpretation = "Positive NI: necessary warning test passed; not a stability guarantee.";
        end
    end
end
