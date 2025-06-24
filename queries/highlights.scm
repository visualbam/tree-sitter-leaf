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

; Leaf directive headers - use more distinctive highlighting
(if_header) @keyword.directive
(elseif_header) @keyword.directive
(else_directive) @keyword.directive
(unless_header) @keyword.directive
(for_header) @keyword.directive
(while_header) @keyword.directive
(extend_header) @keyword.directive
(export_header) @keyword.directive
(import_header) @keyword.directive
(evaluate_header) @keyword.directive

; End directives - use a different shade
(end_if_directive) @keyword.directive.end
(end_unless_directive) @keyword.directive.end
(end_for_directive) @keyword.directive.end
(end_while_directive) @keyword.directive.end
(end_extend_directive) @keyword.directive.end
(end_export_directive) @keyword.directive.end

; Leaf variable delimiters - make them more prominent
[
    "#("
    ")"
    ] @punctuation.special.leaf

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
    (identifier) @function.leaf)

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

; Leaf comments - distinguish from HTML comments
(leaf_comment) @comment.leaf @spell

; HTML entities
(html_entity) @string.special

; Doctype
(doctype) @tag
