{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Game.GameTypes where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Data.Either (rights)
import Data.Time.Clock

data Score = Score { score :: Int } deriving (Show, Generic)

instance ToJSON Score
instance FromJSON Score
instance ToRow Score
instance FromRow Score
