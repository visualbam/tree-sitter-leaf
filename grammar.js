
module.exports = grammar({
    name: 'leaf',

    extras: $ => [
        /\s/,
    ],

    rules: {
        template: $ => repeat(choice(
            $.doctype,
            $.html_comment,
            $.leaf_directive,
            $.leaf_variable,
            $.leaf_tag,
            $.html_element,
            $.html_self_closing_tag,
            $.text,
        )),

        // HTML Structure - FIXED: Proper void element handling
        html_element: $ => choice(
            // Void elements (no closing tag) - HIGHEST precedence
            prec(3, seq(
                '<',
                field('name', $.void_tag_name),
                repeat($.attribute),
                '>',
            )),
            // Regular elements (with closing tag) - HIGH precedence  
            prec(2, seq(
                $.start_tag,
                optional($.html_content),
                $.end_tag,
            )),
        ),

        html_self_closing_tag: $ => seq(
            '<',
            $.tag_name,
            repeat($.attribute),
            '/>',
        ),

        // Void tag names - tokenize to avoid conflicts
        void_tag_name: $ => token(choice(
            'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input',
            'link', 'meta', 'param', 'source', 'track', 'wbr'
        )),

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

        // Regular tag names - LOWER precedence than void tag names
        tag_name: $ => token(prec(-2, /[a-zA-Z][a-zA-Z0-9-]*/)),

        // FIXED: More robust attribute handling
        attribute: $ => choice(
            // Boolean attribute (no value)
            $.attribute_name,
            // Regular attribute with value
            seq(
                $.attribute_name,
                '=',
                choice(
                    $.quoted_attribute_value,
                    $.unquoted_attribute_value,
                    $.leaf_variable,
                    $.leaf_tag,
                    $.leaf_directive
                ),
            ),
        ),

        // Define leaf directives inside attribute values
        leaf_directive_in_attribute: $ => seq(
            optional($.attribute_value),
            $.leaf_directive,
            optional($.attribute_value)
        ),

        attribute_name: $ => /[a-zA-Z_:][a-zA-Z0-9_:.-]*/,

        // FIXED: Simplified and more robust quoted attribute value with higher precedence
        quoted_attribute_value: $ => prec(3, choice(
            seq('"', choice($.attribute_value, $.leaf_directive_in_attribute), '"'),
            seq("'", choice($.attribute_value, $.leaf_directive_in_attribute), "'"),
        )),

        unquoted_attribute_value: $ => /[^\s<>"'=`{}#]+/,

        // Attribute value should recognize text mixed with import directives
        attribute_value: $ => choice(
            // Plain text without directives (for compatibility with most tests)
            token(prec(-1, /[^"'#]*/)),
            // Text with #import directive inside - with higher precedence
            token(prec(10, /#import\([^)]*\)/)),
        ),

        // HTML content
        html_content: $ => repeat1(choice(
            $.leaf_directive,
            $.leaf_variable,
            $.leaf_tag,
            $.html_element,
            $.html_self_closing_tag,
            $.html_comment,
            $.text,
        )),

        // FIXED: More robust HTML comment handling with higher precedence
        html_comment: $ => token(prec(10, seq(
            '<!--',
            repeat(choice(
                /[^-]+/,
                /-[^-]/,
                /--[^>]/,
            )),
            '-->'
        ))),

        // Leaf Specific Rules - UPDATED: Clear distinction using colon
        leaf_directive: $ => choice(
            $.if_directive,
            $.unless_directive,
            $.for_directive,
            $.while_directive,
            $.extend_directive,
            $.simple_extend_directive,
            $.export_directive,
            $.simple_export_directive, // Keep this as a separate directive
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
        for_directive: $ => prec(1, seq(
            $.for_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
            $.end_for_directive,
        )),

        while_directive: $ => prec(1, seq(
            $.while_header,
            optional('{'),
            optional($.html_content),
            optional('}'),
            $.end_while_directive,
        )),

        // UPDATED: Block extend (with colon and content)
        extend_directive: $ => seq(
            $.extend_header_with_colon,
            optional($.html_content),
            $.end_extend_directive,
        ),

        // UPDATED: Simple extend (no colon, no content)
        simple_extend_directive: $ => $.extend_header,

        // Export directive - supports both block and simple forms
        export_directive: $ => choice(
            // Block form: #export("key"): content #endexport
            prec(2, seq(
                $.export_header_block,
                optional($.html_content),
                $.end_export_directive,
            )),
            // Legacy format without colon for compatibility with tests
            prec(1, seq(
                $.export_header,
                optional($.html_content),
                $.end_export_directive,
            )),
        ),

        // Simple export with key and value parameters
        simple_export_directive: $ => seq(
            '#export',
            '(',
            $.string_literal,
            ',',
            $.expression,
            ')',
        ),

        // Export header without colon (legacy format for test compatibility)
        export_header: $ => prec(1, seq(
            '#export',
            '(',
            $.string_literal,
            ')',
        )),

        import_directive: $ => $.import_header,

        evaluate_directive: $ => $.evaluate_header,

        // Directive Headers - UPDATED: Separate headers with and without colon
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

        // UPDATED: Header without colon for simple extend
        extend_header: $ => seq(
            '#extend',
            '(',
            $.string_literal,
            ')',
        ),

        // NEW: Header with colon for block extend
        extend_header_with_colon: $ => seq(
            '#extend',
            '(',
            $.string_literal,
            ')',
            ':',
        ),

        // Block export header (with colon)
        export_header_block: $ => prec(2, seq(
            '#export',
            '(',
            $.string_literal,
            ')',
            optional(':'),
        )),

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

        // Leaf Variables - UPDATED to handle simple identifiers specially
        leaf_variable: $ => seq(
            '#(',
            choice(
                $.simple_variable,
                $.expression,
            ),
            ')',
        ),

        // NEW: Simple variable rule for standalone identifiers
        simple_variable: $ => prec(2, $.identifier),

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
            prec.left(8, seq($.expression, '<=', $.expression)),
            prec.left(8, seq($.expression, '>', $.expression)),
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

        argument_list: $ => seq(
            $.expression,
            repeat(seq(',', $.expression)),
            optional(','),
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

        // FIXED: Text should not capture sequences that contain only whitespace
        // Lower precedence to ensure other tokens take priority
        text: $ => token(prec(-2, /[^\s<#][^<#]*/)),

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