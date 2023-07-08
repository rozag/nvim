local kbd = require("kbd")
local utils = require("utils")

local M = {}

M.ids = {
  treesitter = "nvim-treesitter/nvim-treesitter",
  treesitter_textobjects = "nvim-treesitter/nvim-treesitter-textobjects",
  treesitter_refactor = "nvim-treesitter/nvim-treesitter-refactor",
}

M.require_module = {
  treesitter_configs = function()
    return require("nvim-treesitter.configs")
  end,
}

local textobjects_move = { enable = true, set_jumps = true }
utils.table.insert_all(
  textobjects_move,
  kbd.plugins.treesitter.textobjects.move_keymaps
)

local textobjects_swap = { enable = true }
utils.table.insert_all(
  textobjects_swap,
  kbd.plugins.treesitter.textobjects.swap_keymaps
)

local ensure_grammars_installed = {
  "bash",
  "c",
  "clojure",
  "cmake",
  "commonlisp",
  "cpp",
  "css",
  "dart",
  "diff",
  "dockerfile",
  "elixir",
  "elm",
  "erlang",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "glsl",
  "graphql",
  "html",
  "htmldjango",
  "http",
  "ini",
  "java",
  "javascript",
  "jq",
  "jsdoc",
  "json",
  "json5",
  "jsonc",
  "kotlin",
  "latex",
  "make",
  "markdown",
  "ninja",
  "nix",
  "norg",
  "ocaml",
  "proto",
  "python",
  "racket",
  "regex",
  "ruby",
  "rust",
  "scala",
  "scheme",
  "scss",
  "smali",
  "solidity",
  "sql",
  "starlark",
  "swift",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "verilog",
  "vim",
  "vimdoc",
  "wgsl",
  "yaml",
  "zig",
}
utils.table.insert_all(
  ensure_grammars_installed,
  require("plugins.langs").treesitter_grammars
)

M.lazy_defs = {
  -- [[ tree-sitter ]]
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    M.ids.treesitter,
    dependencies = {
      M.ids.treesitter_textobjects,
      M.ids.treesitter_refactor,
    },
    build = ":TSUpdate",
    config = function()
      M.require_module.treesitter_configs().setup {
        ensure_installed = ensure_grammars_installed,
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = kbd.plugins.treesitter.incremental_selection_keymaps,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = kbd.plugins.treesitter.textobjects.selection_keymaps,
          },
          move = textobjects_move,
          swap = textobjects_swap,
        },
        refactor = {
          smart_rename = {
            enable = true,
            keymaps = kbd.plugins.treesitter.refactor_keymaps,
          },
        },
      }
    end,
  },
}

return M
