
module.exports = grammar({
    name: "leaf",

    extras: ($) => [
        /\s/,
        $.comment,
        // Add explicit newline handling for blocks
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
                    // Add standalone end directives
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

        // Block directives with explicit end tags and named fields
        extend_directive: ($) =>
            seq(
                "#extend",
                "(",
                field('template', $.string_literal),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_extend_directive),
            ),

        export_directive: ($) =>
            seq(
                "#export",
                "(",
                field('name', $.string_literal),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_export_directive),
            ),

        if_directive: ($) =>
            seq(
                "#if",
                "(",
                field('condition', $.expression),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_if_directive),
            ),

        unless_directive: ($) =>
            seq(
                "#unless",
                "(",
                field('condition', $.expression),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_unless_directive),
            ),

        for_directive: ($) =>
            seq(
                "#for",
                "(",
                field('variable', $.identifier),
                "in",
                field('iterable', $.expression),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_for_directive),
            ),

        while_directive: ($) =>
            seq(
                "#while",
                "(",
                field('condition', $.expression),
                ")",
                ":",
                field('body', repeat(
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
                )),
                field('end', $.end_while_directive),
            ),

        // Simple directives
        import_directive: ($) => seq("#import(", $.string_literal, ")"),

        evaluate_directive: ($) => seq("#evaluate(", $.expression, ")"),

        // Leaf variables
        leaf_variable: ($) => seq("#(", $.expression, ")"),

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

        // HTML elements with enhanced structure
        html_element: ($) =>
            seq(
                field('start_tag', $.start_tag),
                field('content', optional($.html_content)),
                field('end_tag', $.end_tag)
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

        start_tag: ($) => seq("<", $.tag_name, repeat($.attribute), ">"),

        end_tag: ($) => seq("</", $.tag_name, ">"),

        html_self_closing_tag: ($) =>
            seq("<", $.tag_name, repeat($.attribute), "/>"),

        tag_name: ($) => /[a-zA-Z][a-zA-Z0-9-]*/,

        attribute: ($) =>
            seq($.attribute_name, optional(seq("=", $.attribute_value))),

        attribute_name: ($) => /[a-zA-Z:_][a-zA-Z0-9:._-]*/,

        attribute_value: ($) =>
            choice($.quoted_attribute_value, $.leaf_variable, /[^\s"'=<>`#]+/),

        quoted_attribute_value: ($) =>
            choice(
                seq('"', repeat(choice(/[^"#]+/, $.leaf_variable)), '"'),
                seq("'", repeat(choice(/[^'#]+/, $.leaf_variable)), "'"),
            ),

        html_comment: ($) => seq("<!--", /[^>]*(-[^>]+)*?/, "-->"),

        // Expression components
        member_access: ($) =>
            prec.left(1, seq($.identifier, repeat1(seq(".", $.identifier)))),

        function_call: ($) =>
            prec.left(2, seq($.identifier, "(", optional($.argument_list), ")")),

        argument_list: ($) => seq($.expression, repeat(seq(",", $.expression))),

        ternary_expression: ($) =>
            prec.right(seq($.expression, "?", $.expression, ":", $.expression)),

        binary_expression: ($) =>
            choice(
                prec.left(1, seq($.expression, "||", $.expression)),
                prec.left(2, seq($.expression, "&&", $.expression)),
                prec.left(3, seq($.expression, choice("==", "!="), $.expression)),
                prec.left(
                    4,
                    seq($.expression, choice("<", ">", "<=", ">="), $.expression),
                ),
                prec.left(5, seq($.expression, choice("+", "-"), $.expression)),
                prec.left(6, seq($.expression, choice("*", "/", "%"), $.expression)),
            ),

        unary_expression: ($) =>
            prec.right(seq(choice("!", "-", "+"), $.expression)),

        parenthesized_expression: ($) => seq("(", $.expression, ")"),

        array_literal: ($) =>
            seq(
                "[",
                optional(
                    seq($.expression, repeat(seq(",", $.expression)), optional(",")),
                ),
                "]",
            ),

        dictionary_literal: ($) =>
            seq(
                "{",
                optional(
                    seq(
                        $.key_value_pair,
                        repeat(seq(",", $.key_value_pair)),
                        optional(","),
                    ),
                ),
                "}",
            ),

        key_value_pair: ($) =>
            seq(choice($.string_literal, $.identifier), ":", $.expression),

        // Literals
        string_literal: ($) =>
            choice(
                seq('"', repeat(choice(/[^"\\]+/, /\\./)), '"'),
                seq("'", repeat(choice(/[^'\\]+/, /\\./)), "'"),
            ),

        number_literal: ($) => choice(/\d+\.\d+/, /\d+/),

        boolean_literal: ($) => choice("true", "false"),

        identifier: ($) => /[a-zA-Z_][a-zA-Z0-9_]*/,

        text: ($) => /[^#<\s]+([^#<]*[^#<\s]+)*/,

        comment: ($) => seq("#*", /[^*]*\*+([^#*][^*]*\*+)*/, "#"),
    },
});