
; ===== HTML INDENTATION =====
((html_element
     (start_tag
         (tag_name) @_not_void_element))
    (#not-any-of? @_not_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

(html_self_closing_tag) @indent.begin

((start_tag
     (tag_name) @_void_element)
    (#any-of? @_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

(html_element
    (end_tag
        ">" @indent.end))

(html_self_closing_tag
    "/>" @indent.end)

(html_element
    (end_tag) @indent.branch)

[
    ">"
    "/>"
    ] @indent.branch

(html_comment) @indent.ignore
(comment) @indent.ignore
(leaf_comment) @indent.ignore

; ===== LEAF INDENTATION =====

; Target html_content inside directives specifically
(extend_directive
    (html_content) @indent.begin)

(export_directive
    (html_content) @indent.begin)

(if_directive
    (html_content) @indent.begin)

(unless_directive
    (html_content) @indent.begin)

(for_directive
    (html_content) @indent.begin)

(while_directive
    (html_content) @indent.begin)

; Use dedent on the end directives
(end_extend_directive) @indent.dedent
(end_export_directive) @indent.dedent
(end_if_directive) @indent.dedent
(end_unless_directive) @indent.dedent
(end_for_directive) @indent.dedent
(end_while_directive) @indent.dedent

; Branch on else/elseif
(else_directive) @indent.branch
(elseif_header) @indent.branch

; Leaf expression grouping
[
    "("
    "["
    "{"
    ] @indent.begin

[
    ")"
    "]"
    "}"
    ] @indent.end
