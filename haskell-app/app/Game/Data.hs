{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Game.Data where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Data.Either (rights)

import Game.GameTypes

updateScore :: Connection -> Int -> Int -> IO ()
updateScore conn userid newscore = do
    let q = "UPDATE users SET score = score + ? WHERE id = ?"
    execute conn q (newscore, userid)
    return ()
