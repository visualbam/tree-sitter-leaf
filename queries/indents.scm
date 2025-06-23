
((html_element
     (start_tag
         (tag_name) @_not_void_element))
    (#not-any-of? @_not_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

; Self-closing tags are standalone nodes, not children of html_element
(html_self_closing_tag) @indent.begin

((start_tag
     (tag_name) @_void_element)
    (#any-of? @_void_element
        "area" "base" "basefont" "bgsound" "br" "col" "command" "embed" "frame" "hr" "image" "img"
        "input" "isindex" "keygen" "link" "menuitem" "meta" "nextid" "param" "source" "track" "wbr")) @indent.begin

; These are the nodes that will be captured when we do `normal o`
; But last element has already been ended, so capturing this
; to mark end of last element
(html_element
    (end_tag
        ">" @indent.end))

; Self-closing tags end with />
(html_self_closing_tag
    "/>" @indent.end)

; Script/style elements aren't indented, so only branch the end tag of other elements
(html_element
    (end_tag) @indent.branch)

[
    ">"
    "/>"
    ] @indent.branch

(html_comment) @indent.ignore
(comment) @indent.ignore

; Leaf-specific indents
(if_directive) @indent.begin

(else_directive) @indent.same

(end_if_directive) @indent.end

(for_directive) @indent.begin

(end_for_directive) @indent.end

(unless_directive) @indent.begin

(end_unless_directive) @indent.end

(while_directive) @indent.begin

(end_while_directive) @indent.end

(extend_directive) @indent.begin

(end_extend_directive) @indent.end

(export_directive) @indent.begin

(end_export_directive) @indent.end

(leaf_variable) @indent.same