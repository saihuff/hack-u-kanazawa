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
import Data.Text.Read (decimal)
import Data.Either (rights)

import Account.UserTypes


getFriendCode :: Connection -> Int -> IO Int
getFriendCode conn userid = do
    let q = "SELECT friend_id FROM friends WHERE user_id = ?"
    [result] <- query conn q (Only userid) :: IO [Only Int]
    return $ fromOnly result

registerFriend :: Connection -> Int -> Int -> IO ()
registerFriend conn userid friendid = do
    let q = "UPDATE friends SET friend = array_append(friend, ?) WHERE user_id = ?"
    execute conn q (friendid, userid)
    return ()

--------------------------------------------------------------------------

getFriends :: Connection -> Int -> IO [String]
getFriends conn userid = do
    friendList <- getAllFriends conn userid
    let friends = [getFriendName conn id | id <- friendList]
    sequence friends

getFriendName :: Connection -> Int -> IO String
getFriendName conn userid = do
    let q = "SELECT name FROM users WHERE id = ?"
    [result] <- query conn q (Only userid) :: IO [Only String]
    return $ fromOnly result

--------------------------------------------------------------------------

getFriendScore :: Connection -> Int -> IO [(String, Int)]
getFriendScore conn userid = do
    friendList <- getAllFriends conn userid
    let friends = [getFriendsScore conn id | id <- friendList]
    sequence friends

getFriendsScore :: Connection -> Int -> IO (String, Int)
getFriendsScore conn userid = do
    let q = "SELECT name, score FROM users WHERE id = ?"
    [result] <- query conn q (Only userid) :: IO [(String, Int)]
    return result

--------------------------------------------------------------------------

--getAllFriends :: Connection -> Int -> IO [Int]
--getAllFriends conn userid = do
--    let q = "SELECT friend FROM friends WHERE user_id = ?"
--    [result] <- query conn q (Only userid) :: IO [Only [Int]]
--    return $ fromOnly result

getAllFriends :: Connection -> Int -> IO [Int]
getAllFriends conn userid = do
    let q = "SELECT array_to_string(friend, ',') FROM friends WHERE user_id = ?"
    [Only result] <- query conn q (Only userid) :: IO [Only T.Text]
    -- Split the result by commas and convert to Int
    let friendIds = map (fst . either error id . decimal) (T.splitOn "," result)
    return friendIds

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort [y | y <- xs, y <= x] ++ [x] ++ [y | y <- xs, y > x]
