function design = designDecentralizedPI(Gsquare, varargin)
%DESIGNDECENTRALIZEDPI Build an RGA-paired decentralized PI baseline.
%
% Each output is paired with one input using the DC RGA, each paired SISO channel
% is tuned with PIDTUNE, and the resulting SISO controllers are assembled into a
% sparse 4-by-4 MIMO controller. Interactions are intentionally ignored by the
% tuning step, making this a useful baseline rather than the final robust design.

    parser = inputParser;
    addParameter(parser, "Pairing", [], @isnumeric);
    addParameter(parser, "Bandwidth", [], @isnumeric);
    parse(parser, varargin{:});

    [ny, nu] = size(Gsquare);
    if ny ~= nu
        error("HelicopterController:SquarePlantRequired", ...
            "Decentralized PI design requires a square controlled subplant.");
    end
    n = ny;

    if isempty(parser.Results.Pairing)
        rga = computeRGA(Gsquare);
        pairing = rga.pairing;
    else
        pairing = parser.Results.Pairing(:).';
        if ~isequal(sort(pairing), 1:n)
            error("HelicopterController:InvalidPairing", ...
                "Pairing must be a permutation of 1:%d.", n);
        end
    end

    controllers = cell(1,n);
    for output = 1:n
        input = pairing(output);
        channel = minreal(Gsquare(output,input));
        if isempty(parser.Results.Bandwidth)
            controllers{output} = pidtune(channel, "PI");
        else
            controllers{output} = pidtune(channel, "PI", parser.Results.Bandwidth);
        end
    end

    % CDIAG maps one controller output per controlled output. P then routes each
    % controller output to the physical input chosen by the RGA pairing.
    Cdiag = append(controllers{:});
    P = zeros(n);
    for output = 1:n
        P(pairing(output), output) = 1;
    end
    K = P * Cdiag;
    K.InputName = cellstr(compose("e%d", 1:n));
    K.OutputName = cellstr(compose("u%d", 1:n));
    K.Name = "RGA-paired decentralized PI";

    design = struct();
    design.K = K;
    design.pairing = pairing;
    design.controllers = controllers;
    design.closedLoop = feedback(Gsquare*K, eye(n));
    design.nominalStable = isstable(design.closedLoop);
    design.note = "Baseline design: each SISO loop is tuned without explicit MIMO interaction compensation.";
end
