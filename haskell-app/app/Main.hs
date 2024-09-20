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
import Data.Maybe (fromJust)
import Data.ByteString.Char8 as BSC
import Data.ByteString as BS

import Account.Register
import Account.Login
import Account.Userdata
import Account.UserTypes
import Video.Process
import DB.DBconnection
import Game.Data
import Game.Logic
import Game.GameTypes

data MySession = MySession (Maybe Int)
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
       post "/api/register" $ do
           user <- jsonBody'
           state <- getState 
           liftIO $ registerUser (dbConn state) user
           Web.Spock.json ("User registerd" :: String)
       post "/api/login" $ do
           user <- jsonBody'
           state <- getState
           userid <- liftIO $ getUserID (dbConn state) user
           loginSucccess <- liftIO $ loginUser (dbConn state) user
           if loginSucccess
              then do writeSession (MySession (Just userid)) -- Just内をidに変更する必要がある
                      Web.Spock.json ("Login Successfull" :: String)
              else Web.Spock.json ("Login Failed" :: String)
       post "/api/logout" $ do
           writeSession (MySession Nothing)
           Web.Spock.json ("LogOut Success" :: String)
       get "/api/userdata" $ do
           MySession user <- readSession
           state <- getState
           d <- liftIO $ getUserData (dbConn state) (fromJust user)
           Web.Spock.json d
       post "api/picture/" $ do
           picture <- jsonBody'
           res <- liftIO $ isAwake picture
           MySession userid <- readSession
           state <- getState
           let s = status .fromJust $ (Data.Aeson.decode (BSC.fromStrict (BSC.pack res)) :: Maybe Status)
           st <- liftIO $ currentStatus (dbConn state) (fromJust userid)
           if s == "awake"
              then if st == "awake"
                      then Web.Spock.json res
                      else do liftIO $ changeStatus (dbConn state) (fromJust userid) "awake"
                              Web.Spock.json res
              else if st == "asleep"
                      then Web.Spock.json res
                      else do liftIO $ changeStatus (dbConn state) (fromJust userid) "asleep"
                              Web.Spock.json res
       get "api/friendcode/" $ do
           MySession user <- readSession
           state <- getState
           d <- liftIO $ getFriendCode (dbConn state) (fromJust user)
           Web.Spock.json d
       post "api/registerfriend/" $ do
           friendid <- jsonBody'
           MySession userid <- readSession
           state <- getState
           liftIO $ registerFriend (dbConn state) (fromJust userid) (friendID friendid)
           Web.Spock.json ("friend registerd" :: String)
       get "api/friends/" $ do
           MySession user <- readSession
           state <- getState
           d <- liftIO $ getFriends (dbConn state) (fromJust user)
           Web.Spock.json d
       get "api/getfriendscore/" $ do
           MySession user <- readSession
           state <- getState
           d <- liftIO $ getFriendScore (dbConn state) (fromJust user)
           Web.Spock.json d
       post "api/gamestart/" $ do
           MySession user <- readSession
           state <- getState
           liftIO $ Game.Logic.setStatus (dbConn state) (fromJust user) "awake"
           liftIO $ saveStartTime (dbConn state) (fromJust user)
       post "api/score" $ do
           s <- jsonBody'
           MySession user <- readSession
           state <- getState
           liftIO $ updateScore (dbConn state) (fromJust user) (score s)
       post "api/gamefinish" $ do
           MySession user <- readSession
           state <- getState
           liftIO $ Game.Logic.setStatus (dbConn state) (fromJust user) "notStudy"
           d <- liftIO $ getStudyTime (dbConn state) (fromJust user)
           Web.Spock.json d
