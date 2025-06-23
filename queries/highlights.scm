(tag_name) @tag

; (erroneous_end_tag_name) @error ; we do not lint syntax errors
(html_comment) @comment @spell
(comment) @comment @spell

(attribute_name) @tag.attribute

; Fix: quoted_attribute_value is nested under attribute_value
((attribute
     (attribute_value
         (quoted_attribute_value) @string))
    (#set! priority 99))

(text) @none @spell

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading))
    (#eq? @_tag "title"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.1))
    (#eq? @_tag "h1"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.2))
    (#eq? @_tag "h2"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.3))
    (#eq? @_tag "h3"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.4))
    (#eq? @_tag "h4"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.5))
    (#eq? @_tag "h5"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.heading.6))
    (#eq? @_tag "h6"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.strong))
    (#any-of? @_tag "strong" "b"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.italic))
    (#any-of? @_tag "em" "i"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.strikethrough))
    (#any-of? @_tag "s" "del"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.underline))
    (#eq? @_tag "u"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.raw))
    (#any-of? @_tag "code" "kbd"))

((html_element
     (start_tag
         (tag_name) @_tag)
     (html_content
         (text) @markup.link.label))
    (#eq? @_tag "a"))

; Fix: also update URL pattern to match the correct structure
((attribute
     (attribute_name) @_attr
     (attribute_value
         (quoted_attribute_value) @string.special.url))
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
(comment) @comment @spell

; Leaf Directive Nodes
(if_directive) @keyword.directive
(else_directive) @keyword.directive
(end_if_directive) @keyword.directive
(for_directive) @keyword.directive
(end_for_directive) @keyword.directive
(unless_directive) @keyword.directive
(end_unless_directive) @keyword.directive
(while_directive) @keyword.directive
(end_while_directive) @keyword.directive
(extend_directive) @keyword.directive
(end_extend_directive) @keyword.directive
(export_directive) @keyword.directive
(end_export_directive) @keyword.directive

; Leaf Interpolation
(leaf_variable
    [
        "#("
        ")"
        ] @punctuation.special)

(leaf_variable
    (expression) @embedded)

; Leaf Expressions
(identifier) @variable

(string_literal) @string
(number_literal) @number
(boolean_literal) @constant.builtin.boolean

; Member Access
(member_access
    "." @punctuation.delimiter)

; Array Access
(array_access
    [
        "["
        "]"
        ] @punctuation.bracket)

; Function Calls - highlight the first identifier in a function call as function
((function_call
     (identifier) @function))

(function_call
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
(parenthesized_expression
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