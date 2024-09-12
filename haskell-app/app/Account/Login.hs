{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Account.Login where

import Web.Spock
import Web.Spock.Config

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)

import Account.Register 

--ログインのエンドポイント
loginUser :: Connection -> User -> IO Bool
loginUser conn user = do
    let q = "SELECT password FROM users WHERE name = ?"
    result <- query conn q (Only (userName user)) :: IO [Only String]
    case result of
        [Only pw] -> if pw == (userPassword user)
                        then return True
                        else return False
        _ -> return False
