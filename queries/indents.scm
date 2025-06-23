
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

; These are the nodes that will be captured when we do `normal o`
; But last element has already been ended, so capturing this
; to mark end of last element
(html_element
    (end_tag
        ">" @indent.end))

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
(leaf_comment) @indent.ignore

; ===== LEAF INDENTATION =====

; Leaf directive blocks
(if_directive) @indent.begin
(unless_directive) @indent.begin
(for_directive) @indent.begin
(while_directive) @indent.begin
(extend_directive) @indent.begin
(export_directive) @indent.begin

; Leaf directive ends
(end_if_directive) @indent.end
(end_unless_directive) @indent.end
(end_for_directive) @indent.end
(end_while_directive) @indent.end
(end_extend_directive) @indent.end
(end_export_directive) @indent.end

; Leaf else/elseif branching
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