
module.exports = grammar({
    name: 'leaf',

    rules: {
        template: ($) =>
            repeat(
                choice(
                    $.extend_directive,
                    $.export_directive,
                    $.import_directive,
                    $.if_directive,
                    $.unless_directive,
                    $.for_directive,
                    $.while_directive,
                    $.evaluate_directive,
                    $.leaf_variable,
                    $.style_element,
                    $.script_element,
                    $.element,
                    $.self_closing_tag,
                    $.html_comment,
                    $.text,
                    $.comment,
                    $.end_extend_directive,
                    $.end_export_directive,
                    $.end_if_directive,
                    $.end_unless_directive,
                    $.end_for_directive,
                    $.end_while_directive,
                ),
            ),

        // HTML Elements
        element: ($) =>
            seq(
                $.start_tag,
                optional(repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.style_element,
                        $.script_element,
                        $.element,
                        $.self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                )),
                $.end_tag,
            ),

        style_element: ($) =>
            seq(
                $.start_tag,
                optional($.raw_text),
                $.end_tag,
            ),

        script_element: ($) =>
            seq(
                $.start_tag,
                optional($.raw_text),
                $.end_tag,
            ),

        start_tag: ($) =>
            seq(
                token('<'),
                $.tag_name,
                repeat($.attribute),
                token('>'),
            ),

        end_tag: ($) =>
            seq(
                token('</'),
                $.tag_name,
                token('>'),
            ),

        self_closing_tag: ($) =>
            seq(
                token('<'),
                $.tag_name,
                repeat($.attribute),
                token('/>'),
            ),

        tag_name: ($) => /[a-zA-Z][a-zA-Z0-9-_]*/,

        attribute: ($) =>
            seq(
                $.attribute_name,
                optional(seq(
                    token('='),
                    choice(
                        $.quoted_attribute_value,
                        $.attribute_value,
                    ),
                )),
            ),

        attribute_name: ($) => /[a-zA-Z_:@][a-zA-Z0-9_:.-]*/,

        quoted_attribute_value: ($) =>
            choice(
                seq(
                    token('"'),
                    optional($.attribute_value),
                    token('"'),
                ),
                seq(
                    token("'"),
                    optional($.attribute_value),
                    token("'"),
                ),
            ),

        attribute_value: ($) =>
            choice(
                repeat1(choice(/[^"'#<>\s]+/, $.leaf_variable)),
                $.leaf_variable,
            ),

        raw_text: ($) => token(prec(-1, /[^<]+/)),

        text: ($) => token(prec(-1, /[^<#]+/)),

        html_comment: ($) =>
            seq(
                token('<!--'),
                optional(token(prec(-1, /[^>]*/))),
                token('-->'),
            ),

        // Leaf-specific constructs
        comment: ($) =>
            seq(
                token('##'),
                optional(token(prec(-1, /.*/)))
            ),

        leaf_variable: ($) =>
            seq(
                token('#('),
                $.expression,
                token(')'),
            ),

        evaluate_directive: ($) =>
            seq(
                token('#evaluate('),
                $.expression,
                token(')'),
            ),

        extend_directive: ($) =>
            seq(
                token('#extend'),
                token('('),
                $.string_literal,
                token(')'),
                token(':'),
            ),

        export_directive: ($) =>
            seq(
                token('#export'),
                token('('),
                $.string_literal,
                token(')'),
                token(':'),
            ),

        import_directive: ($) =>
            seq(
                token('#import'),
                token('('),
                $.string_literal,
                token(')'),
            ),

        if_directive: ($) =>
            seq(
                $.if_header,
                repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.style_element,
                        $.script_element,
                        $.element,
                        $.self_closing_tag,
                        $.html_comment,
                        $.text,
                        $.comment,
                    ),
                ),
                $.end_if_directive,
            ),

        unless_directive: ($) =>
            seq(
                $.unless_header,
                repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.style_element,
                        $.script_element,
                        $.element,
                        $.self_closing_tag,
                        $.html_comment,
                        $.text,
                        $.comment,
                    ),
                ),
                $.end_unless_directive,
            ),

        for_directive: ($) =>
            seq(
                $.for_header,
                repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.style_element,
                        $.script_element,
                        $.element,
                        $.self_closing_tag,
                        $.html_comment,
                        $.text,
                        $.comment,
                    ),
                ),
                $.end_for_directive,
            ),

        while_directive: ($) =>
            seq(
                $.while_header,
                repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.style_element,
                        $.script_element,
                        $.element,
                        $.self_closing_tag,
                        $.html_comment,
                        $.text,
                        $.comment,
                    ),
                ),
                $.end_while_directive,
            ),

        if_header: ($) =>
            seq(
                token('#if'),
                token('('),
                $.expression,
                token(')'),
                token(':'),
            ),

        unless_header: ($) =>
            seq(
                token('#unless'),
                token('('),
                $.expression,
                token(')'),
                token(':'),
            ),

        for_header: ($) =>
            seq(
                token('#for'),
                token('('),
                $.expression,
                token(')'),
                token(':'),
            ),

        while_header: ($) =>
            seq(
                token('#while'),
                token('('),
                $.expression,
                token(')'),
                token(':'),
            ),

        end_extend_directive: ($) => token('#endextend'),
        end_export_directive: ($) => token('#endexport'),
        end_if_directive: ($) => token('#endif'),
        end_unless_directive: ($) => token('#endunless'),
        end_for_directive: ($) => token('#endfor'),
        end_while_directive: ($) => token('#endwhile'),

        expression: ($) => token(prec(-1, /[^)]+/)),

        string_literal: ($) =>
            choice(
                seq(token('"'), optional(token(prec(-1, /[^"]*/))), token('"')),
                seq(token("'"), optional(token(prec(-1, /[^']*/)), token("'")),
                )),
    },

    conflicts: $ => [
        [$.style_element, $.element],
        [$.script_element, $.element],
    ],

    extras: $ => [/\s/],
});