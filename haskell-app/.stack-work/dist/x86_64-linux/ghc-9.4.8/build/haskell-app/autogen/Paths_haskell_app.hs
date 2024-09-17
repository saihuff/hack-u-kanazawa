{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_haskell_app (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath



bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/bin"
libdir     = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/lib/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0-GMk3SEB2I7DigEPF6AkI5-haskell-app"
dynlibdir  = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/lib/x86_64-linux-ghc-9.4.8"
datadir    = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/share/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0"
libexecdir = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/libexec/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0"
sysconfdir = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux/b76a718de10c6e58fa308a9bb62da3672b69ebc491fffdf35e8fba0226cee2d1/9.4.8/etc"

getBinDir     = catchIO (getEnv "haskell_app_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "haskell_app_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "haskell_app_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "haskell_app_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskell_app_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskell_app_sysconfdir") (\_ -> return sysconfdir)




joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
