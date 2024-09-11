{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Account.Register where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)

--User型の定義
data User = User
    { userName :: String
    , userPassword :: String
    } deriving (Show, Generic)

instance FromJSON User
instance ToJSON User
instance FromRow User
instance ToRow User

-- 新規ユーザ登録エンドポイント
registerUser :: Connection -> User -> IO ()
registerUser conn (User name password) = do -- registerUser アプリの状態 ユーザ情報
    let query = "INSERT INTO users (name, password) VALUES (?, ?)" -- クエリを定義
    execute conn query (name, password) -- クエリに沿ってデータベース操作
    return ()
