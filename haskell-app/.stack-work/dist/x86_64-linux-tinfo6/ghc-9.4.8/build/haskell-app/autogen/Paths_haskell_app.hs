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
bindir     = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/bin"
libdir     = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/lib/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0-7SfWses8UQH1cZRGv5SELs-haskell-app"
dynlibdir  = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/lib/x86_64-linux-ghc-9.4.8"
datadir    = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/share/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0"
libexecdir = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/libexec/x86_64-linux-ghc-9.4.8/haskell-app-0.1.0.0"
sysconfdir = "/home/saihuf/Haskell/Projects/hackukanazawa/haskell-app/.stack-work/install/x86_64-linux-tinfo6/0e4c13b4e371f97e3df1bdf67493625f4a5186f58555f7e79e775b6b7103037e/9.4.8/etc"

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
