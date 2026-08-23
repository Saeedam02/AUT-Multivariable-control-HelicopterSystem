function design = designLQIController(Gsquare, varargin)
%DESIGNLQICONTROLLER Design an integral full-state LQR benchmark.
%
% The transfer-function plant is converted to a minimal state-space realization.
% Because those states are realization coordinates rather than documented
% physical helicopter states, this controller is a simulation/design benchmark.
% A deployable implementation would need measured states or an observer.

    parser = inputParser;
    addParameter(parser, "StateWeight", 1, @isPositiveScalar);
    addParameter(parser, "IntegralWeight", 20, @isPositiveScalar);
    addParameter(parser, "ControlWeight", 1, @isPositiveScalar);
    parse(parser, varargin{:});

    P = minreal(ss(Gsquare));
    [A,B,C,D] = ssdata(P);
    nx = size(A,1);
    ny = size(C,1);
    nu = size(B,2);

    if ny ~= nu
        error("HelicopterController:LQIRequiresSquareControlledPlant", ...
            "This LQI benchmark expects the selected controlled plant to be square.");
    end

    % Integral state xi obeys xi_dot = r - y.
    Aaug = [A, zeros(nx,ny); -C, zeros(ny,ny)];
    Baug = [B; -D];
    Q = blkdiag(parser.Results.StateWeight*eye(nx), ...
        parser.Results.IntegralWeight*eye(ny));
    R = parser.Results.ControlWeight*eye(nu);

    Kaug = lqr(Aaug, Baug, Q, R);
    Kx = Kaug(:,1:nx);
    Ki = Kaug(:,nx+1:end);

    % Closed-loop realization from reference r to output y.
    Acl = [A-B*Kx, -B*Ki; -C+D*Kx, D*Ki];
    Bcl = [zeros(nx,ny); eye(ny)];
    Ccl = [C-D*Kx, -D*Ki];
    Dcl = zeros(ny);
    CL = ss(Acl,Bcl,Ccl,Dcl);
    CL.InputName = cellstr(compose("r%d",1:ny));
    CL.OutputName = cellstr(compose("y%d",1:ny));
    CL.Name = "LQI reference-tracking benchmark";

    design = struct();
    design.Kx = Kx;
    design.Ki = Ki;
    design.closedLoop = CL;
    design.nominalStable = isstable(CL);
    design.stateSpacePlant = P;
    design.note = "Simulation benchmark; an observer/state measurement strategy is required for implementation.";
end

function tf = isPositiveScalar(x)
    tf = isnumeric(x) && isscalar(x) && isfinite(x) && x > 0;
end
