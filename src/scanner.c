#include <tree_sitter/parser.h>
#include <string.h>

enum TokenType {
  IMPORT_IN_ATTRIBUTE,
  IMPORT_DIRECTIVE_START,
  IMPORT_STRING_CONTENT,
  IMPORT_DIRECTIVE_END,
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
  // Check for the tokens we handle
  bool import_attr = valid_symbols[IMPORT_IN_ATTRIBUTE];
  bool import_start = valid_symbols[IMPORT_DIRECTIVE_START];
  bool import_content = valid_symbols[IMPORT_STRING_CONTENT];
  bool import_end = valid_symbols[IMPORT_DIRECTIVE_END];

  if (!import_attr && !import_start && !import_content && !import_end) return false;
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
    // Try to match the start part (#import())
    if (import_start) {
      lexer->advance(lexer, false);
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

      // Match opening parenthesis
      if (lexer->lookahead != '(') return false;
      lexer->advance(lexer, false);

      lexer->mark_end(lexer);
      lexer->result_symbol = IMPORT_DIRECTIVE_START;
      return true;
    }

    // Traditional whole pattern match for backward compatibility
    if (import_attr) {
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
    // Check for opening parenthesis
    if (lexer->lookahead != '(') return false;
    lexer->advance(lexer, false);

      // Mark the end after consuming the full pattern
      lexer->mark_end(lexer);
    // Mark the end after consuming the full pattern
    lexer->mark_end(lexer);

      // Match until closing parenthesis
      while (lexer->lookahead != ')' && lexer->lookahead != 0) {
        lexer->advance(lexer, false);
      }
    // Match until closing parenthesis
    while (lexer->lookahead != ')' && lexer->lookahead != 0) {
      lexer->advance(lexer, false);
    }

      // Consume closing parenthesis if present
      if (lexer->lookahead == ')') {
        lexer->advance(lexer, false);
        lexer->mark_end(lexer);
      }
    // Consume closing parenthesis if present
    if (lexer->lookahead == ')') {
      lexer->advance(lexer, false);
      lexer->mark_end(lexer);
    }

      lexer->result_symbol = IMPORT_IN_ATTRIBUTE;
      return true;
    }
  }

  // Handle string content inside import directive
  if (import_content && (lexer->lookahead == '"' || lexer->lookahead == '\'')) {
    char quote = lexer->lookahead;
    lexer->advance(lexer, false);

    while (lexer->lookahead != quote && lexer->lookahead != 0) {
      // Handle escape sequences
      if (lexer->lookahead == '\\') {
        lexer->advance(lexer, false);
        if (lexer->lookahead != 0) {
          lexer->advance(lexer, false);
        }
      } else {
        lexer->advance(lexer, false);
      }
    }

    if (lexer->lookahead == quote) {
      lexer->advance(lexer, false);
    }

    lexer->mark_end(lexer);
    lexer->result_symbol = IMPORT_STRING_CONTENT;
    return true;
  }

  // Handle the closing parenthesis
  if (import_end && lexer->lookahead == ')') {
    lexer->advance(lexer, false);
    lexer->mark_end(lexer);
    lexer->result_symbol = IMPORT_DIRECTIVE_END;
    lexer->result_symbol = IMPORT_IN_ATTRIBUTE;
    return true;
  }

  return false;
}

