#!/bin/zsh

echo "Generating Tree-sitter parser..."
tree-sitter generate

echo "Running tests..."
tree-sitter test

echo "Building parser..."
cc -o ./leaf.so -I./src src/parser.c -shared -Os -lstdc++ -fPIC

echo "Done! Parser built as leaf.so"
