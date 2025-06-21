# tree-sitter-leaf

A [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for the [Leaf templating language](https://docs.vapor.codes/leaf/overview/) used in Vapor (Swift).

## Features

- Full support for Leaf directives (`#extend`, `#export`, `#import`, `#if`, `#unless`, `#for`, `#while`, `#evaluate`)
- Leaf variables with expression support (`#(variable)`, `#(user.name)`, `#(count + 1)`)
- HTML parsing with proper nesting
- String interpolation and complex expressions
- Syntax highlighting, indentation, and language injections

## Installation

### Neovim with nvim-treesitter

Add this to your Neovim configuration:

```lua
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.leaf = {
  install_info = {
    url = "https://github.com/yourusername/tree-sitter-leaf",
    files = {"src/parser.c"},
    branch = "main",
  },
  filetype = "leaf",
}

-- File type detection
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.leaf",
  callback = function()
    vim.bo.filetype = "leaf"
  end,
})
```
