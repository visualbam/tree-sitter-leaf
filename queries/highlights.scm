
; ===== HTML HIGHLIGHTING =====
; HTML tags - using @function to make them blue
(tag_name) @function
(void_tag_name) @function  ; Void tags also in blue

(html_comment) @comment @spell

; HTML attributes - using @type for yellow
((attribute_name) @type
    (#set! priority 110))

; HTML strings with explicit attribute_value highlighting for light green
((attribute
     (quoted_attribute_value) @string)
    (#set! priority 99))

(text) @none @spell

; HTML delimiters - using @comment.documentation for light green
[
    "<"
    ">"
    "</"
    "/>"
    ] @comment.documentation

; Direct attribute value highlighting - using @tag.attribute for light green
(attribute_value) @tag.attribute

; HTML URL attributes - same color as other attribute values for consistency
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value) @string)
    (#any-of? @_attr "href" "src")
    (#set! priority 99))

; Leaf directives inside attribute values
(simple_export_directive) @keyword.directive
(import_directive) @keyword.directive
(import_header) @keyword.directive

; Import directives in attributes are handled via pattern matching on attribute_value

; Direct highlight for quoted attribute values to be green
((quoted_attribute_value) @string
    (#set! priority 99))

; === SPECIAL HANDLING FOR IMPORT DIRECTIVES IN ATTRIBUTES ===
; Match #import( part with directive color
((attribute_value) @_val
    (#match? @_val "^#import\\(")
    (#set! priority 150))

; Extract just the opening part (#import() with pink directive color
((attribute_value) @keyword.directive
    (#match? @keyword.directive "^#import\\(")
    (#offset! @keyword.directive 0 0 0 8))

; Extract just the closing parenthesis with pink directive color
((attribute_value) @keyword.directive
    (#match? @keyword.directive "#import\\(.*\\)$")
    (#offset! @keyword.directive 0 -1 0 0))

; Extract just the string content with green string color
((attribute_value) @string
    (#match? @string "#import\\(\"[^\"]*\"\\)")
    (#offset! @string 0 8 0 -1)
    (#set! priority 140))

; Highlight attribute-related syntax 
(attribute "=" @string)
(attribute_name) @type

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

; Add highlighting for directives inside attributes
(leaf_directive_in_attribute (leaf_directive) @keyword.directive)

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

; Doctype - using @function to make it blue
(doctype) @function

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

; Highlight ERROR nodes
(ERROR) @error
