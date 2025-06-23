module.exports = grammar({
    name: 'leaf',

    extras: $ => [
        /\s+/, // Allow whitespace
    ],

    // Top-level entry point for parsing
    rules: {
        document: $ => repeat($._content),

        // Define the base content
        _content: $ => choice(
            $.element,
            $.self_closing_tag,
            $.comment,
            $.leaf_comment,
            $.leaf_if_directive,
            $.leaf_for_directive,
            $.leaf_interpolation,
            $.doctype,
            $.text,
        ),

        comment: $ => seq('<!--', /([^-]|-[^-]|--[^>])*/, '-->'),
        leaf_comment: $ => seq('//', /[^\n]*/),

        text: $ => token(prec(-1, /[^<#\s][^<#]*/)),

        doctype: $ => seq('<!', alias(/[Dd][Oo][Cc][Tt][Yy][Pp][Ee]/, 'doctype'), /[^>]+/, '>'),

        // Define HTML-like elements
        element: $ => seq(
            $.start_tag,
            repeat($._content),
            $.end_tag,
        ),

        start_tag: $ => seq(
            '<',
            field('tag_name', $.tag_name),
            repeat(choice($.attribute, $.leaf_conditional_attribute, $.leaf_loop_attribute)),
            '>',
        ),

        self_closing_tag: $ => seq(
            '<',
            field('tag_name', $.tag_name),
            repeat(choice($.attribute, $.leaf_conditional_attribute, $.leaf_loop_attribute)),
            '/>',
        ),

        end_tag: $ => seq('</', field('tag_name', $.tag_name), '>'),

        // Leaf-specific nodes
        leaf_if_directive: $ => seq(
            '#if(',
            field('condition', $.leaf_expression),
            '):',
            repeat($._content),
            optional(seq(
                $.leaf_else_directive,
                repeat($._content),
            )),
            $.leaf_endif_directive,
        ),

        leaf_else_directive: $ => '#else:',
        leaf_endif_directive: $ => '#endif',

        leaf_for_directive: $ => seq(
            choice('#for', '#forEach'),
            '(',
            field('variable', $.identifier),
            'in',
            field('collection', $.leaf_expression),
            '):',
            repeat($._content),
            $.leaf_endfor_directive,
        ),

        leaf_endfor_directive: $ => choice('#endfor', '#endforeach'),

        leaf_interpolation: $ => seq(
            '#(',
            field('expression', $.leaf_expression),
            ')',
        ),

        leaf_conditional_attribute: $ => seq(
            choice('#if', '#elseif', '#unless'),
            '(',
            field('condition', $.leaf_expression),
            '):',
            field('attribute', $.attribute),
            optional($.leaf_endif_directive),
        ),

        leaf_loop_attribute: $ => seq(
            choice('#for', '#forEach'),
            '(',
            field('variable', $.identifier),
            'in',
            field('collection', $.leaf_expression),
            '):',
            field('attribute', $.attribute),
        ),

        attribute: $ => seq(
            field('name', $.attribute_name),
            optional(seq(
                '=',
                choice(
                    field('value', $.quoted_attribute_value),
                    field('value', $.leaf_interpolation),
                ),
            )),
        ),

        quoted_attribute_value: $ => choice(
            seq('"', optional($.attribute_value), '"'),
            seq("'", optional($.attribute_value), "'"),
        ),

        attribute_value: $ => token(prec(1, /[^"'<>]+/)),

        // Leaf expression (declared before usage to avoid ordering problems)
        leaf_expression: $ => choice(
            $.identifier,
            $.leaf_member_access,
            $.leaf_function_call,
            $.leaf_array_access,
            $.leaf_binary_expression,
            $.leaf_unary_expression,
            $.leaf_ternary_expression,
            $.leaf_parenthesized_expression,
            $.string_literal,
            $.number_literal,
            $.boolean_literal,
        ),

        // Member access like `object.member`
        leaf_member_access: $ => prec.left(10, seq($.identifier, '.', $.identifier)),

        // Function calls
        leaf_function_call: $ => seq(
            $.identifier,
            '(',
            optional($.argument_list),
            ')',
        ),

        argument_list: $ => seq($.leaf_expression, repeat(seq(',', $.leaf_expression))),

        // Array access (e.g., `array[expr]`)
        leaf_array_access: $ => seq($.identifier, '[', $.leaf_expression, ']'),

        // Binary operators like +, -, *, etc.
        leaf_binary_expression: $ => prec.left(1, seq(
            $.leaf_expression,
            choice('+', '-', '*', '/', '%', '==', '!=', '<', '>', '<=', '>=', '&&', '||'),
            $.leaf_expression,
        )),

        // Unary operators like `!`, `-expr`
        leaf_unary_expression: $ => prec(2, seq(choice('!', '-', '+'), $.leaf_expression)),

        // Ternary operators (`a ? b : c`)
        leaf_ternary_expression: $ => prec.right(0, seq(
            $.leaf_expression,
            '?',
            $.leaf_expression,
            ':',
            $.leaf_expression,
        )),

        // Expressions in parentheses
        leaf_parenthesized_expression: $ => seq('(', $.leaf_expression, ')'),

        // Leaves of expressions
        identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,
        string_literal: $ => choice(
            seq('"', repeat(choice(/[^"\\]/, /\\./)), '"'),
            seq("'", repeat(choice(/[^'\\]/, /\\./)), "'"),
        ),
        number_literal: $ => /\d+(\.\d+)?/,
        boolean_literal: $ => choice('true', 'false'),

        // Other definitions
        tag_name: $ => /[a-zA-Z][a-zA-Z0-9\-]*/,
        attribute_name: $ => /[a-zA-Z_:][a-zA-Z0-9_:.-]*/,
    },
});