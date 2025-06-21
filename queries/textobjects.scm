; Functions
(function_call) @function.outer
(function_call (identifier) @function.inner)

; Blocks
[
  (extend_directive)
  (export_directive)
  (if_directive)
  (unless_directive)
  (for_directive)
  (while_directive)
] @block.outer

; Parameters
(argument_list) @parameter.outer
(expression) @parameter.inner

; Classes (treating HTML elements as classes)
(html_element) @class.outer
(html_content) @class.inner
