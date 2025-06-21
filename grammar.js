module.exports = grammar({
  name: "leaf",

  extras: ($) => [/\s/, $.comment],

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
        ),
      ),

    // Block directives with explicit end tags
    extend_directive: ($) =>
      seq(
        "#extend(",
        $.string_literal,
        "):",
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
        "#endextend",
      ),

    export_directive: ($) =>
      seq(
        "#export(",
        $.string_literal,
        "):",
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
        "#endexport",
      ),

    if_directive: ($) =>
      seq(
        "#if(",
        $.expression,
        "):",
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
        "#endif",
      ),

    unless_directive: ($) =>
      seq(
        "#unless(",
        $.expression,
        "):",
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
        "#endunless",
      ),

    for_directive: ($) =>
      seq(
        "#for(",
        $.identifier,
        "in",
        $.expression,
        "):",
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
        "#endfor",
      ),

    while_directive: ($) =>
      seq(
        "#while(",
        $.expression,
        "):",
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
        "#endwhile",
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

    // HTML elements
    html_element: ($) => seq($.start_tag, optional($.html_content), $.end_tag),

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

    html_comment: ($) => seq("<!--", /[^>]*(-[^>]+)*?/, "-->"),

    // Literals
    string_literal: ($) =>
      choice(
        seq('"', repeat(choice(/[^"\\]+/, /\\./)), '"'),
        seq("'", repeat(choice(/[^'\\]+/, /\\./)), "'"),
      ),

    number_literal: ($) => choice(/\d+\.\d+/, /\d+/),

    boolean_literal: ($) => choice("true", "false"),

    identifier: ($) => /[a-zA-Z_][a-zA-Z0-9_]*/,

    // More restrictive text rule - only capture significant text content
    text: ($) => /[^#<\s]+([^#<]*[^#<\s]+)*/,

    comment: ($) => seq("#*", /[^*]*\*+([^#*][^*]*\*+)*/, "#"),
  },
});
