{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Account.Userdata where

import Web.Spock
import Web.Spock.Config

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)

import Account.Register

getUserData :: Connection -> String -> IO String
getUserData conn user = do
    let q = "SELECT id FROM users WHERE name = ?"
        r = "SELECT password FROM users WHERE name = ?"
        s = "SELECT time FROM users WHERE name = ?"
    id <- query conn q (Only user) :: IO [Only Integer]
    pw <- query conn r (Only user) :: IO [Only String]
    tm <- query conn s (Only user) :: IO [Only Integer]
    return $ user ++ show id ++ show pw ++ show tm
