function report = analyzeNominalPlant(G, varargin)
%ANALYZENOMINALPLANT Run the main nominal MIMO diagnostics in one call.
%
% The function reports poles/zeros, selects a reproducible square subplant,
% computes its RGA/pairing, and evaluates singular-value conditioning.

    parser = inputParser;
    addParameter(parser, "OutputIndices", [], @isnumeric);
    addParameter(parser, "Plot", true, @(x) islogical(x) || isnumeric(x));
    addParameter(parser, "Frequency", logspace(-2,3,400), @isnumeric);
    parse(parser, varargin{:});

    structural = validatePlantModel(G);
    if isempty(parser.Results.OutputIndices)
        selection = selectControlledOutputs(G);
        outputIdx = selection.outputIndices;
    else
        outputIdx = parser.Results.OutputIndices(:).';
        if numel(outputIdx) ~= size(G,2)
            error("HelicopterAnalysis:WrongControlledOutputCount", ...
                "Choose exactly %d outputs.", size(G,2));
        end
        selection = struct("outputIndices", outputIdx, ...
            "isPhysicalRecommendation", true, ...
            "method", "user supplied");
    end

    Gc = G(outputIdx,:);
    rga = computeRGA(Gc);
    sv = analyzeSingularValues(Gc, "Frequency", parser.Results.Frequency, ...
        "Plot", parser.Results.Plot, "FigureTitle", "Controlled-subplant singular values");
    coupling = analyzeCoupling(Gc, "Frequency", parser.Results.Frequency, ...
        "Plot", parser.Results.Plot);

    report = struct();
    report.structural = structural;
    report.selection = selection;
    report.controlledPlant = Gc;
    report.rga = rga;
    report.singularValues = sv;
    report.coupling = coupling;
end
