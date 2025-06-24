
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

; Leaf tag functions - highlight each specific tag type
(count_tag) @function.builtin.leaf
(lowercased_tag) @function.builtin.leaf
(uppercased_tag) @function.builtin.leaf
(capitalized_tag) @function.builtin.leaf
(contains_tag) @function.builtin.leaf
(date_tag) @function.builtin.leaf
(unsafe_html_tag) @function.builtin.leaf
(dump_context_tag) @function.builtin.leaf

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

; === IDENTIFIER HIGHLIGHTING - UPDATED FOR NEW GRAMMAR ===

; HIGHEST PRIORITY: Function calls should be highlighted distinctly
(call_expression
    (postfix_expression
        (primary_expression
            (identifier) @function)))

; HIGH PRIORITY: Member access patterns for chained calls
; This catches the base object in member access (like 'users' in 'users.filter')
(member_expression
    (postfix_expression
        (primary_expression
            (identifier) @type)))

; This catches properties/methods in member expression (like 'filter' in 'users.filter')
(member_expression
    (identifier) @field)

; MEDIUM PRIORITY: Function call arguments that are identifiers
(call_expression
    (argument_list
        (expression
            (postfix_expression
                (primary_expression
                    (identifier) @parameter)))))

; LOWER PRIORITY: All other identifiers as variables
(identifier) @variable

; Make sure punctuation is highlighted consistently
(member_expression "." @punctuation.delimiter)

; Parentheses and brackets
[
    "("
    ")"
    ] @punctuation.bracket

[
    "["
    "]"
    ] @punctuation.bracket

[
    "{"
    "}"
    ] @punctuation.bracket

; Array/subscript access brackets
(subscript_expression
    "[" @punctuation.bracket
    "]" @punctuation.bracket)

; Leaf literals
(string_literal) @string
(number_literal) @number
(boolean_literal) @boolean
(null_literal) @constant.builtin

; Leaf punctuation
[
    ","
    ] @punctuation.delimiter

; Leaf comments - distinguish from HTML comments
(leaf_comment) @comment.leaf @spell

; HTML entities
(html_entity) @string.special

; Doctype
(doctype) @tag

; Dictionary/object literals
(dictionary_literal
    "{" @punctuation.bracket
    "}" @punctuation.bracket)

(dictionary_pair
    (identifier) @field
    ":" @punctuation.delimiter)

(dictionary_pair
    (string_literal) @field
    ":" @punctuation.delimiter)

; Array literals
(array_literal
    "[" @punctuation.bracket
    "]" @punctuation.bracket)

; Highlight argument separators in function calls
(argument_list
    "," @punctuation.delimiter)

; Parameter separators in tag calls
[
    ","
    ] @punctuation.delimiter