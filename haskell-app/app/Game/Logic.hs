{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}

module Game.Logic where

import Data.Aeson
import Data.IORef
import Control.Monad.IO.Class
import Database.PostgreSQL.Simple
import GHC.Generics (Generic)
import qualified Data.Text as T
import Data.Text.Read (decimal)
import Data.Either (rights)
import Data.Time.Clock
import Data.Time.LocalTime
import Data.Fixed (Pico)

import Game.GameTypes
import Data.Int (Int)

saveStartTime :: Connection -> Int -> IO ()
saveStartTime conn userid = do
    now <- getCurrentTime
    let q = "UPDATE users SET starttime = ? WHERE id = ?"
        r = "UPDATE users SET sleeptime = '0 hours' WHERE id = ?"
    execute conn q (now, userid)
    execute conn r (Only userid)
    return ()

currentStatus :: Connection -> Int -> IO String
currentStatus conn userid = do
    let q = "SELECT state FROM users WHERE id = ?"
    [result] <- query conn q (Only userid) :: IO [Only String]
    return (fromOnly result)

changeStatus :: Connection -> Int -> String -> IO ()
changeStatus conn userid "awake" = do
    now <- getCurrentTime
    let q = "UPDATE users SET state = 'awake' WHERE id = ?"
        r = "UPDATE users SET sleeptime = sleeptime + (? - fellsleep) WHERE id = ?"
    execute conn q (Only userid)
    execute conn r (now, userid)
    return ()
changeStatus conn userid "asleep" = do
    now <- getCurrentTime
    let q = "UPDATE users SET state = 'asleep' WHERE id = ?"
        r = "UPDATE users SET fellsleep = ? WHERE id = ?"
    execute conn q (Only userid)
    execute conn r (now, userid)
    return ()

setStatus :: Connection -> Int -> String -> IO ()
setStatus conn userid st = do
    let q = "UPDATE users SET state = ? WHERE id = ?"
    execute conn q (st, userid)
    return ()

getStudyTime :: Connection -> Int -> IO String
getStudyTime conn userid = do
    let q = "SELECT TO_CHAR((CURRENT_TIMESTAMP AT TIME ZONE 'UTC') - starttime - sleeptime, 'YYYY-MM-DD HH24:MI:SS') FROM users WHERE id = ?"
    [result] <- query conn q (Only userid) :: IO [Only String]
    return $ fromOnly result

