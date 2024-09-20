{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Video.Process where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import GHC.Generics (Generic)
import qualified Data.ByteString.Lazy as BS
import qualified Data.Text as T
import Data.Text.Encoding
import Network.HTTP
import Network.HTTP.Simple
import qualified Codec.Binary.UTF8.String as CBUS

data Picture = Picture { getPicture :: T.Text } deriving (Show, Generic)

instance FromJSON Picture
instance ToJSON Picture

data Status = Status { status :: String } deriving (Show, Generic)

instance FromJSON Status
instance ToJSON Status

isAwake :: Picture -> IO String
isAwake p = do
    let picture = encode p
        pythonServerURL = "http://localhost:5000/upload"
        request = setRequestMethod "POST"
                $ Network.HTTP.Simple.setRequestBodyLBS picture
                $ Network.HTTP.Simple.setRequestHeader "Content-Type" ["application/json"]
                $ parseRequest_ pythonServerURL
    response <- httpLBS request
    return $ CBUS.decode (BS.unpack (Network.HTTP.Simple.getResponseBody response))
