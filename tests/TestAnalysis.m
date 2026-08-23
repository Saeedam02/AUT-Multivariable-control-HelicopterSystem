classdef TestAnalysis < matlab.unittest.TestCase
    methods (Test)
        function outputSelectorReturnsFourUniqueRows(testCase)
            G = buildHelicopterPlant;
            result = selectControlledOutputs(G);
            testCase.verifyNumElements(result.outputIndices, 4);
            testCase.verifyNumElements(unique(result.outputIndices), 4);
            testCase.verifyTrue(isfinite(result.conditionNumber));
        end

        function identityPlantHasIdentityRGA(testCase)
            G = tf(eye(4));
            result = computeRGA(G);
            testCase.verifyEqual(result.rga, eye(4), 'AbsTol', 1e-12);
            testCase.verifyEqual(sort(result.pairing), 1:4);
        end


        function identityPlantHasNiederlinskiIndexOne(testCase)
            G = tf(eye(4));
            result = computeNiederlinskiIndex(G, "Pairing", 1:4);
            testCase.verifyEqual(result.value, 1, 'AbsTol', 1e-12);
        end


        function controllerEvaluatorReturnsFiniteSensitivityMetrics(testCase)
            s = tf('s');
            G = append(1/(s+1), 1/(s+2), 1/(s+3), 1/(s+4));
            K = 0.2*eye(4);
            metrics = evaluateController(G, K, "StepHorizon", 2);
            testCase.verifyTrue(metrics.nominalStable);
            testCase.verifyTrue(isfinite(metrics.peakSensitivity));
            testCase.verifyTrue(isfinite(metrics.peakComplementarySensitivity));
        end

        function singularValueMaximumUsesEveryChannel(testCase)
            % The fourth singular value is intentionally the largest. This is a
            % regression test for the legacy code that only checked rows 1:3.
            G = tf(diag([1 2 3 50]));
            result = analyzeSingularValues(G, "Frequency", [1 10], "Plot", false);
            testCase.verifyEqual(result.sigmaMax, [50 50], 'AbsTol', 1e-10);
        end
    end
end
