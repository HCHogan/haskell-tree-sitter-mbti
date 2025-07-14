{-# LANGUAGE RecordWildCards #-}

import Data.Maybe
import Control.Monad (void, when)
import Distribution.Simple
import Distribution.Simple.Setup (
  BuildFlags (..),
  Flag,
  flagToMaybe,
 )
import Distribution.Simple.Utils (info)
import Distribution.Types.HookedBuildInfo
import Distribution.Verbosity (Verbosity, normal)
import System.Directory (
  canonicalizePath,
  doesDirectoryExist,
  getCurrentDirectory,
 )
import System.FilePath ((</>))
import System.Process (
  createProcess,
  cwd,
  proc,
  waitForProcess,
 )

main :: IO ()
main =
  defaultMainWithHooks
    simpleUserHooks
      { preBuild = runTreeSitterGenerate
      }

runTreeSitterGenerate :: Args -> BuildFlags -> IO HookedBuildInfo
runTreeSitterGenerate _ BuildFlags{..} =
  let logV :: Flag Verbosity -> String -> IO ()
      logV v = info (fromMaybe normal (flagToMaybe v))
   in do
        pwd <- getCurrentDirectory >>= canonicalizePath
        let tsDir = pwd </> "vendor" </> "tree-sitter-mbti"

        exists <- doesDirectoryExist tsDir

        when exists $
          do
            (_, _, _, ph) <-
              createProcess
                (proc "tree-sitter" ["generate", "--abi", "14"])
                  { cwd = Just tsDir
                  }
            void (waitForProcess ph)

        pure emptyHookedBuildInfo
