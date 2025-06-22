; Leaf Template Language Indentation Rules

; Block directives - indent after the directive, dedent at the end
(extend_directive) @indent.begin
"#endextend" @indent.dedent

(export_directive) @indent.begin
"#endexport" @indent.dedent

(if_directive) @indent.begin
"#endif" @indent.dedent

(unless_directive) @indent.begin
"#endunless" @indent.dedent

(for_directive) @indent.begin
"#endfor" @indent.dedent

(while_directive) @indent.begin
"#endwhile" @indent.dedent

; HTML elements - indent content inside tags
(html_element) @indent.begin
(end_tag) @indent.dedent

; Self-closing elements don't affect indentation
(html_self_closing_tag) @indent.auto

; Single-line directives don't affect indentation
(import_directive) @indent.auto
(evaluate_directive) @indent.auto
(leaf_variable) @indent.auto

; Comments and content don't affect indentation
(comment) @indent.auto
(html_comment) @indent.auto
(text) @indent.auto
