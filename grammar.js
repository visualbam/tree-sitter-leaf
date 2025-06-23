const PREC = {
    COMMENT: 1,
    STRING: 2,
    ATTRIBUTE: 3,
    TAG: 4,
    DIRECTIVE: 5,
    INTERPOLATION: 6,
};

module.exports = grammar({
    name: 'html',

    extras: $ => [
        /\s+/,
        $.comment,
    ],

    rules: {
        document: $ => repeat($._node),

        _node: $ => choice(
            $.element,
            $.self_closing_tag,
            $.text,
            $.comment,
            $.doctype,
            $.leaf_interpolation,
            $.leaf_directive,
            $.erroneous_end_tag,
        ),

        doctype: $ => seq(
            '<!',
            alias(/[Dd][Oo][Cc][Tt][Yy][Pp][Ee]/, 'doctype'),
            /[^>]+/,
            '>',
        ),

        element: $ => choice(
            seq(
                $.start_tag,
                repeat($._node),
                choice($.end_tag, $._implicit_end_tag),
            ),
            $.script_element,
            $.style_element,
        ),

        script_element: $ => seq(
            alias($.script_start_tag, $.start_tag),
            optional(alias($.raw_text, $.text)),
            $.end_tag,
        ),

        style_element: $ => seq(
            alias($.style_start_tag, $.start_tag),
            optional(alias($.raw_text, $.text)),
            $.end_tag,
        ),

        start_tag: $ => seq(
            '<',
            alias($.tag_name, $.tag_name),
            repeat(choice($.attribute, $.leaf_attribute)),
            '>',
        ),

        script_start_tag: $ => seq(
            '<',
            alias(
                choice('script', 'SCRIPT'),
                $.tag_name,
            ),
            repeat(choice($.attribute, $.leaf_attribute)),
            '>',
        ),

        style_start_tag: $ => seq(
            '<',
            alias(
                choice('style', 'STYLE'),
                $.tag_name,
            ),
            repeat(choice($.attribute, $.leaf_attribute)),
            '>',
        ),

        self_closing_tag: $ => seq(
            '<',
            alias($.tag_name, $.tag_name),
            repeat(choice($.attribute, $.leaf_attribute)),
            '/>',
        ),

        end_tag: $ => prec(1, seq(
            '</',
            alias($.tag_name, $.tag_name),
            '>',
        )),

        erroneous_end_tag: $ => seq(
            '</',
            $.erroneous_end_tag_name,
            '>',
        ),

        attribute: $ => seq(
            $.attribute_name,
            optional(seq(
                '=',
                choice(
                    $.attribute_value,
                    $.quoted_attribute_value,
                    $.leaf_interpolation,
                ),
            )),
        ),

        // Leaf-specific attributes (e.g., #if, #for, etc.)
        leaf_attribute: $ => choice(
            $.leaf_conditional_attribute,
            $.leaf_loop_attribute,
            $.leaf_import_attribute,
            $.leaf_extend_attribute,
            $.leaf_export_attribute,
            $.leaf_inline_attribute,
            $.leaf_raw_attribute,
            $.leaf_unsaferaw_attribute,
            $.leaf_custom_attribute,
        ),

        leaf_conditional_attribute: $ => seq(
            choice('#if', '#elseif', '#unless'),
            '(',
            field('condition', $.leaf_expression),
            ')',
        ),

        leaf_loop_attribute: $ => seq(
            choice('#for', '#forEach'),
            '(',
            field('variable', $.identifier),
            'in',
            field('collection', $.leaf_expression),
            ')',
        ),

        leaf_import_attribute: $ => seq(
            '#import',
            '(',
            field('template', $.quoted_string),
            ')',
        ),

        leaf_extend_attribute: $ => seq(
            '#extend',
            '(',
            field('template', $.quoted_string),
            ')',
        ),

        leaf_export_attribute: $ => seq(
            '#export',
            '(',
            field('name', $.quoted_string),
            ')',
        ),

        leaf_inline_attribute: $ => seq(
            '#inline',
            '(',
            field('template', $.quoted_string),
            optional(seq(',', field('context', $.leaf_expression))),
            ')',
        ),

        leaf_raw_attribute: $ => seq(
            '#raw',
            '(',
            field('content', $.leaf_expression),
            ')',
        ),

        leaf_unsaferaw_attribute: $ => seq(
            '#unsafeRaw',
            '(',
            field('content', $.leaf_expression),
            ')',
        ),

        leaf_custom_attribute: $ => seq(
            field('name', seq('#', $.identifier)),
            optional(seq(
                '(',
                optional(commaSep($.leaf_expression)),
                ')',
            )),
        ),

        // Leaf directives (standalone)
        leaf_directive: $ => choice(
            $.leaf_if_directive,
            $.leaf_else_directive,
            $.leaf_elseif_directive,
            $.leaf_endif_directive,
            $.leaf_for_directive,
            $.leaf_endfor_directive,
            $.leaf_set_directive,
            $.leaf_define_directive,
            $.leaf_evaluate_directive,
        ),

        leaf_if_directive: $ => seq(
            '#if(',
            field('condition', $.leaf_expression),
            ')',
            ':',
        ),

        leaf_else_directive: $ => '#else:',

        leaf_elseif_directive: $ => seq(
            '#elseif(',
            field('condition', $.leaf_expression),
            ')',
            ':',
        ),

        leaf_endif_directive: $ => '#endif',

        leaf_for_directive: $ => seq(
            '#for(',
            field('variable', $.identifier),
            'in',
            field('collection', $.leaf_expression),
            ')',
            ':',
        ),

        leaf_endfor_directive: $ => '#endfor',

        leaf_set_directive: $ => seq(
            '#set(',
            field('variable', $.identifier),
            '=',
            field('value', $.leaf_expression),
            ')',
        ),

        leaf_define_directive: $ => seq(
            '#define(',
            field('name', $.identifier),
            ')',
            ':',
            repeat($._node),
            '#enddefine',
        ),

        leaf_evaluate_directive: $ => seq(
            '#evaluate(',
            field('expression', $.leaf_expression),
            ')',
        ),

        // Leaf interpolation
        leaf_interpolation: $ => choice(
            prec(PREC.INTERPOLATION, seq(
                '#(',
                field('expression', $.leaf_expression),
                ')',
            )),
            prec(PREC.INTERPOLATION, seq(
                '#{',
                field('expression', $.leaf_expression),
                '}',
            )),
        ),

        // Leaf expressions
        leaf_expression: $ => choice(
            $.identifier,
            $.string_literal,
            $.number_literal,
            $.boolean_literal,
            $.leaf_member_access,
            $.leaf_function_call,
            $.leaf_array_access,
            $.leaf_binary_expression,
            $.leaf_unary_expression,
            $.leaf_ternary_expression,
            $.leaf_parenthesized_expression,
        ),

        leaf_member_access: $ => prec.left(seq(
            field('object', $.leaf_expression),
            '.',
            field('property', $.identifier),
        )),

        leaf_array_access: $ => prec.left(seq(
            field('array', $.leaf_expression),
            '[',
            field('index', $.leaf_expression),
            ']',
        )),

        leaf_function_call: $ => prec.left(seq(
            field('function', $.leaf_expression),
            '(',
            optional(commaSep($.leaf_expression)),
            ')',
        )),

        leaf_binary_expression: $ => choice(
            prec.left(1, seq(
                field('left', $.leaf_expression),
                field('operator', choice('+', '-', '*', '/', '%')),
                field('right', $.leaf_expression),
            )),
            prec.left(2, seq(
                field('left', $.leaf_expression),
                field('operator', choice('==', '!=', '<', '>', '<=', '>=')),
                field('right', $.leaf_expression),
            )),
            prec.left(3, seq(
                field('left', $.leaf_expression),
                field('operator', choice('&&', '||')),
                field('right', $.leaf_expression),
            )),
        ),

        leaf_unary_expression: $ => prec.right(seq(
            field('operator', choice('!', '-', '+')),
            field('operand', $.leaf_expression),
        )),

        leaf_ternary_expression: $ => prec.right(seq(
            field('condition', $.leaf_expression),
            '?',
            field('consequent', $.leaf_expression),
            ':',
            field('alternate', $.leaf_expression),
        )),

        leaf_parenthesized_expression: $ => seq(
            '(',
            $.leaf_expression,
            ')',
        ),

        quoted_attribute_value: $ => choice(
            seq('"', optional(alias(repeat(choice(/[^"]+/, $.leaf_interpolation)), $.attribute_value)), '"'),
            seq("'", optional(alias(repeat(choice(/[^']+/, $.leaf_interpolation)), $.attribute_value)), "'"),
        ),

        attribute_value: $ => /[^<>"'=\s]+/,

        text: $ => prec(-1, /[^<#]+/),

        raw_text: $ => /[^<]+/,

        comment: $ => seq('<!--', /[^>]*/, '-->'),

        tag_name: $ => prec(1, /[a-zA-Z][a-zA-Z0-9\-]*/),

        attribute_name: $ => /[a-zA-Z_:][\w:.-]*/,

        erroneous_end_tag_name: $ => /[a-zA-Z_:][\w:.-]*/,

        identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

        string_literal: $ => choice(
            seq('"', repeat(choice(/[^"\\]+/, /\\./)), '"'),
            seq("'", repeat(choice(/[^'\\]+/, /\\./)), "'"),
        ),

        quoted_string: $ => choice(
            seq('"', repeat(choice(/[^"\\]+/, /\\./)), '"'),
            seq("'", repeat(choice(/[^'\\]+/, /\\./)), "'"),
        ),

        number_literal: $ => /\d+(?:\.\d+)?/,

        boolean_literal: $ => choice('true', 'false'),

        _implicit_end_tag: $ => seq('</', $.tag_name, '>'),
    },
});

function commaSep(rule) {
    return optional(commaSep1(rule));
}

function commaSep1(rule) {
    return seq(rule, repeat(seq(',', rule)));
}