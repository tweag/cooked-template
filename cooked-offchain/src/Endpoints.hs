module Endpoints where

import Common
import Cooked qualified as C
import Plutus.Script.Utils.Value qualified as Script
import PlutusLedgerApi.V3 qualified as Api

pay :: (C.MonadBlockChain m) => C.Wallet -> Integer -> m Api.TxOutRef
pay wallet amount =
  head
    <$> C.validateTxSkel'
      ( C.txSkelTemplate
          { C.txSkelOuts = [wallet `C.receives` C.Value (Script.ada amount)],
            C.txSkelSigners = [carrie]
          }
      )
