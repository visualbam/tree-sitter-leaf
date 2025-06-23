; HTML Tags
(tag_name) @tag

; HTML Attributes
(attribute_name) @tag.attribute

; HTML Attribute Values
((attribute
     (quoted_attribute_value) @string)
    (#set! priority 99))

(attribute_value) @string

; HTML Comments
(comment) @comment @spell

; HTML Text Content
(text) @none @spell

; HTML Tag Delimiters
[
    "<"
    ">"
    "</"
    "/>"
    ] @tag.delimiter

; HTML Operators
"=" @operator

; Doctype
(doctype) @keyword.directive

; Error Handling
(erroneous_end_tag_name) @error

; ===== VAPOR LEAF SYNTAX =====

; Leaf Interpolation
(leaf_interpolation
    [
        "#("
        ")"
        "#{"
        "}"
        ] @punctuation.special)

(leaf_interpolation
    (leaf_expression) @embedded)

; Leaf Directive Keywords
[
    "#if"
    "#elseif"
    "#else"
    "#endif"
    "#unless"
    "#for"
    "#forEach"
    "#endfor"
    "#set"
    "#define"
    "#enddefine"
    "#evaluate"
    "#import"
    "#extend"
    "#export"
    "#inline"
    "#raw"
    "#unsafeRaw"
    ] @keyword.directive

; Leaf Directive Punctuation
[
    "#if("
    "#elseif("
    "#unless("
    "#for("
    "#forEach("
    "#set("
    "#define("
    "#evaluate("
    "#import("
    "#extend("
    "#export("
    "#inline("
    "#raw("
    "#unsafeRaw("
    ] @keyword.directive

; Leaf Control Flow
[
    "#else:"
    "#endif"
    "#endfor"
    "#enddefine"
    ":"
    ] @keyword.control

; Leaf Custom Attributes/Directives
(leaf_custom_attribute
    name: (identifier) @function.macro)

; Leaf Conditional Attributes
(leaf_conditional_attribute
    [
        "#if"
        "#elseif"
        "#unless"
        ] @keyword.conditional)

; Leaf Loop Attributes  
(leaf_loop_attribute
    [
        "#for"
        "#forEach"
        ] @keyword.repeat)

(leaf_loop_attribute
    "in" @keyword.operator)

; Leaf Template Attributes
(leaf_import_attribute "#import" @keyword.import)
(leaf_extend_attribute "#extend" @keyword.import)
(leaf_export_attribute "#export" @keyword.export)
(leaf_inline_attribute "#inline" @keyword.import)

; Leaf Content Attributes
(leaf_raw_attribute "#raw" @keyword.directive)
(leaf_unsaferaw_attribute "#unsafeRaw" @keyword.directive)

; ===== LEAF EXPRESSIONS =====

; Identifiers
(identifier) @variable

; Literals
(string_literal) @string
(quoted_string) @string
(number_literal) @number
(boolean_literal) @boolean

; Member Access
(leaf_member_access
    "." @punctuation.delimiter)

(leaf_member_access
    property: (identifier) @property)

; Array Access
(leaf_array_access
    [
        "["
        "]"
        ] @punctuation.bracket)

; Function Calls
(leaf_function_call
    function: (identifier) @function)

(leaf_function_call
    [
        "("
        ")"
        ] @punctuation.bracket)

; Binary Expressions
(leaf_binary_expression
    operator: [
                  "+"
                  "-"
                  "*"
                  "/"
                  "%"
                  ] @operator.arithmetic)

(leaf_binary_expression
    operator: [
                  "=="
                  "!="
                  "<"
                  ">"
                  "<="
                  ">="
                  ] @operator.comparison)

(leaf_binary_expression
    operator: [
                  "&&"
                  "||"
                  ] @operator.logical)

; Unary Expressions
(leaf_unary_expression
    operator: [
                  "!"
                  "-"
                  "+"
                  ] @operator)

; Ternary Expressions
(leaf_ternary_expression
    [
        "?"
        ":"
        ] @operator.ternary)

; Parentheses
(leaf_parenthesized_expression
    [
        "("
        ")"
        ] @punctuation.bracket)

; Expression Punctuation
[
    "("
    ")"
    "["
    "]"
    ","
    ] @punctuation.delimiter

; ===== HTML SEMANTIC HIGHLIGHTING =====

; HTML Headings
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

; HTML Text Formatting
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

; HTML URLs
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @string.special.url))
    (#any-of? @_attr "href" "src")
    (#set! @string.special.url url @string.special.url))

; ===== SPECIAL CASES =====

; Leaf expressions in HTML attributes
((attribute
     (quoted_attribute_value
         (leaf_interpolation) @embedded)))

; Mixed content highlighting
((element
     (start_tag
         (tag_name) @_tag)
     (leaf_interpolation) @embedded)
    (#any-of? @_tag "title" "h1" "h2" "h3" "h4" "h5" "h6"))

; Void elements (self-closing tags)
((start_tag
     (tag_name) @tag.builtin)
    (#any-of? @tag.builtin
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed"
        "frame" "hr" "image" "img" "input" "isindex" "keygen" "link"
        "menuitem" "meta" "nextid" "param" "source" "track" "wbr"))

; Script and style tags
((start_tag
     (tag_name) @tag.builtin)
    (#any-of? @tag.builtin "script" "style"))

; Common HTML elements
((start_tag
     (tag_name) @tag.builtin)
    (#any-of? @tag.builtin
        "html" "head" "body" "div" "span" "p" "a" "ul" "ol" "li"
        "table" "tr" "td" "th" "form" "input" "button" "select" "option"))

; Field names in Leaf directives
(leaf_conditional_attribute
    condition: (leaf_expression) @parameter)

(leaf_loop_attribute
    variable: (identifier) @parameter)

(leaf_loop_attribute
    collection: (leaf_expression) @parameter)

(leaf_set_directive
    variable: (identifier) @parameter)

(leaf_set_directive
    value: (leaf_expression) @parameter)

; Template names in import/extend directives
(leaf_import_attribute
    template: (quoted_string) @string.special.path)

(leaf_extend_attribute
    template: (quoted_string) @string.special.path)

(leaf_export_attribute
    name: (quoted_string) @string.special.symbol)

(leaf_inline_attribute
    template: (quoted_string) @string.special.path)