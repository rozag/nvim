-- NOTE: using N+1 for fill col indicator to be an "untouchable" visual border

local utils = require("utils")

local langs = {
  dart = {
    fill_col_indicator = { type = "dart", limit = "81" },
    treesitter_grammars = { "dart" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  dockerfile = {
    fill_col_indicator = { type = "dockerfile", limit = "81" },
    treesitter_grammars = { "dockerfile" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  go = {
    fill_col_indicator = { type = "go", limit = "81" },
    treesitter_grammars = {
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
    mason_lspconfig_ensure_installed = {
      "gopls", -- gopls
    },
    telescope_file_ignore_patterns = { "vendor" },
  },

  java = {
    fill_col_indicator = { type = "java", limit = "141" },
    treesitter_grammars = { "java" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  javascript = {
    fill_col_indicator = { type = "javascript", limit = "81" },
    treesitter_grammars = {
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
    },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = { "node_modules" },
  },

  kotlin = {
    fill_col_indicator = { type = "kotlin", limit = "141" },
    treesitter_grammars = { "kotlin" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  lua = {
    fill_col_indicator = { type = "lua", limit = "81" },
    treesitter_grammars = {
      "lua",
      "luadoc",
      "luap",
      "luau",
    },
    mason_lspconfig_ensure_installed = {
      "lua_ls", -- lua-language-server
    },
    telescope_file_ignore_patterns = {},
  },

  markdown = {
    fill_col_indicator = { type = "markdown", limit = "81" },
    treesitter_grammars = { "markdown" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  org = {
    fill_col_indicator = { type = "org", limit = "81" },
    treesitter_grammars = {},
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  python = {
    fill_col_indicator = { type = "python", limit = "81" },
    treesitter_grammars = { "python", "starlark" },
    mason_lspconfig_ensure_installed = {
      -- "pyright", -- pyright
    },
    telescope_file_ignore_patterns = {},
  },

  rust = {
    fill_col_indicator = { type = "rust", limit = "100" },
    treesitter_grammars = { "rust", "toml" },
    mason_lspconfig_ensure_installed = {
      -- "rust_analyzer", -- rust-analyzer
    },
    telescope_file_ignore_patterns = {},
  },

  text = {
    fill_col_indicator = { type = "text", limit = "81" },
    treesitter_grammars = {},
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
  },

  typescript = {
    fill_col_indicator = { type = "typescript", limit = "81" },
    treesitter_grammars = {
      "tsx",
      "typescript",
    },
    mason_lspconfig_ensure_installed = {
      -- "tsserver", -- typescript-language-server
    },
    telescope_file_ignore_patterns = {},
  },
}

local M = {}

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

-- [[ Treesitter grammars ]]
M.treesitter_grammars = {}
for _, lang in pairs(langs) do
  utils.table.append_values(M.treesitter_grammars, lang.treesitter_grammars)
end

-- [[ Mason LSP config -> ensure installed ]]
-- Package list: https://mason-registry.dev/registry/list
M.mason_lspconfig_ensure_installed = {}
for _, lang in pairs(langs) do
  utils.table.append_values(
    M.mason_lspconfig_ensure_installed,
    lang.mason_lspconfig_ensure_installed
  )
end

-- [[ Files ignored by Telescope ]]
M.telescope_file_ignore_patterns = {}
for _, lang in pairs(langs) do
  utils.table.append_values(
    M.telescope_file_ignore_patterns,
    lang.telescope_file_ignore_patterns
  )
end

return M
