; Use named fields for indentation
(extend_directive
    start: _ @indent.begin
    end: _ @indent.end)

(export_directive
    start: _ @indent.begin
    end: _ @indent.end)

(if_directive
    start: _ @indent.begin
    end: _ @indent.end)

(unless_directive
    start: _ @indent.begin
    end: _ @indent.end)

(for_directive
    start: _ @indent.begin
    end: _ @indent.end)

(while_directive
    start: _ @indent.begin
    end: _ @indent.end)

(html_element
    start: _ @indent.begin
    end: _ @indent.end)