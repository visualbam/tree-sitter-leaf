; Directive keywords (more specific categorization)
(extend_directive) @keyword.directive
(export_directive) @keyword.directive
(import_directive) @keyword.directive
(if_directive) @keyword.directive
(unless_directive) @keyword.directive
(for_directive) @keyword.directive
(while_directive) @keyword.directive
(evaluate_directive) @keyword.directive

; Enhanced operators with more specific categorization
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
    ] @operator.arithmetic
[
    "=="
    "!="
    "<"
    ">"
    "<="
    ">="
    ] @operator.comparison
[
    "&&"
    "||"
    "!"
    ] @operator.logical

; Enhanced punctuation
[
    "("
    ")"
    "["
    "]"
    "{"
    "}"
    ] @punctuation.bracket
[
    ","
    "."
    ] @punctuation.delimiter

; HTML tag punctuation (consistent highlighting)
[
    "<"    ; Opening tag start
    "</"   ; Closing tag start
    ">"    ; Tag end
    ] @punctuation.bracket.html

; More nuanced literals
(string_literal) @string
(number_literal) @number.float
(boolean_literal) @boolean

; More detailed identifier handling
(identifier) @variable
(member_access (identifier) @variable.member)
(function_call (identifier) @function.call)

; HTML element enhancements
(tag_name) @tag.html
(attribute_name) @attribute.html
(attribute_value) @string.html
(html_comment) @comment.html

; Special handling for leaf variables
(leaf_variable) @variable.special.leaf

; Comments
(comment) @comment.line

; Refined keywords
"in" @keyword.control
"true" @boolean
"false" @boolean

; Text and content handling
(text) @text.plain