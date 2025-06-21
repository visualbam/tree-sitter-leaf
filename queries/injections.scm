; Inject CSS into style attributes
(attribute
  (attribute_name) @_attr
  (attribute_value) @injection.content
  (#eq? @_attr "style")
  (#set! injection.language "css"))

; Inject JavaScript into script attributes and event handlers
(attribute
  (attribute_name) @_attr
  (attribute_value) @injection.content
  (#match? @_attr "^(onclick|onload|onchange|onsubmit|onerror|onkeydown|onkeyup|onmousedown|onmouseup|onmouseover|onmouseout)$")
  (#set! injection.language "javascript"))

; Inject JavaScript expressions into Leaf variables
(leaf_variable
  (expression) @injection.content
  (#set! injection.language "javascript"))

; Inject CSS into style tags
(html_element
  (start_tag (tag_name) @_tag)
  (html_content) @injection.content
  (#eq? @_tag "style")
  (#set! injection.language "css"))

; Inject JavaScript into script tags
(html_element
  (start_tag (tag_name) @_tag)
  (html_content) @injection.content
  (#eq? @_tag "script")
  (#set! injection.language "javascript"))
