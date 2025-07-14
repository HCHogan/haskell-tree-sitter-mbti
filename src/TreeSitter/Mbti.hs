module TreeSitter.Mbti (
  tree_sitter_mbti,
  getNodeTypesPath,
  getTestCorpusDir,
) where

import Foreign.Ptr
import TreeSitter.Language
import Paths_tree_sitter_mbti (getDataFileName)

foreign import ccall unsafe "vendor/tree-sitter-moonbit/src/parser.c tree_sitter_mbti" tree_sitter_mbti :: Ptr Language

getNodeTypesPath :: IO FilePath
getNodeTypesPath = getDataFileName "vendor/tree-sitter-mbti/src/node-types.json"

getTestCorpusDir :: IO FilePath
getTestCorpusDir = getDataFileName "vendor/tree-sitter-mbti/test/corpus"
