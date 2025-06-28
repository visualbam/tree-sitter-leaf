# tree-sitter-leaf

A [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for the [Leaf templating language](https://docs.vapor.codes/leaf/overview/) used in Vapor (Swift).

## Features

- Full support for Leaf directives (`#extend`, `#export`, `#import`, `#if`, `#unless`, `#for`, `#while`)
- Leaf variables with expression support (`#(variable)`, `#(user.name)`, `#(count + 1)`)
- HTML parsing with proper nesting
- String interpolation and complex expressions
- Syntax highlighting, indentation, and language injections
- Comment support for Leaf (`///`), regular (`//`), and HTML (`<!-- -->`) comments

## Installation

### Neovim with nvim-treesitter

Add this to your Neovim configuration:

```lua
{
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    -- Custom leaf parser
    local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
    parser_config.leaf = {
      install_info = {
        url = 'https://github.com/visualbam/tree-sitter-leaf',
        files = { 'src/parser.c' },
        branch = 'master',
      },
      filetype = 'leaf',
    }

    -- Simple filetype detection for grep preview
    vim.filetype.add({ extension = { leaf = 'leaf' } })
    vim.treesitter.language.register('leaf', 'leaf')

    -- Configure comment strings for gcc motion
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "leaf",
      callback = function()
        vim.bo.commentstring = "/// %s"
      end,
    })

    -- Standard setup
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'query', 'vim', 'vimdoc', 'typescript', 'javascript', 'json', 'css', 'scss',
        'yaml', 'java', 'c_sharp', 'leaf',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
  end,
}
```
