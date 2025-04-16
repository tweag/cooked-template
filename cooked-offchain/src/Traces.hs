module Traces where

import Common
import Control.Monad
import Cooked qualified as C
import Endpoints qualified as EP

-- | An example trace which calls the dummy endpoints
pay :: (C.MonadModalBlockChain m) => m ()
pay = do
  EP.pay alice 10
  void $ EP.pay bob 20
