{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import Web.Spock
import Web.Spock.Config
import Web.Spock.SessionActions

import Control.Monad.Trans
import Data.Monoid
import Data.IORef
import qualified Data.Text as T
import Database.PostgreSQL.Simple
import Data.Aeson

import Account.Register (User, userName, registerUser)
import Account.Login (loginUser)

data MySession = MySession (Maybe String)
data MyAppState = DummyAppState (IORef Int)

data AppState = AppState { dbConn :: Connection }

main :: IO ()
main =
    do ref <- newIORef 0
       conn <- connectPostgreSQL "host=localhost dbname=postgres user=postgres password=fumifumiHaskell"
       let appState = AppState conn
       spockCfg <- defaultSpockCfg (MySession Nothing) PCNoDatabase appState
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
       post "/api/login" $ do
           user <- jsonBody'
           state <- getState
           loginSucccess <- liftIO $ loginUser (dbConn state) user
           if loginSucccess
              then do writeSession (MySession (Just (userName user)))
                      Web.Spock.json ("Login Successfull" :: String)
              else Web.Spock.json ("Login Failed" :: String)
       post "/api/logout" $ do
           writeSession (MySession Nothing)
           Web.Spock.json ("LogOut Success" :: String)
