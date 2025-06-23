module.exports = grammar({
    name: "leaf",

    extras: ($) => [
        /\s/,
        $.comment,
        token(prec(-1, /\n/))
    ],

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
                    $.html_element,
                    $.html_self_closing_tag,
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

        // Define explicit end directive nodes
        end_extend_directive: $ => "#endextend",
        end_export_directive: $ => "#endexport",
        end_if_directive: $ => "#endif",
        end_unless_directive: $ => "#endunless",
        end_for_directive: $ => "#endfor",
        end_while_directive: $ => "#endwhile",

        // Block directives with unified headers
        extend_directive: ($) =>
            seq(
                $.extend_header,
                repeat(
                    choice(
                        $.export_directive,
                        $.import_directive,
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_extend_directive,
            ),

        export_directive: ($) =>
            seq(
                $.export_header,
                repeat(
                    choice(
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_export_directive,
            ),

        if_directive: ($) =>
            seq(
                $.if_header,
                repeat(
                    choice(
                        $.export_directive,
                        $.import_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_if_directive,
            ),

        unless_directive: ($) =>
            seq(
                $.unless_header,
                repeat(
                    choice(
                        $.export_directive,
                        $.import_directive,
                        $.if_directive,
                        $.for_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_unless_directive,
            ),

        for_directive: ($) =>
            seq(
                $.for_header,
                repeat(
                    choice(
                        $.export_directive,
                        $.import_directive,
                        $.if_directive,
                        $.unless_directive,
                        $.while_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_for_directive,
            ),

        while_directive: ($) =>
            seq(
                $.while_header,
                repeat(
                    choice(
                        $.export_directive,
                        $.import_directive,
                        $.if_directive,
                        $.unless_directive,
                        $.for_directive,
                        $.evaluate_directive,
                        $.leaf_variable,
                        $.html_element,
                        $.html_self_closing_tag,
                        $.html_comment,
                        $.text,
                    ),
                ),
                $.end_while_directive,
            ),

        // Directive headers as unified tokens
        extend_header: ($) => seq(
            token('#extend'),
            token('('),
            $.string_literal,
            token(')'),
            token(':')
        ),
        export_header: ($) => seq(
            token('#export'),
            token('('),
            $.string_literal,
            token(')'),
            token(':')
        ),
        if_header: ($) => seq(
            token('#if'),
            token('('),
            $.expression,
            token(')'),
            token(':')
        ),
        unless_header: ($) => seq(
            token('#unless'),
            token('('),
            $.expression,
            token(')'),
            token(':')
        ),
        for_header: ($) => seq(
            token('#for'),
            token('('),
            $.identifier,
            token('in'),
            $.expression,
            token(')'),
            token(':')
        ),
        while_header: ($) => seq(
            token('#while'),
            token('('),
            $.expression,
            token(')'),
            token(':')
        ),

        // Simple directives
        import_directive: ($) => seq(
            token('#import('),
            $.string_literal,
            token(')')
        ),
        evaluate_directive: ($) => seq(
            token('#evaluate('),
            $.expression,
            token(')')
        ),

        // Leaf variables
        leaf_variable: ($) => seq(
            token('#('),
            $.expression,
            token(')')
        ),

        // Expressions
        expression: ($) =>
            choice(
                $.member_access,
                $.function_call,
                $.identifier,
                $.string_literal,
                $.number_literal,
                $.boolean_literal,
                $.array_literal,
                $.dictionary_literal,
                $.ternary_expression,
                $.binary_expression,
                $.unary_expression,
                $.parenthesized_expression,
            ),

        // HTML elements
        html_element: ($) =>
            seq(
                $.start_tag,
                optional($.html_content),
                $.end_tag
            ),

        html_content: ($) =>
            repeat1(
                choice(
                    $.if_directive,
                    $.unless_directive,
                    $.for_directive,
                    $.while_directive,
                    $.evaluate_directive,
                    $.leaf_variable,
                    $.html_element,
                    $.html_self_closing_tag,
                    $.html_comment,
                    $.text,
                ),
            ),

        start_tag: ($) => seq(
            token('<'),
            $.tag_name,
            repeat($.attribute),
            token('>')
        ),

        end_tag: ($) => seq(
            token('</'),
            $.tag_name,
            token('>')
        ),

        html_self_closing_tag: ($) =>
            seq(
                token('<'),
                $.tag_name,
                repeat($.attribute),
                token('/>')
            ),

        tag_name: ($) => /[a-zA-Z][a-zA-Z0-9-]*/,

        attribute: ($) =>
            seq(
                $.attribute_name,
                optional(seq(
                    token('='),
                    $.attribute_value
                ))
            ),

        attribute_name: ($) => /[a-zA-Z:_][a-zA-Z0-9:._-]*/,

        attribute_value: ($) =>
            choice($.quoted_attribute_value, $.leaf_variable, /[^\s"'=<>`#]+/),

        quoted_attribute_value: ($) =>
            choice(
                seq(
                    token('"'),
                    repeat(choice(/[^"#]+/, $.leaf_variable)),
                    token('"')
                ),
                seq(
                    token("'"),
                    repeat(choice(/[^'#]+/, $.leaf_variable)),
                    token("'")
                ),
            ),

        html_comment: ($) => seq(
            token('<!--'),
            /[^>]*(-[^>]+)*?/,
            token('-->')
        ),

        // Expression components
        member_access: ($) =>
            prec.left(1, seq(
                $.identifier,
                repeat1(seq(
                    token('.'),
                    $.identifier
                ))
            )),

        function_call: ($) =>
            prec.left(2, seq(
                $.identifier,
                token('('),
                optional($.argument_list),
                token(')')
            )),

        argument_list: ($) => seq(
            $.expression,
            repeat(seq(
                token(','),
                $.expression
            ))
        ),

        ternary_expression: ($) =>
            prec.right(seq(
                $.expression,
                token('?'),
                $.expression,
                token(':'),
                $.expression
            )),

        binary_expression: ($) =>
            choice(
                prec.left(1, seq(
                    $.expression,
                    token('||'),
                    $.expression
                )),
                prec.left(2, seq(
                    $.expression,
                    token('&&'),
                    $.expression
                )),
                prec.left(3, seq(
                    $.expression,
                    choice(token('=='), token('!=')),
                    $.expression
                )),
                prec.left(4, seq(
                    $.expression,
                    choice(token('<'), token('>'), token('<='), token('>=')),
                    $.expression
                )),
                prec.left(5, seq(
                    $.expression,
                    choice(token('+'), token('-')),
                    $.expression
                )),
                prec.left(6, seq(
                    $.expression,
                    choice(token('*'), token('/'), token('%')),
                    $.expression
                )),
            ),

        unary_expression: ($) =>
            prec.right(seq(
                choice(token('!'), token('-'), token('+')),
                $.expression
            )),

        parenthesized_expression: ($) => seq(
            token('('),
            $.expression,
            token(')')
        ),

        array_literal: ($) =>
            seq(
                token('['),
                optional(
                    seq(
                        $.expression,
                        repeat(seq(token(','), $.expression)),
                        optional(token(','))
                    ),
                ),
                token(']')
            ),

        dictionary_literal: ($) =>
            seq(
                token('{'),
                optional(
                    seq(
                        $.key_value_pair,
                        repeat(seq(token(','), $.key_value_pair)),
                        optional(token(','))
                    ),
                ),
                token('}')
            ),

        key_value_pair: ($) =>
            seq(
                choice($.string_literal, $.identifier),
                token(':'),
                $.expression
            ),

        // Literals
        string_literal: ($) =>
            choice(
                seq(
                    token('"'),
                    repeat(choice(/[^"\\]+/, /\\./)),
                    token('"')
                ),
                seq(
                    token("'"),
                    repeat(choice(/[^'\\]+/, /\\./)),
                    token("'")
                ),
            ),

        number_literal: ($) => choice(/\d+\.\d+/, /\d+/),

        boolean_literal: ($) => choice("true", "false"),

        identifier: ($) => /[a-zA-Z_][a-zA-Z0-9_]*/,

        text: ($) => /[^#<\s]+([^#<]*[^#<\s]+)*/,

        comment: ($) => seq(
            token('#*'),
            /[^*]*\*+([^#*][^*]*\*+)*/,
            token('#')
        ),
    },
});