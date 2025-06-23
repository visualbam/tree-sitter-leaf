; ===== HTML INJECTIONS =====

; HTML Comments
((comment) @injection.content
    (#set! injection.language "comment"))

; CSS in style elements
; <style>...</style>
; <style blocking>...</style>
; Add "lang" to predicate check so that vue/svelte can inherit this
; without having this element being captured twice
((style_element
     (start_tag) @_no_type_lang
     (raw_text) @injection.content)
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "css"))

((style_element
     (start_tag
         (attribute
             (attribute_name) @_type
             (quoted_attribute_value
                 (attribute_value) @_css)))
     (raw_text) @injection.content)
    (#eq? @_type "type")
    (#eq? @_css "text/css")
    (#set! injection.language "css"))

; JavaScript in script elements
; <script>...</script>
; <script defer>...</script>
((script_element
     (start_tag) @_no_type_lang
     (raw_text) @injection.content)
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "javascript"))

; <script type="mimetype-or-well-known-script-type">
(script_element
    (start_tag
        (attribute
            (attribute_name) @_attr
            (#eq? @_attr "type")
            (quoted_attribute_value
                (attribute_value) @_type)))
    (raw_text) @injection.content
    (#set-lang-from-mimetype! @_type))

; CSS in style attributes
; <a style="/* css */">
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#eq? @_attr "style")
    (#set! injection.language "css"))

; JavaScript in event handler attributes
; <input type="checkbox" onchange="this.closest('form').elements.output.value = this.checked">
(attribute
    (attribute_name) @_name
    (#lua-match? @_name "^on[a-z]+$")
    (quoted_attribute_value
        (attribute_value) @injection.content)
    (#set! injection.language "javascript"))

; Regular expressions in pattern attributes
; <input pattern="[0-9]"> or <input pattern=[0-9]>
(element
    (_
        (tag_name) @_tagname
        (#eq? @_tagname "input")
        (attribute
            (attribute_name) @_attr
            [
                (quoted_attribute_value
                    (attribute_value) @injection.content)
                (attribute_value) @injection.content
                ]
            (#eq? @_attr "pattern"))
        (#set! injection.language "regex")))

; lit-html style template interpolation
; <a @click=${e => console.log(e)}>
; <a @click="${e => console.log(e)}">
((attribute
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @injection.content "%${")
    (#offset! @injection.content 0 2 0 -1)
    (#set! injection.language "javascript"))

((attribute
     (attribute_value) @injection.content)
    (#lua-match? @injection.content "%${")
    (#offset! @injection.content 0 2 0 -2)
    (#set! injection.language "javascript"))

; ===== VAPOR LEAF INJECTIONS =====

; Leaf expressions in interpolations
; #(variable.name)
; #{complex.expression()}
((leaf_interpolation
     (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in directive conditions
; #if(user.isAdmin)
((leaf_conditional_attribute
     condition: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in loop variables
; #for(item in items)
((leaf_loop_attribute
     collection: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in set directives
; #set(title = "Hello World")
((leaf_set_directive
     value: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in evaluate directives
; #evaluate(someFunction())
((leaf_evaluate_directive
     expression: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in raw content directives
; #raw(dangerousHTML)
((leaf_raw_attribute
     content: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_unsaferaw_attribute
     content: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in inline directive context
; #inline("template", context)
((leaf_inline_attribute
     context: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in custom directive parameters
((leaf_custom_attribute
     (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; ===== MIXED CONTENT INJECTIONS =====

; CSS with Leaf interpolations in style elements
((style_element
     (start_tag) @_no_type_lang
     (raw_text) @injection.content)
    (#lua-match? @injection.content "#[({]")
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "css"))

; JavaScript with Leaf interpolations in script elements
((script_element
     (start_tag) @_no_type_lang
     (raw_text) @injection.content)
    (#lua-match? @injection.content "#[({]")
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "javascript"))

; CSS with Leaf interpolations in style attributes
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#eq? @_attr "style")
    (#lua-match? @injection.content "#[({]")
    (#set! injection.language "css"))

; JavaScript with Leaf interpolations in event handlers
((attribute
     (attribute_name) @_name
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @_name "^on[a-z]+$")
    (#lua-match? @injection.content "#[({]")
    (#set! injection.language "javascript"))

; ===== LEAF TEMPLATE INJECTIONS =====

; Template names in import/extend directives (treat as file paths)
((leaf_import_attribute
     template: (quoted_string) @injection.content)
    (#set! injection.language "filepath"))

((leaf_extend_attribute
     template: (quoted_string) @injection.content)
    (#set! injection.language "filepath"))

((leaf_inline_attribute
     template: (quoted_string) @injection.content)
    (#set! injection.language "filepath"))

; ===== ADVANCED LEAF INJECTIONS =====

; Complex Leaf expressions (function calls, member access, etc.)
((leaf_function_call
     function: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_member_access
     object: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_array_access
     array: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_array_access
     index: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Binary expressions in Leaf
((leaf_binary_expression
     left: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_binary_expression
     right: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Ternary expressions in Leaf
((leaf_ternary_expression
     condition: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_ternary_expression
     consequent: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

((leaf_ternary_expression
     alternate: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Unary expressions in Leaf
((leaf_unary_expression
     operand: (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; ===== CONTEXTUAL INJECTIONS =====

; Leaf expressions within HTML attribute values
((quoted_attribute_value
     (leaf_interpolation
         (leaf_expression) @injection.content))
    (#set! injection.language "swift"))

; Leaf expressions in text content
((text
     (leaf_interpolation
         (leaf_expression) @injection.content))
    (#set! injection.language "swift"))

; ===== SPECIALIZED CONTENT TYPE INJECTIONS =====

; JSON-like data in Leaf expressions
((leaf_expression) @injection.content
    (#lua-match? @injection.content "^%s*[{%[]")
    (#set! injection.language "json"))

; SQL-like strings in Leaf expressions  
((leaf_expression) @injection.content
    (#lua-match? @injection.content "SELECT%s+")
    (#set! injection.language "sql"))

((leaf_expression) @injection.content
    (#lua-match? @injection.content "INSERT%s+")
    (#set! injection.language "sql"))

((leaf_expression) @injection.content
    (#lua-match? @injection.content "UPDATE%s+")
    (#set! injection.language "sql"))

((leaf_expression) @injection.content
    (#lua-match? @injection.content "DELETE%s+")
    (#set! injection.language "sql"))

; ===== TEMPLATE LITERAL INJECTIONS =====

; Multi-line string literals that might contain other languages
((string_literal) @injection.content
    (#lua-match? @injection.content "<%?xml")
    (#set! injection.language "xml"))

((string_literal) @injection.content
    (#lua-match? @injection.content "<!DOCTYPE%s+html")
    (#set! injection.language "html"))

((string_literal) @injection.content
    (#lua-match? @injection.content "^%s*{")
    (#set! injection.language "json"))

; ===== ERROR RECOVERY INJECTIONS =====

; Fallback for unrecognized Leaf expressions
((leaf_expression) @injection.content
    (#not-has-parent? leaf_interpolation)
    (#not-has-parent? leaf_conditional_attribute)
    (#not-has-parent? leaf_loop_attribute)
    (#set! injection.language "swift"))

; ===== PERFORMANCE OPTIMIZATIONS =====

; Only inject Swift for non-trivial Leaf expressions
((leaf_expression) @injection.content
    (#lua-match? @injection.content "[.(%[]")
    (#set! injection.language "swift")
    (#set! injection.include-children))

; Simple identifiers don't need injection
((leaf_expression
     (identifier)) @injection.content
    (#not-lua-match? @injection.content "[.(%[]")
    (#set! injection.language "swift"))