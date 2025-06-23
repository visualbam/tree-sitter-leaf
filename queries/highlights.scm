; ===== HTML HIGHLIGHTING =====
(tag_name) @tag

(comment) @comment @spell
(html_comment) @comment @spell

(attribute_name) @tag.attribute

((attribute
     (quoted_attribute_value) @string)
    (#set! priority 99))

(text) @none @spell

; HTML delimiters
[
    "<"
    ">"
    "</"
    "/>"
    ] @tag.delimiter

"=" @operator

; HTML URL attributes
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @string.special.url))
    (#any-of? @_attr "href" "src"))

; ===== LEAF HIGHLIGHTING =====

; Leaf directive node types (these are actual nodes in the grammar)
(if_header) @keyword
(elseif_header) @keyword
(else_directive) @keyword
(unless_header) @keyword
(for_header) @keyword
(while_header) @keyword
(extend_header) @keyword
(export_header) @keyword
(import_header) @keyword
(evaluate_header) @keyword
(end_if_directive) @keyword
(end_unless_directive) @keyword
(end_for_directive) @keyword
(end_while_directive) @keyword
(end_extend_directive) @keyword
(end_export_directive) @keyword

; Leaf variable delimiters
[
    "#("
    ")"
    ] @punctuation.special

; Leaf operators
[
    "+"
    "-"
    "*"
    "/"
    "%"
    "=="
    "!="
    "<"
    ">"
    "<="
    ">="
    "&&"
    "||"
    "and"
    "or"
    "!"
    "not"
    "??"
    "?"
    ":"
    ] @operator

; Leaf keywords - only string literals that are actually keywords
[
    "in"
    "true"
    "false"
    ] @keyword.builtin

; Leaf identifiers
(identifier) @variable

; Leaf function calls
(function_call
    (identifier) @function)

; Leaf member access
(member_access
    "." @punctuation.delimiter)

; Leaf literals
(string_literal) @string
(number_literal) @number
(boolean_literal) @boolean
(null_literal) @constant.builtin

; Leaf punctuation
[
    "("
    ")"
    "["
    "]"
    "{"
    "}"
    ","
    "."
    ] @punctuation.delimiter

; Leaf comments
(leaf_comment) @comment @spell

; HTML entities
(html_entity) @string.special

; Doctype
(doctype) @tag