; Leaf Template Language Indentation Rules

; Block directives - indent after the directive, dedent at the end
(extend_directive) @indent.begin
(end_extend_directive) @indent.dedent

(export_directive) @indent.begin
(end_export_directive) @indent.dedent

(if_directive) @indent.begin
(end_if_directive) @indent.dedent

(unless_directive) @indent.begin
(end_unless_directive) @indent.dedent

(for_directive) @indent.begin
(end_for_directive) @indent.dedent

(while_directive) @indent.begin
(end_while_directive) @indent.dedent

; HTML elements - indent content between start and end tags
(html_element) @indent.begin
(end_tag) @indent.dedent

; Self-closing tags and single-line elements don't affect indentation
(html_self_closing_tag) @indent.auto
(import_directive) @indent.auto
(evaluate_directive) @indent.auto
(leaf_variable) @indent.auto

; Braces and brackets for expressions
"{" @indent.begin
"}" @indent.dedent

"[" @indent.begin
"]" @indent.dedent

"(" @indent.begin
")" @indent.dedent

; Comments and literals should not affect indentation
(comment) @indent.auto
(html_comment) @indent.auto
(string_literal) @indent.auto
(number_literal) @indent.auto
(boolean_literal) @indent.auto
(identifier) @indent.auto
(text) @indent.auto
