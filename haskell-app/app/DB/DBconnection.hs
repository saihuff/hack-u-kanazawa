{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module DB.DBconnection where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T

import Account.UserTypes

-- 新規ユーザ登録エンドポイント
getFriendCode :: Connection -> Int -> IO Int
getFriendCode conn userid = do
    let q = "SELECT friend_id FROM friends WHERE user_id = ?"
    [result] <- query conn q (Only userid) :: IO [Only Int]
    return $ fromOnly result
