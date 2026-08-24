classdef TestRobustness < matlab.unittest.TestCase
    methods (Test)
        function uncertainPlantPreservesDimensions(testCase)
            s = tf('s');
            G = append(1/(s+1), 1/(s+2), 1/(s+3), 1/(s+4));
            [Gunc, u] = buildUncertainPlant(G);
            testCase.verifySize(Gunc, [4 4]);
            testCase.verifyEqual(u.type, "output multiplicative");
        end

        function robustStabilityReturnsMarginForSimpleLoop(testCase)
            s = tf('s');
            G = append(1/(s+1), 1/(s+2), 1/(s+3), 1/(s+4));
            [Gunc, ~] = buildUncertainPlant(G, ...
                "LowFrequencyFraction",0.01, "HighFrequencyFraction",0.05);
            K = 0.2*eye(4);
            result = analyzeRobustStability(Gunc,K);
            testCase.verifyTrue(result.nominalStable);
            testCase.verifyTrue(isstruct(result.margin));
        end
    end
end
