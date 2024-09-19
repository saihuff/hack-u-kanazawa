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

import Account.UserTypes

getUserData :: Connection -> Int -> IO UserData
getUserData conn userid = do
    let q = "SELECT name FROM users WHERE id = ?"
        r = "SELECT password FROM users WHERE id = ?"
        s = "SELECT time FROM users WHERE id = ?"
        t = "SELECT score FROM users WHERE id = ?"
    [user] <- query conn q (Only userid) :: IO [Only String]
    [pw] <- query conn r (Only userid) :: IO [Only String]
    [tm] <- query conn s (Only userid) :: IO [Only Int]
    [sc] <- query conn t (Only userid) :: IO [Only Int]
    return $ UserData userid (fromOnly user) (fromOnly pw) (fromOnly tm) (fromOnly sc)

getUserID :: Connection -> User -> IO Int
getUserID conn user = do
    let q = "SELECT name FROM users WHERE name = ?"
    [result] <- query conn q (Only (userName user)) :: IO [Only Int]
    return $ fromOnly result
