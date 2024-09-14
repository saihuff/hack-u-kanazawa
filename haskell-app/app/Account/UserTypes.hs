{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Account.UserTypes where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T

data User = User
        {userName :: String
        ,userPassword :: String
        } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User
instance ToRow User
instance FromRow User

data UserData = UserData
        {userDataID :: Integer
        ,userDataName :: String
        ,userDataPassword :: String
        ,userDataStudyTime :: Integer
        } deriving (Show, Generic)

instance ToJSON UserData
instance FromJSON UserData
instance ToRow UserData
instance FromRow UserData
