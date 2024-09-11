{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Web.Spock
import Web.Spock.Config

import Control.Monad.Trans
import Data.Monoid
import Data.IORef
import qualified Data.Text as T
import Database.PostgreSQL.Simple
import Data.Aeson

import Account.Register

data MySession = EmptySession
data MyAppState = DummyAppState (IORef Int)

data AppState = AppState { dbConn :: Connection }

main :: IO ()
main =
    do ref <- newIORef 0
       conn <- connectPostgreSQL "host=localhost dbname=postgres user=postgres password=fumifumiHaskell"
       let appState = AppState conn
       spockCfg <- defaultSpockCfg EmptySession PCNoDatabase appState
       runSpock 8080 (spock spockCfg app)

app :: SpockM () MySession AppState ()
app =
    do get root $
           text "Hello World!"
--       get ("hello" <//> var) $ \name ->
--           do (DummyAppState ref) <- getState
--              visitorNumber <- liftIO $ atomicModifyIORef' ref $ \i -> (i+1, i+1)
--              text ("Hello " <> name <> ", you are visitor number " <> T.pack (show visitorNumber))
       post "/api/register" $ do
           user <- jsonBody'
           state <- getState 
           liftIO $ registerUser (dbConn state) user
           Web.Spock.json ("User registerd" :: String)
