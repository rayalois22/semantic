-- | Semantic functionality for Python programs.
module Language.Python
( Term(..)
, Language.Python.Grammar.tree_sitter_python
) where

import           Data.Proxy
import qualified Language.Python.AST as Py
import           Language.Python.ScopeGraph
import qualified Language.Python.Tags as PyTags
import           ScopeGraph.Convert
import qualified Tags.Tagging.Precise as Tags
import qualified Language.Python.Grammar (tree_sitter_python)
import qualified AST.Unmarshal as TS

newtype Term a = Term { getTerm :: Py.Module a }

instance TS.SymbolMatching Term where
  matchedSymbols _ = TS.matchedSymbols (Proxy :: Proxy Py.Module)
  showFailure _ = TS.showFailure (Proxy :: Proxy Py.Module)

instance TS.Unmarshal Term where
  matchers = fmap (fmap (TS.hoist Term)) TS.matchers

instance Tags.ToTags Term where
  tags src = Tags.runTagging src . PyTags.tags . getTerm

instance ToScopeGraph Term where
  scopeGraph = scopeGraphModule . getTerm
