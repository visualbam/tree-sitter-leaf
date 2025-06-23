; ===== HTML TEXT OBJECTS =====

; HTML Elements
(html_element) @class.outer
(html_element
    (start_tag) @_start
    (end_tag) @_end
    (#make-range! "class.inner" @_start @_end)) @class.inner

; HTML Tags (start and end)
(start_tag) @tag.outer
(end_tag) @tag.outer
(html_self_closing_tag) @tag.outer

; HTML Attributes
(attribute) @parameter.outer
(attribute
    (attribute_name) @parameter.inner)

(quoted_attribute_value) @parameter.outer

; HTML Comments
(html_comment) @comment.outer
(comment) @comment.outer

; HTML Text Content
(text) @text.outer
(text) @text.inner

; ===== VAPOR LEAF TEXT OBJECTS =====

; Leaf Interpolations
(leaf_variable) @call.outer
(leaf_variable
    (expression) @call.inner)

; Leaf Directives (block-level)
(if_directive) @conditional.outer
(else_directive) @conditional.outer
(end_if_directive) @conditional.outer

; Leaf loops
(for_directive) @loop.outer
(end_for_directive) @loop.outer

; ===== LEAF EXPRESSIONS TEXT OBJECTS =====

; Leaf Function Calls
(function_call) @call.outer

; Leaf Array Access
(array_access) @call.outer

; Leaf Parenthesized Expressions
(parenthesized_expression) @call.outer
(parenthesized_expression
    (expression) @call.inner)

; Leaf String Literals
(string_literal) @string.outer

; Leaf Binary Expressions
(binary_expression) @assignment.outer

; Leaf Ternary Expressions
(ternary_expression) @conditional.outer

; ===== SPECIALIZED TEXT OBJECTS =====

; HTML Form Elements
((html_element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "form")) @class.outer)

((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "input" "select" "textarea" "button")) @parameter.outer)

; HTML List Elements
((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "ul" "ol" "dl")) @class.outer)

((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "li" "dt" "dd")) @parameter.outer)

; HTML Table Elements
((html_element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "table")) @class.outer)

((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "tr" "td" "th")) @parameter.outer)

; HTML Heading Elements
((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "h1" "h2" "h3" "h4" "h5" "h6")) @text.outer)

; HTML Link Elements
((html_element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "a")) @call.outer)

; ===== CONTEXTUAL TEXT OBJECTS =====

; Leaf variables and identifiers
(identifier) @parameter.inner

; Leaf member access chains
(member_access) @call.outer

; ===== DOCUMENT STRUCTURE TEXT OBJECTS =====

; Document sections
((html_element
     (start_tag
         (tag_name) @_tag)
     (#any-of? @_tag "section" "article" "aside" "nav" "main" "header" "footer")) @class.outer)

; Document containers
((html_element
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

; Self-closing tags
(html_self_closing_tag) @tag.outer

; Leaf directive headers
(if_header) @conditional.outer
(for_header) @loop.outer
(unless_header) @conditional.outer
(while_header) @loop.outer
(extend_header) @class.outer
(export_header) @class.outer

; Simple directives
(import_directive) @call.outer
(evaluate_directive) @call.outer

; Argument lists
(argument_list) @parameter.outer

; Array and dictionary literals
(array_literal) @parameter.outer
(dictionary_literal) @parameter.outer