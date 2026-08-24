classdef TestPlantModel < matlab.unittest.TestCase
    % Regression tests for the source-derived 10-by-4 helicopter model.

    methods (Test)
        function legacyPlantHasExpectedDimensions(testCase)
            [G, meta] = buildHelicopterPlant("Variant","legacy");
            testCase.verifySize(G, [10 4]);
            testCase.verifyEqual(meta.g32DenominatorS3Coefficient, 87338);
        end

        function consistentVariantChangesOnlyDocumentedCoefficient(testCase)
            [Glegacy, ~] = buildHelicopterPlant("Variant","legacy");
            [Gcandidate, ~] = buildHelicopterPlant("Variant","consistent-denominator");
            [~, dLegacy] = tfdata(Glegacy(3,2), 'v');
            [~, dCandidate] = tfdata(Gcandidate(3,2), 'v');
            testCase.verifyEqual(dLegacy(6), 87338, 'AbsTol', 1e-9);
            testCase.verifyEqual(dCandidate(6), 8733, 'AbsTol', 1e-9);
        end

        function validationReportIsComplete(testCase)
            [G, meta] = buildHelicopterPlant;
            report = validatePlantModel(G, meta);
            testCase.verifyTrue(report.hasExpectedDimensions);
            testCase.verifyTrue(report.isProper);
            testCase.verifyEqual(report.dcRank, 4);
            testCase.verifyTrue(isfield(report, 'knownCoefficientAnomaly'));
        end
    end
end
