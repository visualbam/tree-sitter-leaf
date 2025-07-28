
; ===== HTML HIGHLIGHTING =====
(tag_name) @tag
(void_tag_name) @tag  ; Add this line to highlight void tag names

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

; Leaf variable delimiters - HIGHEST PRIORITY - target the specific tokens within leaf_variable
(leaf_variable "#(" @punctuation.special.leaf)
(leaf_variable ")" @punctuation.special.leaf)

; Leaf directive parentheses - HIGH PRIORITY
(if_header "(" @punctuation.special.leaf)
(if_header ")" @punctuation.special.leaf)
(elseif_header "(" @punctuation.special.leaf)
(elseif_header ")" @punctuation.special.leaf)
(unless_header "(" @punctuation.special.leaf)
(unless_header ")" @punctuation.special.leaf)
(for_header "(" @punctuation.special.leaf)
(for_header ")" @punctuation.special.leaf)
(while_header "(" @punctuation.special.leaf)
(while_header ")" @punctuation.special.leaf)
(extend_header "(" @punctuation.special.leaf)
(extend_header ")" @punctuation.special.leaf)
(extend_header_with_colon "(" @punctuation.special.leaf)
(extend_header_with_colon ")" @punctuation.special.leaf)
(export_header_block "(" @punctuation.special.leaf)
(export_header_block ")" @punctuation.special.leaf)
(simple_export_directive "(" @punctuation.special.leaf)
(simple_export_directive ")" @punctuation.special.leaf)
(import_header "(" @punctuation.special.leaf)
(import_header ")" @punctuation.special.leaf)
(evaluate_header "(" @punctuation.special.leaf)
(evaluate_header ")" @punctuation.special.leaf)

; Leaf tag function parentheses - HIGH PRIORITY
(count_tag "(" @punctuation.special.leaf)
(count_tag ")" @punctuation.special.leaf)
(lowercased_tag "(" @punctuation.special.leaf)
(lowercased_tag ")" @punctuation.special.leaf)
(uppercased_tag "(" @punctuation.special.leaf)
(uppercased_tag ")" @punctuation.special.leaf)
(capitalized_tag "(" @punctuation.special.leaf)
(capitalized_tag ")" @punctuation.special.leaf)
(contains_tag "(" @punctuation.special.leaf)
(contains_tag ")" @punctuation.special.leaf)
(date_tag "(" @punctuation.special.leaf)
(date_tag ")" @punctuation.special.leaf)
(unsafe_html_tag "(" @punctuation.special.leaf)
(unsafe_html_tag ")" @punctuation.special.leaf)

; Leaf directive headers - use more distinctive highlighting
(if_header) @keyword.directive
(elseif_header) @keyword.directive
(else_directive) @keyword.directive
(unless_header) @keyword.directive
(for_header) @keyword.directive
(while_header) @keyword.directive
(extend_header) @keyword.directive
(extend_header_with_colon) @keyword.directive
(export_header_block) @keyword.directive
(simple_export_directive) @keyword.directive
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

; Leaf operators
[
    "+"
    "-"
    "*"
    "/"
    "%"
    "=="
    "!="
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

; === IDENTIFIER HIGHLIGHTING ===

; HIGHEST PRIORITY: Method names in call expressions that are member expressions
; This targets patterns like: user.bio.isEmpty() where 'isEmpty' is the method
((call_expression
     (postfix_expression
         (member_expression
             (identifier) @method.call)))
    (#set! priority 220))

; HIGHEST PRIORITY: Base objects in member expressions like 'users' in 'users.filter'
((member_expression
     (postfix_expression
         (primary_expression
             (identifier) @type)))
    (#set! priority 200))

; HIGHEST PRIORITY: Base objects in subscript expressions like 'users' in 'users[0]' 
((subscript_expression
     (postfix_expression
         (primary_expression
             (identifier) @type)))
    (#set! priority 200))

; HIGHEST PRIORITY: Function names in call expressions like 'formatDate' in 'formatDate(...)'
((call_expression
     (postfix_expression
         (primary_expression
             (identifier) @function.call)))
    (#set! priority 200))

; HIGH PRIORITY: Properties/methods like 'name', 'bio' - lighter blue
((member_expression
     (identifier) @property)
    (#set! priority 190))

; HIGH PRIORITY: Function arguments like 'isActive', 'age'
((argument_list
     (expression
         (postfix_expression
             (primary_expression
                 (identifier) @parameter))))
    (#set! priority 180))

; MEDIUM PRIORITY: For loop variables
((for_header
     (identifier) @variable.loop)
    (#set! priority 170))

; LOW PRIORITY: Standalone identifiers in primary expressions
((primary_expression
     (identifier) @variable)
    (#set! priority 100))

; Make sure punctuation is highlighted consistently
(member_expression "." @punctuation.delimiter)

; Brackets only - no parentheses to avoid conflicts with leaf constructs
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

; Parentheses ONLY for non-leaf contexts (expressions, function calls, etc)
(parenthesized_expression "(" @punctuation.bracket)
(parenthesized_expression ")" @punctuation.bracket)

(call_expression "(" @punctuation.bracket)
(call_expression ")" @punctuation.bracket)

; Leaf literals
(string_literal) @string
(number_literal) @number
(boolean_literal) @boolean
(null_literal) @constant.builtin

; Leaf punctuation
[
    ","
    ] @punctuation.delimiter

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