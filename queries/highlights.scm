(tag_name) @tag

; (erroneous_end_tag_name) @error ; we do not lint syntax errors
(comment) @comment @spell

(attribute_name) @tag.attribute

((attribute
     (quoted_attribute_value) @string)
    (#set! priority 99))

(text) @none @spell

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading)
    (#eq? @_tag "title"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.1)
    (#eq? @_tag "h1"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.2)
    (#eq? @_tag "h2"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.3)
    (#eq? @_tag "h3"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.4)
    (#eq? @_tag "h4"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.5)
    (#eq? @_tag "h5"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.heading.6)
    (#eq? @_tag "h6"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.strong)
    (#any-of? @_tag "strong" "b"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.italic)
    (#any-of? @_tag "em" "i"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.strikethrough)
    (#any-of? @_tag "s" "del"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.underline)
    (#eq? @_tag "u"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.raw)
    (#any-of? @_tag "code" "kbd"))

((element
     (start_tag
         (tag_name) @_tag)
     (text) @markup.link.label)
    (#eq? @_tag "a"))

((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @string.special.url))
    (#any-of? @_attr "href" "src"))

[
    "<"
    ">"
    "</"
    "/>"
    ] @tag.delimiter

"=" @operator

; ===== LEAF-SPECIFIC SYNTAX =====

; Leaf Comments
(leaf_comment) @comment @spell

; Leaf Directive Nodes
(leaf_if_directive) @keyword.directive
(leaf_else_directive) @keyword.directive
(leaf_endif_directive) @keyword.directive
(leaf_for_directive) @keyword.directive
(leaf_endfor_directive) @keyword.directive

; Leaf Interpolation
(leaf_interpolation
    [
        "#("
        ")"
        ] @punctuation.special)

(leaf_interpolation
    expression: (leaf_expression) @embedded)

; Leaf Conditional and Loop Attributes
(leaf_conditional_attribute) @keyword.directive
(leaf_loop_attribute) @keyword.directive

; Leaf Expressions
(identifier) @variable

(string_literal) @string
(number_literal) @number
(boolean_literal) @constant.builtin.boolean

; Member Access
(leaf_member_access
    "." @punctuation.delimiter)

; Array Access
(leaf_array_access
    [
        "["
        "]"
        ] @punctuation.bracket)

; Function Calls - highlight the first identifier in a function call as function
((leaf_function_call
     (identifier) @function))

(leaf_function_call
    [
        "("
        ")"
        ] @punctuation.bracket)

; Binary Expression Operators - highlight the literal operators
[
    "+"
    "-"
    "*"
    "/"
    "%"
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
    ] @operator.logical

; Unary Expression Operators
[
    "!"
    "-"
    "+"
    ] @operator

; Ternary Expression Operators
[
    "?"
    ":"
    ] @operator.ternary

; Leaf Parentheses and Punctuation
(leaf_parenthesized_expression
    [
        "("
        ")"
        ] @punctuation.bracket)

(argument_list
    "," @punctuation.delimiter)

; Keyword 'in' for loops
"in" @keyword

; String literals inside leaf expressions
":" @punctuation.delimiter