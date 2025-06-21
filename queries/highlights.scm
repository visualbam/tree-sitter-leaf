
; Directive keywords (these are part of the directive nodes)
(extend_directive) @keyword
(export_directive) @keyword
(import_directive) @keyword
(if_directive) @keyword
(unless_directive) @keyword
(for_directive) @keyword
(while_directive) @keyword
(evaluate_directive) @keyword

; Operators
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
  "!"
  "?"
  ":"
  "="
] @operator

; Punctuation
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

; Literals
(string_literal) @string
(number_literal) @number
(boolean_literal) @constant.builtin

; Identifiers and expressions
(identifier) @variable
(member_access (identifier) @variable.member)
(function_call (identifier) @function)

; HTML elements
(tag_name) @tag
(attribute_name) @attribute
(attribute_value) @string
(html_comment) @comment

; Leaf variables
(leaf_variable) @variable.special

; Comments
(comment) @comment

; Keywords
"in" @keyword.operator
"true" @constant.builtin
"false" @constant.builtin

; Text content
(text) @text
