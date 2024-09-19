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
        {userDataID :: Int
        ,userDataName :: String
        ,userDataPassword :: String
        ,userDataStudyTime :: Int
        ,userDataScore :: Int
        } deriving (Show, Generic)

instance ToJSON UserData
instance FromJSON UserData
instance ToRow UserData
instance FromRow UserData

data FriendID = FriendID { friendID :: Int } deriving (Show, Generic)

instance ToJSON FriendID
instance FromJSON FriendID
instance ToRow FriendID
instance FromRow FriendID
