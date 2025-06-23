; ===== HTML SCOPES =====

; Document root scope
(document) @local.scope

; HTML element scopes
(element) @local.scope

; Script and style elements create isolated scopes
(script_element) @local.scope
(style_element) @local.scope

; Form elements create input scopes
((element
     (start_tag
         (tag_name) @_tag)
     (#eq? @_tag "form")) @local.scope)

; ===== VAPOR LEAF SCOPES =====

; Leaf conditional blocks create new scopes
(leaf_if_directive) @local.scope
(leaf_elseif_directive) @local.scope
(leaf_else_directive) @local.scope

; Leaf loop blocks create iteration scopes
(leaf_for_directive) @local.scope
(leaf_forEach_directive) @local.scope

; Leaf define blocks create function-like scopes
(leaf_define_directive) @local.scope

; Leaf interpolation creates expression scopes
(leaf_interpolation) @local.scope

; ===== LEAF VARIABLE DEFINITIONS =====

; Loop variables are defined in their respective scopes
(leaf_for_directive
    variable: (identifier) @local.definition.var)

(leaf_forEach_directive
    variable: (identifier) @local.definition.var)

; Set directive creates variable definitions
(leaf_set_directive
    variable: (identifier) @local.definition.var)

; Define directive creates function-like definitions
(leaf_define_directive
    name: (identifier) @local.definition.function)

; Define directive parameters
(leaf_define_directive
    parameters: (parameter_list
                    (identifier) @local.definition.parameter))

; Custom directive definitions
(leaf_custom_attribute
    name: (identifier) @local.definition.function)

; ===== LEAF VARIABLE REFERENCES =====

; Identifiers in expressions are variable references
(leaf_expression
    (identifier) @local.reference)

; Member access object references
(leaf_member_access
    object: (identifier) @local.reference)

; Function call references
(leaf_function_call
    function: (identifier) @local.reference)

; Array access references
(leaf_array_access
    array: (identifier) @local.reference)

; References in conditional expressions
(leaf_conditional_attribute
    condition: (leaf_expression
                   (identifier) @local.reference))

; References in loop collections
(leaf_loop_attribute
    collection: (leaf_expression
                    (identifier) @local.reference))

; References in set directive values
(leaf_set_directive
    value: (leaf_expression
               (identifier) @local.reference))

; References in interpolations
(leaf_interpolation
    (leaf_expression
        (identifier) @local.reference))

; ===== HTML ATTRIBUTE REFERENCES =====

; ID attributes create definitions
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @local.definition.var))
    (#eq? @_attr "id"))

; Class attributes can be considered definitions
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @local.definition.type))
    (#eq? @_attr "class"))

; Name attributes in forms create definitions
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @local.definition.var))
    (#eq? @_attr "name"))

; For attributes reference other elements
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @local.reference))
    (#eq? @_attr "for"))

; Href attributes with fragment identifiers
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @local.reference))
    (#eq? @_attr "href")
    (#lua-match? @local.reference "^#"))

; ===== LEAF SCOPE INHERITANCE =====

; Variables defined in parent scopes are available in child scopes
((leaf_for_directive
     variable: (identifier) @_loop_var) @_loop_scope
    (leaf_if_directive) @_child_scope
    (#set! @_child_scope "inherits" @_loop_scope))

((leaf_if_directive) @_if_scope
    (leaf_for_directive) @_child_scope
    (#set! @_child_scope "inherits" @_if_scope))

; Define blocks can reference outer scope variables
((leaf_define_directive) @_def_scope
    (#set! @_def_scope "captures-locals"))

; ===== CONTEXTUAL VARIABLE SCOPING =====

; Loop index variables (implicit)
((leaf_for_directive
     variable: (identifier) @_item_var) @_loop_scope
    (#set! @_loop_scope "defines" "index"))

; Leaf context variables (implicit global-like variables)
(document
    (#set! "global-context" "request")
    (#set! "global-context" "user")
    (#set! "global-context" "session")
    (#set! "global-context" "app")
    (#set! "global-context" "environment"))

; ===== TEMPLATE SCOPE MANAGEMENT =====

; Import directives don't create new scopes but bring in external definitions
(leaf_import_attribute
    template: (quoted_string) @local.import)

; Extend directives establish template hierarchy
(leaf_extend_attribute
    template: (quoted_string) @local.import)

; Export directives make local definitions available externally  
(leaf_export_attribute
    name: (quoted_string) @local.definition.export)

; Inline directives create isolated scopes
(leaf_inline_attribute) @local.scope

; ===== EXPRESSION SCOPING =====

; Binary expressions maintain scope context
(leaf_binary_expression
    left: (identifier) @local.reference
    right: (identifier) @local.reference)

; Ternary expressions create conditional references
(leaf_ternary_expression
    condition: (identifier) @local.reference
    consequent: (identifier) @local.reference
    alternate: (identifier) @local.reference)

; Function call arguments
(leaf_function_call
    arguments: (argument_list
                   (leaf_expression
                       (identifier) @local.reference)))

; ===== SPECIAL LEAF CONSTRUCTS =====

; Raw content doesn't create new scopes
(leaf_raw_attribute
    content: (leaf_expression
                 (identifier) @local.reference))

(leaf_unsaferaw_attribute
    content: (leaf_expression
                 (identifier) @local.reference))

; Evaluate directives execute in current scope
(leaf_evaluate_directive
    expression: (leaf_expression
                    (identifier) @local.reference))

; ===== HTML FORM SCOPING =====

; Form elements create input name scopes
((element
     (start_tag
         (tag_name) @_tag
         (attribute
             (attribute_name) @_attr
             (quoted_attribute_value
                 (attribute_value) @local.definition.parameter)))
     (#eq? @_tag "input")
     (#eq? @_attr "name")) @local.scope)

((element
     (start_tag
         (tag_name) @_tag
         (attribute
             (attribute_name) @_attr
             (quoted_attribute_value
                 (attribute_value) @local.definition.parameter)))
     (#any-of? @_tag "select" "textarea")
     (#eq? @_attr "name")) @local.scope)

; ===== MIXED CONTENT SCOPING =====

; HTML elements with Leaf attributes create hybrid scopes
((element
     (start_tag
         (leaf_conditional_attribute))) @local.scope)

((element
     (start_tag
         (leaf_loop_attribute))) @local.scope)

; Script elements with Leaf interpolations
((script_element
     (raw_text
         (leaf_interpolation))) @local.scope)

; Style elements with Leaf interpolations  
((style_element
     (raw_text
         (leaf_interpolation))) @local.scope)

; ===== ADVANCED SCOPING RULES =====

; Nested Leaf structures maintain proper scope chains
((leaf_if_directive) @_outer_scope
    (leaf_for_directive
        variable: (identifier) @local.definition.var) @_inner_scope
    (#set! @_inner_scope "parent" @_outer_scope))

((leaf_for_directive) @_outer_scope
    (leaf_if_directive) @_inner_scope
    (#set! @_inner_scope "parent" @_outer_scope))

; Define blocks with nested structures
((leaf_define_directive
     name: (identifier) @local.definition.function) @_func_scope
    (leaf_if_directive) @_inner_scope
    (#set! @_inner_scope "parent" @_func_scope))

; ===== ERROR HANDLING SCOPES =====

; Malformed Leaf expressions still participate in scoping
(ERROR
    (identifier) @local.reference)

; ===== OPTIMIZATION HINTS =====

; Frequently referenced variables
((identifier) @local.reference
    (#set! priority 100)
    (#any-of? @local.reference "user" "request" "session" "app"))

; Template-level variables
((identifier) @local.reference
    (#set! priority 90)
    (#lua-match? @local.reference "^[A-Z]"))

; Local loop variables
((leaf_for_directive
     variable: (identifier) @local.definition.var)
    (#set! priority 80))

; ===== VISIBILITY RULES =====

; Variables defined in parent scopes are visible in children
(leaf_if_directive
    (#set! "visibility" "inherits-parent"))

(leaf_for_directive
    (#set! "visibility" "inherits-parent"))

(leaf_define_directive
    (#set! "visibility" "creates-closure"))

; Import/extend affect global visibility
(leaf_import_attribute
    (#set! "visibility" "global-import"))

(leaf_extend_attribute
    (#set! "visibility" "global-extend"))

; ===== COMPLETION CONTEXT =====

; In interpolations, suggest all visible variables
(leaf_interpolation
    (#set! "completion-context" "variable"))

; In function calls, suggest functions and methods
(leaf_function_call
    function: (identifier) @local.reference
    (#set! "completion-context" "function"))

; In member access, suggest properties
(leaf_member_access
    property: (identifier) @local.reference
    (#set! "completion-context" "property"))

; In conditional attributes, suggest boolean expressions
(leaf_conditional_attribute
    (#set! "completion-context" "boolean"))

; In loop attributes, suggest iterable collections
(leaf_loop_attribute
    collection: (leaf_expression)
    (#set! "completion-context" "iterable"))