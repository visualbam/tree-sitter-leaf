#include <tree_sitter/parser.h>
#include <string.h>

enum TokenType {
  IMPORT_IN_ATTRIBUTE,
};

void *tree_sitter_leaf_external_scanner_create() {
  return NULL;
}

void tree_sitter_leaf_external_scanner_destroy(void *payload) {
}

void tree_sitter_leaf_external_scanner_reset(void *payload) {
}

unsigned tree_sitter_leaf_external_scanner_serialize(void *payload, char *buffer) {
  return 0;
}

void tree_sitter_leaf_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
}

// This scanner helps detect #import directives inside attribute values
bool tree_sitter_leaf_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
  // We only care about IMPORT_IN_ATTRIBUTE token
  if (!valid_symbols[IMPORT_IN_ATTRIBUTE]) return false;

  // Store current position to mark start of token
  lexer->mark_end(lexer);

  // Skip whitespace
  while (lexer->lookahead == ' ' || 
         lexer->lookahead == '\t' || 
         lexer->lookahead == '\r' || 
         lexer->lookahead == '\n') {
    lexer->advance(lexer, true);
  }

  // Check for #import pattern inside attributes
  if (lexer->lookahead == '#') {
    lexer->advance(lexer, false);

    // Attempt to match "import"
    if (lexer->lookahead != 'i') return false;
    lexer->advance(lexer, false);
    if (lexer->lookahead != 'm') return false;
    lexer->advance(lexer, false);
    if (lexer->lookahead != 'p') return false;
    lexer->advance(lexer, false);
    if (lexer->lookahead != 'o') return false;
    lexer->advance(lexer, false);
    if (lexer->lookahead != 'r') return false;
    lexer->advance(lexer, false);
    if (lexer->lookahead != 't') return false;
    lexer->advance(lexer, false);

    // Check for opening parenthesis
    if (lexer->lookahead != '(') return false;
    lexer->advance(lexer, false);

    // Mark the end after consuming the full pattern
    lexer->mark_end(lexer);

    // Match until closing parenthesis
    while (lexer->lookahead != ')' && lexer->lookahead != 0) {
      lexer->advance(lexer, false);
    }

    // Consume closing parenthesis if present
    if (lexer->lookahead == ')') {
      lexer->advance(lexer, false);
      lexer->mark_end(lexer);
    }

    lexer->result_symbol = IMPORT_IN_ATTRIBUTE;
    return true;
  }

  return false;
}
