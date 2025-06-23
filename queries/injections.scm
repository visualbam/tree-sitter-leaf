
; ===== HTML INJECTIONS =====

; HTML Comments
((comment) @injection.content
    (#set! injection.language "comment"))

; Leaf Comments
((leaf_comment) @injection.content
    (#set! injection.language "comment"))

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
((attribute
     (attribute_name) @_name
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @_name "^on[a-z]+$")
    (#set! injection.language "javascript"))

; Regular expressions in pattern attributes
; <input pattern="[0-9]">
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#eq? @_attr "pattern")
    (#set! injection.language "regex"))

; ===== VAPOR LEAF INJECTIONS =====

; Leaf expressions in interpolations
; #(variable.name)
; #(complex.expression())
((leaf_interpolation
     (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in conditional attributes
; #if(user.isAdmin)
((leaf_conditional_attribute
     (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; Leaf expressions in loop attributes
; #for(item in items)
((leaf_loop_attribute
     (leaf_expression) @injection.content)
    (#set! injection.language "swift"))

; ===== LEAF EXPRESSION INJECTIONS =====

; Function calls in Leaf
((leaf_function_call) @injection.content
    (#set! injection.language "swift"))

; Member access in Leaf
((leaf_member_access) @injection.content
    (#set! injection.language "swift"))

; Array access in Leaf
((leaf_array_access) @injection.content
    (#set! injection.language "swift"))

; Binary expressions in Leaf
((leaf_binary_expression) @injection.content
    (#set! injection.language "swift"))

; Ternary expressions in Leaf
((leaf_ternary_expression) @injection.content
    (#set! injection.language "swift"))

; Unary expressions in Leaf
((leaf_unary_expression) @injection.content
    (#set! injection.language "swift"))

; Parenthesized expressions in Leaf
((leaf_parenthesized_expression) @injection.content
    (#set! injection.language "swift"))

; ===== CSS AND JAVASCRIPT IN ELEMENTS =====

; CSS in style elements (basic detection)
((element
     (start_tag
         (tag_name) @_tag)
     (text) @injection.content)
    (#eq? @_tag "style")
    (#set! injection.language "css"))

; JavaScript in script elements (basic detection)
((element
     (start_tag
         (tag_name) @_tag)
     (text) @injection.content)
    (#eq? @_tag "script")
    (#set! injection.language "javascript"))

; ===== SPECIALIZED CONTENT TYPE INJECTIONS =====

; JSON-like data in string literals
((string_literal) @injection.content
    (#lua-match? @injection.content "^[\"']%s*[{%[]")
    (#set! injection.language "json"))

; XML-like data in string literals
((string_literal) @injection.content
    (#lua-match? @injection.content "<%?xml")
    (#set! injection.language "xml"))

; HTML-like data in string literals
((string_literal) @injection.content
    (#lua-match? @injection.content "<!DOCTYPE%s+html")
    (#set! injection.language "html"))

; SQL-like strings in string literals
((string_literal) @injection.content
    (#lua-match? @injection.content "SELECT%s+")
    (#set! injection.language "sql"))

((string_literal) @injection.content
    (#lua-match? @injection.content "INSERT%s+")
    (#set! injection.language "sql"))

((string_literal) @injection.content
    (#lua-match? @injection.content "UPDATE%s+")
    (#set! injection.language "sql"))

((string_literal) @injection.content
    (#lua-match? @injection.content "DELETE%s+")
    (#set! injection.language "sql"))

; ===== MIXED CONTENT INJECTIONS =====

; CSS with potential Leaf interpolations in style attributes
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#eq? @_attr "style")
    (#lua-match? @injection.content "#%(")
    (#set! injection.language "css"))

; JavaScript with potential Leaf interpolations in event handlers
((attribute
     (attribute_name) @_name
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @_name "^on[a-z]+$")
    (#lua-match? @injection.content "#%(")
    (#set! injection.language "javascript"))

; ===== BASIC LEAF TYPES =====

; Basic identifiers
((identifier) @injection.content
    (#set! injection.language "swift"))

; Argument lists in function calls
((argument_list) @injection.content
    (#set! injection.language "swift"))