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

; HTML Tag content (between < and >)
(start_tag
    "<" @_start
    ">" @_end
    (#make-range! "tag.inner" @_start @_end)) @tag.inner

(end_tag
    "</" @_start
    ">" @_end
    (#make-range! "tag.inner" @_start @_end)) @tag.inner

(self_closing_tag
    "<" @_start
    "/>" @_end
    (#make-range! "tag.inner" @_start @_end)) @tag.inner

; HTML Attributes
(attribute) @parameter.outer
(attribute
    (attribute_name) @parameter.inner)

(quoted_attribute_value) @parameter.outer
(quoted_attribute_value
    "\"" @_start
    "\"" @_end
    (#make-range! "parameter.inner" @_start @_end)) @parameter.inner

(quoted_attribute_value
    "'" @_start
    "'" @_end
    (#make-range! "parameter.inner" @_start @_end)) @parameter.inner

; HTML Comments
(comment) @comment.outer
(comment
    "<!--" @_start
    "-->" @_end
    (#make-range! "comment.inner" @_start @_end)) @comment.inner

; HTML Text Content
(text) @text.outer
(text) @text.inner

; ===== VAPOR LEAF TEXT OBJECTS =====

; Leaf Interpolations
(leaf_interpolation) @call.outer
(leaf_interpolation
    "#(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_interpolation
    "#{" @_start
    "}" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

; Leaf Directives (block-level)
(leaf_if_directive) @conditional.outer
(leaf_elseif_directive) @conditional.outer
(leaf_else_directive) @conditional.outer
(leaf_endif_directive) @conditional.outer

; Leaf conditional blocks (from #if to #endif)
((leaf_if_directive) @_start
    (#make-range! "conditional.inner" @_start @_start)) @conditional.inner

; Leaf loops
(leaf_for_directive) @loop.outer
(leaf_endfor_directive) @loop.outer

; Leaf loop blocks (from #for to #endfor)
((leaf_for_directive) @_start
    (#make-range! "loop.inner" @_start @_start)) @loop.inner

; Leaf define blocks
(leaf_define_directive) @function.outer
(leaf_enddefine) @function.outer

; Leaf function definitions (from #define to #enddefine)
((leaf_define_directive) @_start
    (#make-range! "function.inner" @_start @_start)) @function.inner

; Leaf Attributes
(leaf_conditional_attribute) @conditional.outer
(leaf_loop_attribute) @loop.outer
(leaf_import_attribute) @call.outer
(leaf_extend_attribute) @call.outer
(leaf_export_attribute) @call.outer
(leaf_inline_attribute) @call.outer
(leaf_raw_attribute) @call.outer
(leaf_unsaferaw_attribute) @call.outer
(leaf_custom_attribute) @call.outer

; Leaf attribute parameters
(leaf_conditional_attribute
    "(" @_start
    ")" @_end
    (#make-range! "conditional.inner" @_start @_end)) @conditional.inner

(leaf_loop_attribute
    "(" @_start
    ")" @_end
    (#make-range! "loop.inner" @_start @_end)) @loop.inner

(leaf_import_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_extend_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_export_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_inline_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_raw_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_unsaferaw_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

(leaf_custom_attribute
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

; ===== LEAF EXPRESSIONS TEXT OBJECTS =====

; Leaf Function Calls
(leaf_function_call) @call.outer
(leaf_function_call
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

; Leaf Array Access
(leaf_array_access) @call.outer
(leaf_array_access
    "[" @_start
    "]" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

; Leaf Parenthesized Expressions
(leaf_parenthesized_expression) @call.outer
(leaf_parenthesized_expression
    "(" @_start
    ")" @_end
    (#make-range! "call.inner" @_start @_end)) @call.inner

; Leaf String Literals
(string_literal) @string.outer
(quoted_string) @string.outer

(string_literal
    "\"" @_start
    "\"" @_end
    (#make-range! "string.inner" @_start @_end)) @string.inner

(string_literal
    "'" @_start
    "'" @_end
    (#make-range! "string.inner" @_start @_end)) @string.inner

(quoted_string
    "\"" @_start
    "\"" @_end
    (#make-range! "string.inner" @_start @_end)) @string.inner

(quoted_string
    "'" @_start
    "'" @_end
    (#make-range! "string.inner" @_start @_end)) @string.inner

; Leaf Binary Expressions
(leaf_binary_expression) @assignment.outer

; Leaf Ternary Expressions
(leaf_ternary_expression) @conditional.outer
(leaf_ternary_expression
    "?" @_start
    ":" @_end
    (#make-range! "conditional.inner" @_start @_end)) @conditional.inner

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

; Script/Style elements with Leaf content
(script_element) @function.outer
(style_element) @function.outer

; Script/Style element content
(script_element
    (start_tag) @_start
    (end_tag) @_end
    (#make-range! "function.inner" @_start @_end)) @function.inner

(style_element
    (start_tag) @_start
    (end_tag) @_end
    (#make-range! "function.inner" @_start @_end)) @function.inner

; ===== CONTEXTUAL TEXT OBJECTS =====

; Leaf variables and identifiers
(identifier) @parameter.inner

; Leaf member access chains
(leaf_member_access) @call.outer

; Leaf assignment-like expressions
((leaf_set_directive) @assignment.outer)
((leaf_set_directive
     "=" @_start
     (#make-range! "assignment.inner" @_start @_start)) @assignment.inner)

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

; ===== ADVANCED SELECTIONS =====

; Entire Leaf conditional blocks (including content between directives)
((leaf_if_directive) @_if_start
    (leaf_endif_directive) @_if_end
    (#make-range! "conditional.outer" @_if_start @_if_end))

; Entire Leaf loop blocks (including content between directives)  
((leaf_for_directive) @_for_start
    (leaf_endfor_directive) @_for_end
    (#make-range! "loop.outer" @_for_start @_for_end))

; Entire Leaf define blocks (including content between directives)
((leaf_define_directive) @_def_start
    (leaf_enddefine) @_def_end
    (#make-range! "function.outer" @_def_start @_def_end))

; HTML elements with all their Leaf attributes
((element
     (start_tag
         (leaf_conditional_attribute)) @_elem_start
     (end_tag) @_elem_end
     (#make-range! "class.outer" @_elem_start @_elem_end)))

; ===== UTILITY TEXT OBJECTS =====

; All attributes of an element
((start_tag
     (tag_name) @_tag_end) @_start
    (#make-range! "parameter.outer" @_tag_end @_start))

; All Leaf expressions within an interpolation
((leaf_interpolation
     (leaf_expression) @call.inner))

; Function arguments in Leaf calls  
((leaf_function_call
     (leaf_expression) @parameter.inner))

; Array indices in Leaf array access
((leaf_array_access
     (leaf_expression) @parameter.inner))