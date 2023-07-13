-- NOTE: using N+1 for fill col indicator to be an "untouchable" visual border

local utils = require("utils")

local langs = {
  dart = {
    treesitter_grammars = { "dart" },
    fill_col_indicator = { type = "dart", limit = "81" },
    mason_lspconfig_ensure_installed = {},
  },

  dockerfile = {
    treesitter_grammars = { "dockerfile" },
    fill_col_indicator = { type = "dockerfile", limit = "81" },
    mason_lspconfig_ensure_installed = {},
  },

  go = {
    treesitter_grammars = {
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
    fill_col_indicator = { type = "go", limit = "81" },
    mason_lspconfig_ensure_installed = {
      "gopls", -- gopls
    },
  },

  java = {
    treesitter_grammars = { "java" },
    fill_col_indicator = { type = "java", limit = "141" },
    mason_lspconfig_ensure_installed = {},
  },

  kotlin = {
    treesitter_grammars = { "kotlin" },
    fill_col_indicator = { type = "kotlin", limit = "141" },
    mason_lspconfig_ensure_installed = {},
  },

  lua = {
    treesitter_grammars = {
      "lua",
      "luadoc",
      "luap",
      "luau",
    },
    fill_col_indicator = { type = "lua", limit = "81" },
    mason_lspconfig_ensure_installed = {
      "lua_ls", -- lua-language-server
    },
  },

  markdown = {
    treesitter_grammars = { "markdown" },
    fill_col_indicator = { type = "markdown", limit = "81" },
    mason_lspconfig_ensure_installed = {},
  },

  org = {
    treesitter_grammars = {},
    fill_col_indicator = { type = "org", limit = "81" },
    mason_lspconfig_ensure_installed = {},
  },

  python = {
    treesitter_grammars = { "python", "starlark" },
    fill_col_indicator = { type = "python", limit = "81" },
    mason_lspconfig_ensure_installed = {
      -- "pyright", -- pyright
    },
  },

  rust = {
    treesitter_grammars = { "rust", "toml" },
    fill_col_indicator = { type = "rust", limit = "100" },
    mason_lspconfig_ensure_installed = {
      -- "rust_analyzer", -- rust-analyzer
    },
  },

  text = {
    treesitter_grammars = {},
    fill_col_indicator = { type = "text", limit = "81" },
    mason_lspconfig_ensure_installed = {},
  },
}

local M = {}

M.treesitter_grammars = {}
for _, lang in pairs(langs) do
  utils.table.append_values(M.treesitter_grammars, lang.treesitter_grammars)
end

-- [[ Line width limit via colorcolumn ]]
M.setup_fill_col_indicator = function()
  local fill_col_indicator_group =
    vim.api.nvim_create_augroup("FillColumnIndicator", { clear = true })

  local function bind_file_type_to_fill_col_indicator_limit(type, limit)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = type,
      group = fill_col_indicator_group,
      callback = function()
        vim.opt.colorcolumn = limit
      end,
    })
  end

  for _, lang in pairs(langs) do
    bind_file_type_to_fill_col_indicator_limit(
      lang.fill_col_indicator.type,
      lang.fill_col_indicator.limit
    )
  end
end

-- Package list: https://mason-registry.dev/registry/list
M.mason_lspconfig_ensure_installed = {}
for _, lang in pairs(langs) do
  utils.table.append_values(
    M.mason_lspconfig_ensure_installed,
    lang.mason_lspconfig_ensure_installed
  )
end

return M
