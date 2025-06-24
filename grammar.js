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
            $.leaf_tag,
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
                    $.leaf_tag,
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
            $.leaf_tag,
            $.html_entity,
        )),

        html_entity: $ => /&[a-zA-Z0-9]+;/,

        html_content: $ => repeat1(choice(
            $.leaf_directive,
            $.leaf_variable,
            $.leaf_tag,
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

        // Leaf tags (functions that can be used inline)
        leaf_tag: $ => choice(
            $.count_tag,
            $.lowercased_tag,
            $.uppercased_tag,
            $.capitalized_tag,
            $.contains_tag,
            $.date_tag,
            $.unsafe_html_tag,
            $.dump_context_tag,
        ),

        count_tag: $ => seq(
            '#count',
            '(',
            $.expression,
            ')',
        ),

        lowercased_tag: $ => seq(
            '#lowercased',
            '(',
            $.expression,
            ')',
        ),

        uppercased_tag: $ => seq(
            '#uppercased',
            '(',
            $.expression,
            ')',
        ),

        capitalized_tag: $ => seq(
            '#capitalized',
            '(',
            $.expression,
            ')',
        ),

        contains_tag: $ => seq(
            '#contains',
            '(',
            $.expression,
            ',',
            $.expression,
            ')',
        ),

        date_tag: $ => seq(
            '#date',
            '(',
            $.expression,
            optional(seq(',', $.expression)),
            optional(seq(',', $.expression)),
            ')',
        ),

        unsafe_html_tag: $ => seq(
            '#unsafeHTML',
            '(',
            $.expression,
            ')',
        ),

        dump_context_tag: $ => '#dumpContext',

        // Conditional Directives
        if_directive: $ => prec(1, seq(
            $.if_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
            repeat(seq(
                $.elseif_header,
                optional('{'),
                optional($.html_content),
                optional('}'),
            )),
            optional(seq(
                $.else_directive,
                optional('{'),
                optional($.html_content),
                optional('}'),
            )),
            $.end_if_directive,
        )),

        unless_directive: $ => prec(1, seq(
            $.unless_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
            optional(seq(
                $.else_directive,
                optional('{'),
                optional($.html_content),
                optional('}'),
            )),
            $.end_unless_directive,
        )),

        // Loop Directives
        for_directive: $ => seq(
            $.for_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
            $.end_for_directive,
        ),

        while_directive: $ => seq(
            $.while_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
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

        // Directive Headers - Updated with colon support
        if_header: $ => seq(
            '#if',
            '(',
            $.expression,
            ')',
            optional(':'),
        ),

        elseif_header: $ => seq(
            '#elseif',
            '(',
            $.expression,
            ')',
            optional(':'),
        ),

        else_directive: $ => choice('#else', '#else:'),

        unless_header: $ => seq(
            '#unless',
            '(',
            $.expression,
            ')',
            optional(':'),
        ),

        for_header: $ => seq(
            '#for',
            '(',
            $.identifier,
            'in',
            $.expression,
            ')',
            optional(':'),
        ),

        while_header: $ => seq(
            '#while',
            '(',
            $.expression,
            ')',
            optional(':'),
        ),

        extend_header: $ => seq(
            '#extend',
            '(',
            $.string_literal,
            ')',
            optional(':'),
        ),

        export_header: $ => seq(
            '#export',
            '(',
            $.string_literal,
            ')',
            optional(':'),
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

        // Expression system with proper precedence
        expression: $ => choice(
            $.ternary_expression,
            $.binary_expression,
            $.unary_expression,
            $.postfix_expression,
        ),

        // Postfix expressions handle member access, function calls, and array access
        postfix_expression: $ => prec.left(12, choice(
            $.primary_expression,
            $.member_expression,
            $.call_expression,
            $.subscript_expression,
        )),

        // Member expressions (property access)
        member_expression: $ => prec.left(12, seq(
            $.postfix_expression,
            '.',
            $.identifier,
        )),

        // Call expressions (function/method calls)
        call_expression: $ => prec.left(12, seq(
            $.postfix_expression,
            '(',
            optional($.argument_list),
            ')',
        )),

        // Subscript expressions (array access)
        subscript_expression: $ => prec.left(12, seq(
            $.postfix_expression,
            '[',
            $.expression,
            ']',
        )),

        // Primary expressions - Updated to include tag function calls
        primary_expression: $ => choice(
            $.identifier,
            $.string_literal,
            $.number_literal,
            $.boolean_literal,
            $.null_literal,
            $.array_literal,
            $.dictionary_literal,
            $.parenthesized_expression,
            $.tag_function_call,
        ),

        // NEW: Tag functions used in expressions (without #)
        tag_function_call: $ => choice(
            seq('count', '(', $.expression, ')'),
            seq('lowercased', '(', $.expression, ')'),
            seq('uppercased', '(', $.expression, ')'),
            seq('capitalized', '(', $.expression, ')'),
            seq('contains', '(', $.expression, ',', $.expression, ')'),
            seq('date', '(', $.expression, optional(seq(',', $.expression)), optional(seq(',', $.expression)), ')'),
            seq('unsafeHTML', '(', $.expression, ')'),
        ),

        parenthesized_expression: $ => seq(
            '(',
            $.expression,
            ')',
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

        // DEPRECATED: Keep for backward compatibility but remove from main expression choice
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

        // DEPRECATED: Keep for backward compatibility but remove from main expression choice
        member_access: $ => seq(
            $.expression,
            '.',
            $.identifier,
        ),

        // DEPRECATED: Keep for backward compatibility but remove from main expression choice
        array_access: $ => seq(
            $.expression,
            '[',
            $.expression,
            ']',
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

        // Text content
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