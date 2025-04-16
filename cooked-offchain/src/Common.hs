module Common where

import Cooked qualified as C
import Cooked.MockChain.Staged qualified as C
import Data.Default
import Plutus.Script.Utils.Value qualified as Script

alice :: C.Wallet
alice = C.wallet 1

bob :: C.Wallet
bob = C.wallet 2

carrie :: C.Wallet
carrie = C.wallet 3

-- | Custom pretty cooked options for this project
pcOpts :: C.PrettyCookedOpts
pcOpts =
  def
    { C.pcOptHashes =
        def
          { C.pcOptHashNames =
              C.hashNamesFromList
                [ (alice, "Alice"),
                  (bob, "Bob"),
                  (carrie, "Carrie")
                ]
                <> C.defaultHashNames -- IMPORTANT: must be the last element
          },
      C.pcOptPrintLog = False
    }

-- | A custom initial distribution for this project
initialDistribution :: C.InitialDistribution
initialDistribution =
  C.InitialDistribution (replicate 3 $ alice `C.receives` C.Value (Script.ada 100))
    <> C.distributionFromList [(bob, replicate 3 $ Script.ada 100), (carrie, replicate 2 $ Script.ada 50)]

-- | Prints a trace using 'pcOpts' and 'initialDistribution'
printTrace :: (Show a) => C.StagedMockChain a -> C.DocCooked
printTrace =
  C.prettyCookedOpt pcOpts
    . C.interpretAndRunWith (C.runMockChainTFrom initialDistribution)
