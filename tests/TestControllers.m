classdef TestControllers < matlab.unittest.TestCase
    methods (Test)
        function decentralizedControllerHasCompatibleDimensions(testCase)
            s = tf('s');
            G = append(1/(s+1), 1/(s+2), 1/(s+3), 1/(s+4));
            design = designDecentralizedPI(G, "Pairing", 1:4);
            testCase.verifySize(design.K, [4 4]);
            testCase.verifySize(design.closedLoop, [4 4]);
        end

        function lqiBenchmarkBuildsSquareClosedLoop(testCase)
            s = tf('s');
            G = append(1/(s+1), 1/(s+2), 1/(s+3), 1/(s+4));
            design = designLQIController(G);
            testCase.verifySize(design.closedLoop, [4 4]);
            testCase.verifyTrue(design.nominalStable);
        end

        function performanceWeightsHaveCorrectDimensions(testCase)
            W = makePerformanceWeights(4);
            testCase.verifySize(W.Ws, [4 4]);
            testCase.verifySize(W.Wu, [4 4]);
            testCase.verifySize(W.Wt, [4 4]);
        end
    end
end
