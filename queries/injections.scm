; Special handling for attribute value delimiters
((quoted_attribute_value) @injection.content
  (#set! injection.language "leaf-attr-quotes"))

; The actual injection grammar will be defined in the editor config
; ===== HTML INJECTIONS =====
((html_comment) @injection.content
    (#set! injection.language "comment"))

; <style>...</style>
; <style blocking> ...</style>
; Add "lang" to predicate check so that vue/svelte can inherit this
; without having this element being captured twice
((html_element
     (start_tag
         (tag_name) @_style) @_no_type_lang
     (html_content) @injection.content)
    (#eq? @_style "style")
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "css"))

((html_element
     (start_tag
         (tag_name) @_style
         (attribute
             (attribute_name) @_type
             (quoted_attribute_value
                 (attribute_value) @_css)))
     (html_content) @injection.content)
    (#eq? @_style "style")
    (#eq? @_type "type")
    (#eq? @_css "text/css")
    (#set! injection.language "css"))

; <script>...</script>
; <script defer>...</script>
((html_element
     (start_tag
         (tag_name) @_script) @_no_type_lang
     (html_content) @injection.content)
    (#eq? @_script "script")
    (#not-lua-match? @_no_type_lang "%slang%s*=")
    (#not-lua-match? @_no_type_lang "%stype%s*=")
    (#set! injection.language "javascript"))

; <script type="mimetype-or-well-known-script-type">
((html_element
     (start_tag
         (tag_name) @_script
         (attribute
             (attribute_name) @_attr
             (quoted_attribute_value
                 (attribute_value) @_type)))
     (html_content) @injection.content)
    (#eq? @_script "script")
    (#eq? @_attr "type")
    (#set-lang-from-mimetype! @_type))

; <a style="/* css */">
((attribute
     (attribute_name) @_attr
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#eq? @_attr "style")
    (#set! injection.language "css"))

; lit-html style template interpolation
; <a @click=${e => console.log(e)}>
; <a @click="${e => console.log(e)}">
((attribute
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @injection.content "%${")
    (#offset! @injection.content 0 2 0 -1)
    (#set! injection.language "javascript"))

; Handle unquoted attribute values with template literals
((attribute
     (unquoted_attribute_value) @injection.content)
    (#lua-match? @injection.content "%${")
    (#offset! @injection.content 0 2 0 -2)
    (#set! injection.language "javascript"))

; <input pattern="[0-9]"> or <input pattern=[0-9]>
((html_element
     (start_tag
         (tag_name) @_tagname
         (attribute
             (attribute_name) @_attr
             [
                 (quoted_attribute_value
                     (attribute_value) @injection.content)
                 (unquoted_attribute_value) @injection.content
                 ])))
    (#eq? @_tagname "input")
    (#eq? @_attr "pattern")
    (#set! injection.language "regex"))

; <input type="checkbox" onchange="this.closest('form').elements.output.value = this.checked">
((attribute
     (attribute_name) @_name
     (quoted_attribute_value
         (attribute_value) @injection.content))
    (#lua-match? @_name "^on[a-z]+$")
    (#set! injection.language "javascript"))

; ===== LEAF INJECTIONS =====

; Leaf string literals can contain expressions
((string_literal) @injection.content
    (#lua-match? @injection.content "#{")
    (#set! injection.language "leaf"))

; Leaf expressions in HTML attributes
((attribute
     (leaf_variable
         (expression) @injection.content))
    (#set! injection.language "leaf"))