import Distribution.Simple
import Distribution.Simple.Setup
import Distribution.PackageDescription
import System.Process
import System.Directory
import Control.Monad (when)

main :: IO ()
main = defaultMainWithHooks simpleUserHooks
  { preBuild = \_ _ -> do
      putStrLn "Running tree-sitter generate for tree-sitter-mbti..."
      let dir = "vendor/tree-sitter-mbti"
      exists <- doesDirectoryExist dir
      when exists $ do
        callCommand $ "cd " ++ dir ++ " && tree-sitter generate --abi 14"
      return emptyHookedBuildInfo
  }

