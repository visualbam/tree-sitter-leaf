
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

; ===== LEAF DIRECTIVE INDENTATION =====

; Use leaf_directive as the container and target specific directive types
((leaf_directive
     (if_directive)) @indent.begin)

((leaf_directive
     (unless_directive)) @indent.begin)

((leaf_directive
     (for_directive)) @indent.begin)

((leaf_directive
     (while_directive)) @indent.begin)

((leaf_directive
     (extend_directive)) @indent.begin)

((leaf_directive
     (export_directive)) @indent.begin)

; End directive handling - make them align with their start
((leaf_directive
     (if_directive
         (end_if_directive) @indent.branch)))

((leaf_directive
     (unless_directive
         (end_unless_directive) @indent.branch)))

((leaf_directive
     (for_directive
         (end_for_directive) @indent.branch)))

((leaf_directive
     (while_directive
         (end_while_directive) @indent.branch)))

((leaf_directive
     (extend_directive
         (end_extend_directive) @indent.branch)))

((leaf_directive
     (export_directive
         (end_export_directive) @indent.branch)))

; Branch directives
(else_directive) @indent.branch
(elseif_header) @indent.branch

; Expression grouping
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
