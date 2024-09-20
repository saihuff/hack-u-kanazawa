{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Game.Logic where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Data.Either (rights)
import Data.Time.Clock

import Game.GameTypes

saveStartTime :: Connection -> Int -> IO ()
saveStartTime conn userid = do
    now <- getCurrentTime
    let q = "UPDATE users SET starttime = ? WHERE id = ?"
    execute conn q (Only now)
    return ()
