; Leaf Template Language Indentation Rules

; Increase indent after opening directives
[
    (extend_directive)
    (export_directive)
    (if_directive)
    (unless_directive)
    (for_directive)
    (while_directive)
    ] @indent.begin

; Decrease indent at closing directives
[
    (end_extend_directive)
    (end_export_directive)
    (end_if_directive)
    (end_unless_directive)
    (end_for_directive)
    (end_while_directive)
    ] @indent.dedent

; html elements that should increase indent
(html_element) @indent.begin
(start_tag) @indent.begin

; decrease indent at html closing tags
(end_tag) @indent.dedent

; self-closing html tags don't affect indentation
(html_self_closing_tag) @indent.auto

; braces and brackets
[
    "{"
    "["
    "("
    ] @indent.begin

[
    "}"
    "]"
    ")"
    ] @indent.dedent

; string literals and arrays that span multiple lines
(string_literal) @indent.auto
(array_literal) @indent.begin
(dictionary_literal) @indent.begin

; Comments don't affect indentation
(comment) @indent.auto
(html_comment) @indent.auto

; Function calls and expressions
(function_call) @indent.auto
(argument_list) @indent.begin

; Continue lines for incomplete expressions
(binary_expression) @indent.auto
(member_access) @indent.auto
