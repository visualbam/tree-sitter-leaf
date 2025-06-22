; Indent after directive starts
(extend_directive) @indent
(export_directive) @indent
(if_directive) @indent
(unless_directive) @indent
(for_directive) @indent
(while_directive) @indent

; HTML indentation
(html_element) @indent

; Outdent on end directives
(end_extend_directive) @outdent
(end_export_directive) @outdent
(end_if_directive) @outdent
(end_unless_directive) @outdent
(end_for_directive) @outdent
(end_while_directive) @outdent

; HTML end tag outdent
(end_tag) @outdent