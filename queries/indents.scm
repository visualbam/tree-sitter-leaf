; ===== HTML INDENTATION =====

; Standard HTML elements (non-void)
((element
     (start_tag
         (tag_name) @_not_void_element))
    (#not-any-of? @_not_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

; Self-closing HTML elements
(element
    (self_closing_tag)) @indent.begin

; Void HTML elements (self-closing by nature)
((start_tag
     (tag_name) @_void_element)
    (#any-of? @_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

; HTML element end markers
(element
    (end_tag
        ">" @indent.end))

(element
    (self_closing_tag
        "/>" @indent.end))

; HTML element branching
(element
    (end_tag) @indent.branch)

[
    ">"
    "/>"
    ] @indent.branch

; ===== VAPOR LEAF INDENTATION =====

; Leaf conditional blocks
(leaf_if_directive) @indent.begin
(leaf_elseif_directive) @indent.begin @indent.end
(leaf_else_directive) @indent.begin @indent.end
(leaf_endif_directive) @indent.end

; Leaf loop blocks
(leaf_for_directive) @indent.begin
(leaf_endfor_directive) @indent.end

; Leaf define blocks
(leaf_define_directive) @indent.begin
(leaf_enddefine) @indent.end

; Leaf conditional attributes (inline conditionals)
(leaf_conditional_attribute) @indent.begin

; Leaf loop attributes (inline loops)
(leaf_loop_attribute) @indent.begin

; Elements with Leaf conditional attributes should indent their content
((element
     (start_tag
         (leaf_conditional_attribute)))
    @indent.begin)

; Elements with Leaf loop attributes should indent their content
((element
     (start_tag
         (leaf_loop_attribute)))
    @indent.begin)

; Self-closing tags with Leaf attributes
((self_closing_tag
     (leaf_conditional_attribute))
    @indent.begin)

((self_closing_tag
     (leaf_loop_attribute))
    @indent.begin)

; Leaf directive punctuation for branching
[
    "#if("
    "#elseif("
    "#unless("
    "#for("
    "#forEach("
    ] @indent.branch

[
    "#else:"
    "#elseif("
    ] @indent.branch

[
    "#endif"
    "#endfor"
    "#enddefine"
    ] @indent.branch

; Leaf interpolation blocks (multi-line expressions)
(leaf_interpolation
    [
        "#("
        "#{"
        ] @indent.begin)

(leaf_interpolation
    [
        ")"
        "}"
        ] @indent.end)

; Complex Leaf expressions that span multiple lines
(leaf_function_call
    "(" @indent.begin
    ")" @indent.end)

(leaf_parenthesized_expression
    "(" @indent.begin
    ")" @indent.end)

; Leaf ternary expressions (multi-line)
(leaf_ternary_expression
    "?" @indent.begin
    ":" @indent.branch
    @indent.end)

; ===== MIXED HTML + LEAF INDENTATION =====

; HTML elements containing Leaf directives should maintain proper indentation
((element
     (start_tag)
     (leaf_directive))
    @indent.begin)

; Leaf directives inside HTML elements
((element
     (leaf_if_directive))
    @indent.begin)

((element
     (leaf_for_directive))
    @indent.begin)

; Special handling for script/style elements with Leaf content
((script_element
     (start_tag)
     (leaf_interpolation))
    @indent.begin)

((style_element
     (start_tag)
     (leaf_interpolation))
    @indent.begin)

; ===== CONTEXTUAL INDENTATION =====

; Nested Leaf conditionals
((leaf_if_directive
     (leaf_if_directive))
    @indent.begin)

; Nested Leaf loops
((leaf_for_directive
     (leaf_for_directive))
    @indent.begin)

; Mixed nested structures
((leaf_if_directive
     (element))
    @indent.begin)

((leaf_for_directive
     (element))
    @indent.begin)

((element
     (leaf_if_directive
         (element)))
    @indent.begin)

; ===== LEAF ATTRIBUTE INDENTATION =====

; Multi-line Leaf attributes should indent their parameters
(leaf_conditional_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_loop_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_import_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_extend_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_export_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_inline_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_raw_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_unsaferaw_attribute
    "(" @indent.begin
    ")" @indent.end)

(leaf_custom_attribute
    "(" @indent.begin
    ")" @indent.end)

; ===== SPECIAL CASES =====

; Don't indent inside comments
(comment) @indent.ignore

; Don't indent raw text in script/style elements unless it contains Leaf
((script_element
     (raw_text))
    @indent.ignore)

((style_element
     (raw_text))
    @indent.ignore)

; But do indent script/style with Leaf interpolations
((script_element
     (raw_text
         (leaf_interpolation)))
    @indent.begin)

((style_element
     (raw_text
         (leaf_interpolation)))
    @indent.begin)

; Array access indentation for complex expressions
(leaf_array_access
    "[" @indent.begin
    "]" @indent.end)

; Member access chains (don't over-indent)
(leaf_member_access) @indent.ignore

; ===== LEAF EXPRESSION INDENTATION =====

; Complex binary expressions
((leaf_binary_expression
     left: (leaf_function_call))
    @indent.begin)

((leaf_binary_expression
     right: (leaf_function_call))
    @indent.begin)

; Function call parameters
((leaf_function_call
     (leaf_expression)
     ","
     (leaf_expression))
    @indent.begin)

; ===== TEMPLATE STRUCTURE INDENTATION =====

; Elements that are commonly containers should increase indent
((element
     (start_tag
         (tag_name) @_container))
    (#any-of? @_container
        "html" "head" "body" "div" "section" "article" "aside" "nav" "main"
        "header" "footer" "form" "fieldset" "table" "tbody" "thead" "tfoot"
        "tr" "ul" "ol" "dl" "blockquote" "figure")
    @indent.begin)

; List items and table cells should indent their content
((element
     (start_tag
         (tag_name) @_content))
    (#any-of? @_content "li" "td" "th" "dt" "dd")
    @indent.begin)

; ===== LEAF BLOCK STRUCTURE =====

; Standalone Leaf blocks should be treated as block elements
(leaf_directive) @indent.branch

; Leaf directives that create scope
[
    "#define("
    "#if("
    "#elseif("
    "#unless("
    "#for("
    "#forEach("
    ] @indent.begin

; End markers for Leaf blocks
[
    "#endif"
    "#endfor"
    "#enddefine"
    ] @indent.end @indent.branch

; Branch markers for Leaf conditionals
[
    "#else:"
    "#elseif("
    ] @indent.end @indent.begin @indent.branch