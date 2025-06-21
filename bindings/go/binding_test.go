package tree_sitter_laf_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_laf "github.com/tree-sitter/tree-sitter-laf/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_laf.Language())
	if language == nil {
		t.Errorf("Error loading Laf grammar")
	}
}
