
module.exports = grammar({
    name: 'leaf',

    extras: $ => [
        /\s/,
        $.comment,
    ],

    rules: {
        template: $ => repeat(choice(
            $.doctype,
            $.html_comment,
            $.leaf_comment,
            $.leaf_directive,
            $.leaf_variable,
            $.html_element,
            $.html_self_closing_tag,
            $.text,
        )),

        // HTML Structure
        html_element: $ => seq(
            $.start_tag,
            optional($.html_content),
            $.end_tag,
        ),

        html_self_closing_tag: $ => seq(
            '<',
            $.tag_name,
            repeat($.attribute),
            '/>',
        ),

        start_tag: $ => seq(
            '<',
            $.tag_name,
            repeat($.attribute),
            '>',
        ),

        end_tag: $ => seq(
            '</',
            $.tag_name,
            '>',
        ),

        tag_name: $ => /[a-zA-Z][a-zA-Z0-9-]*/,

        attribute: $ => seq(
            $.attribute_name,
            optional(seq(
                '=',
                choice(
                    $.quoted_attribute_value,
                    $.unquoted_attribute_value,
                    $.leaf_variable,
                ),
            )),
        ),

        attribute_name: $ => /[a-zA-Z_:][a-zA-Z0-9_:.-]*/,

        quoted_attribute_value: $ => choice(
            seq('"', optional($.attribute_value), '"'),
            seq("'", optional($.attribute_value), "'"),
        ),

        unquoted_attribute_value: $ => /[^\s<>"'=`{}#]+/,

        attribute_value: $ => repeat1(choice(
            /[^"'<>&{}#]+/,
            $.leaf_variable,
            $.html_entity,
        )),

        html_entity: $ => /&[a-zA-Z0-9]+;/,

        html_content: $ => repeat1(choice(
            $.leaf_directive,
            $.leaf_variable,
            $.html_element,
            $.html_self_closing_tag,
            $.html_comment,
            $.text,
        )),

        html_comment: $ => seq('<!--', /[^>]*/, '-->'),

        // Leaf Specific Rules
        leaf_directive: $ => choice(
            $.if_directive,
            $.unless_directive,
            $.for_directive,
            $.while_directive,
            $.extend_directive,
            $.export_directive,
            $.import_directive,
            $.evaluate_directive,
        ),

        // Conditional Directives
        if_directive: $ => prec(1, seq(
            $.if_header,
            optional($.html_content),
            repeat(seq(
                $.elseif_header,
                optional($.html_content),
            )),
            optional(seq(
                $.else_directive,
                optional($.html_content),
            )),
            $.end_if_directive,
        )),

        unless_directive: $ => prec(1, seq(
            $.unless_header,
            optional($.html_content),
            optional(seq(
                $.else_directive,
                optional($.html_content),
            )),
            $.end_unless_directive,
        )),

        // Loop Directives
        for_directive: $ => seq(
            $.for_header,
            optional($.html_content),
            $.end_for_directive,
        ),

        while_directive: $ => seq(
            $.while_header,
            optional($.html_content),
            $.end_while_directive,
        ),

        // Template Directives
        extend_directive: $ => seq(
            $.extend_header,
            optional($.html_content),
            $.end_extend_directive,
        ),

        export_directive: $ => seq(
            $.export_header,
            optional($.html_content),
            $.end_export_directive,
        ),

        import_directive: $ => $.import_header,

        evaluate_directive: $ => $.evaluate_header,

        // Directive Headers
        if_header: $ => seq(
            '#if',
            '(',
            $.expression,
            ')',
        ),

        elseif_header: $ => seq(
            '#elseif',
            '(',
            $.expression,
            ')',
        ),

        else_directive: $ => '#else',

        unless_header: $ => seq(
            '#unless',
            '(',
            $.expression,
            ')',
        ),

        for_header: $ => seq(
            '#for',
            '(',
            $.identifier,
            'in',
            $.expression,
            ')',
        ),

        while_header: $ => seq(
            '#while',
            '(',
            $.expression,
            ')',
        ),

        extend_header: $ => seq(
            '#extend',
            '(',
            $.string_literal,
            ')',
        ),

        export_header: $ => seq(
            '#export',
            '(',
            $.string_literal,
            ')',
        ),

        import_header: $ => seq(
            '#import',
            '(',
            $.string_literal,
            ')',
        ),

        evaluate_header: $ => seq(
            '#evaluate',
            '(',
            $.expression,
            ')',
        ),

        // End Directives
        end_if_directive: $ => '#endif',
        end_unless_directive: $ => '#endunless',
        end_for_directive: $ => '#endfor',
        end_while_directive: $ => '#endwhile',
        end_extend_directive: $ => '#endextend',
        end_export_directive: $ => '#endexport',

        // Leaf Variables
        leaf_variable: $ => seq(
            '#(',
            $.expression,
            ')',
        ),

        // Expressions
        expression: $ => choice(
            $.binary_expression,
            $.unary_expression,
            $.ternary_expression,
            $.function_call,
            $.member_access,
            $.array_access,
            $.parenthesized_expression,
            $.primary_expression,
        ),

        primary_expression: $ => choice(
            $.identifier,
            $.string_literal,
            $.number_literal,
            $.boolean_literal,
            $.null_literal,
            $.array_literal,
            $.dictionary_literal,
        ),

        binary_expression: $ => choice(
            prec.left(10, seq($.expression, '*', $.expression)),
            prec.left(10, seq($.expression, '/', $.expression)),
            prec.left(10, seq($.expression, '%', $.expression)),
            prec.left(9, seq($.expression, '+', $.expression)),
            prec.left(9, seq($.expression, '-', $.expression)),
            prec.left(8, seq($.expression, '<', $.expression)),
            prec.left(8, seq($.expression, '>', $.expression)),
            prec.left(8, seq($.expression, '<=', $.expression)),
            prec.left(8, seq($.expression, '>=', $.expression)),
            prec.left(7, seq($.expression, '==', $.expression)),
            prec.left(7, seq($.expression, '!=', $.expression)),
            prec.left(6, seq($.expression, choice('&&', 'and'), $.expression)),
            prec.left(5, seq($.expression, choice('||', 'or'), $.expression)),
            prec.left(4, seq($.expression, '??', $.expression)),
        ),

        unary_expression: $ => choice(
            prec(11, seq('!', $.expression)),
            prec(11, seq('not', $.expression)),
            prec(11, seq('-', $.expression)),
            prec(11, seq('+', $.expression)),
        ),

        ternary_expression: $ => prec.right(3, seq(
            $.expression,
            '?',
            $.expression,
            ':',
            $.expression,
        )),

        function_call: $ => seq(
            $.identifier,
            '(',
            optional($.argument_list),
            ')',
        ),

        argument_list: $ => seq(
            $.expression,
            repeat(seq(',', $.expression)),
            optional(','),
        ),

        member_access: $ => seq(
            $.expression,
            '.',
            $.identifier,
        ),

        array_access: $ => seq(
            $.expression,
            '[',
            $.expression,
            ']',
        ),

        parenthesized_expression: $ => seq(
            '(',
            $.expression,
            ')',
        ),

        // Literals
        identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

        string_literal: $ => choice(
            seq('"', repeat(choice(/[^"\\]/, /\\./)), '"'),
            seq("'", repeat(choice(/[^'\\]/, /\\./)), "'"),
        ),

        number_literal: $ => choice(
            /\d+\.\d+/,
            /\d+/,
        ),

        boolean_literal: $ => choice('true', 'false'),

        null_literal: $ => 'nil',

        array_literal: $ => seq(
            '[',
            optional(seq(
                $.expression,
                repeat(seq(',', $.expression)),
                optional(','),
            )),
            ']',
        ),

        // Dictionary literals use curly braces to avoid conflict with arrays
        dictionary_literal: $ => seq(
            '{',
            optional(seq(
                $.dictionary_pair,
                repeat(seq(',', $.dictionary_pair)),
                optional(','),
            )),
            '}',
        ),

        dictionary_pair: $ => seq(
            choice($.string_literal, $.identifier),
            ':',
            $.expression,
        ),

        // Comments
        leaf_comment: $ => seq('///', /[^\r\n]*/),
        comment: $ => seq('//', /[^\r\n]*/),

        // Text content - back to original
        text: $ => token(prec(-1, /[^<#\s][^<#]*/)),

        // DOCTYPE
        doctype: $ => seq(
            '<',
            token(prec(1, '!')),
            /[Dd][Oo][Cc][Tt][Yy][Pp][Ee]/,
            /[^>]+/,
            '>',
        ),
    },
});