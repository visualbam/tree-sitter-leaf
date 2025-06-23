
; ===== HTML TEXT OBJECTS =====

; HTML Elements
(element) @class.outer
(element
    (start_tag) @_start
    (end_tag) @_end
    (#make-range! "class.inner" @_start @_end)) @class.inner

; HTML Tags (start and end)
(start_tag) @tag.outer
(end_tag) @tag.outer
(self_closing_tag) @tag.outer

; HTML Attributes
(attribute) @parameter.outer
(attribute
    (attribute_name) @parameter.inner)

(quoted_attribute_value) @parameter.outer

; HTML Comments
(comment) @comment.outer

; HTML Text Content
(text) @text.outer
(text) @text.inner

; ===== VAPOR LEAF TEXT OBJECTS =====

; Leaf Interpolations
(leaf_interpolation) @call.outer
(leaf_interpolation
    (leaf_expression) @call.inner)

; Leaf Directives (block-level)
(leaf_if_directive) @conditional.outer
(leaf_else_directive) @conditional.outer
(leaf_endif_directive) @conditional.outer

; Leaf loops
(leaf_for_directive) @loop.outer
(leaf_endfor_directive) @loop.outer

; Leaf Attributes
(leaf_conditional_attribute) @conditional.outer
(leaf_loop_attribute) @loop.outer

; ===== LEAF EXPRESSIONS TEXT OBJECTS =====

; Leaf Function Calls
(leaf_function_call) @call.outer

; Leaf Array Access
(leaf_array_access) @call.outer

; Leaf Parenthesized Expressions
(leaf_parenthesized_expression) @call.outer
(leaf_parenthesized_expression
    (leaf_expression) @call.inner)

; Leaf String Literals
(string_literal) @string.outer

; Leaf Binary Expressions
(leaf_binary_expression) @assignment.outer

; Leaf Ternary Expressions
(leaf_ternary_expression) @conditional.outer

; ===== SPECIALIZED TEXT OBJECTS =====

; HTML Form Elements
((element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "form")) @class.outer)

((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "input" "select" "textarea" "button")) @parameter.outer)

; HTML List Elements
((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "ul" "ol" "dl")) @class.outer)

((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "li" "dt" "dd")) @parameter.outer)

; HTML Table Elements
((element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "table")) @class.outer)

((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "tr" "td" "th")) @parameter.outer)

; HTML Heading Elements
((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "h1" "h2" "h3" "h4" "h5" "h6")) @text.outer)

; HTML Link Elements
((element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "a")) @call.outer)

; ===== MIXED CONTENT TEXT OBJECTS =====

; Elements with Leaf conditionals
((element
     (start_tag
         (leaf_conditional_attribute))) @conditional.outer)

; Elements with Leaf loops
((element
     (start_tag
         (leaf_loop_attribute))) @loop.outer)

; ===== CONTEXTUAL TEXT OBJECTS =====

; Leaf variables and identifiers
(identifier) @parameter.inner

; Leaf member access chains
(leaf_member_access) @call.outer

; ===== DOCUMENT STRUCTURE TEXT OBJECTS =====

; Document sections
((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "section" "article" "aside" "nav" "main" "header" "footer")) @class.outer)

; Document containers
((element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "div" "span" "p")) @class.outer)

; ===== BASIC LEAF EXPRESSIONS =====

; Numbers and literals
(number_literal) @parameter.inner
(boolean_literal) @parameter.inner

; Tag names
(tag_name) @parameter.inner
(attribute_name) @parameter.inner

; ===== SIMPLE TEXT OBJECTS =====

; Doctype
(doctype) @comment.outer

; Leaf comments
(leaf_comment) @comment.outer