module Main where

import Common
import Cooked qualified as C
import Cooked.MockChain.Staged qualified as C
import Test.Tasty qualified as Tasty
import Test.Tasty.HUnit qualified as Tasty
import Traces qualified as T

main :: IO ()
main = Tasty.defaultMain allTests

-- | All tests for which a successful output is expected. Provide the name of
-- the test and the run for each of those tests.
expectedSuccessfulOutcome :: [(String, C.StagedMockChain ())]
expectedSuccessfulOutcome =
  [ ("We can execute an empty trace", return ()),
    ("We can pay to bob and alice", T.pay)
  ]

expectedUnsuccessfulOutcome :: [(String, C.StagedMockChain ())]
expectedUnsuccessfulOutcome =
  [ ("We can't execute an error", fail "error")
  ]

toMustSucceedTest :: (String, C.StagedMockChain ()) -> Tasty.TestTree
toMustSucceedTest (s, r) =
  Tasty.testCase s $
    C.testToProp $
      C.mustSucceedTest r
        `C.withInitDist` initialDistribution

toMustFailTest :: (String, C.StagedMockChain ()) -> Tasty.TestTree
toMustFailTest (s, r) =
  Tasty.testCase s $
    C.testToProp $
      C.mustFailTest r
        `C.withInitDist` initialDistribution

allTests :: Tasty.TestTree
allTests =
  Tasty.testGroup
    "Test suite"
    [ Tasty.testGroup "Expected successes" $ toMustSucceedTest <$> expectedSuccessfulOutcome,
      Tasty.testGroup "Exepcted failures" $ toMustFailTest <$> expectedUnsuccessfulOutcome
    ]
