local utils = require("utils")

local langs = {
  dart = {
    treesitter_grammars = { "dart" },
    fill_col_indicator = { type = "dart", limit = "81" },
  },

  dockerfile = {
    treesitter_grammars = { "dockerfile" },
    fill_col_indicator = { type = "dockerfile", limit = "81" },
  },

  go = {
    treesitter_grammars = {
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
    fill_col_indicator = { type = "go", limit = "81" },
  },

  java = {
    treesitter_grammars = { "java" },
    fill_col_indicator = { type = "java", limit = "141" },
  },

  kotlin = {
    treesitter_grammars = { "kotlin" },
    fill_col_indicator = { type = "kotlin", limit = "141" },
  },

  lua = {
    treesitter_grammars = {
      "lua",
      "luadoc",
      "luap",
      "luau",
    },
    fill_col_indicator = { type = "lua", limit = "81" },
  },

  markdown = {
    treesitter_grammars = { "markdown" },
    fill_col_indicator = { type = "markdown", limit = "81" },
  },

  org = {
    treesitter_grammars = {},
    fill_col_indicator = { type = "org", limit = "81" },
  },

  python = {
    treesitter_grammars = { "python", "starlark" },
    fill_col_indicator = { type = "python", limit = "81" },
  },

  rust = {
    treesitter_grammars = { "rust", "toml" },
    fill_col_indicator = { type = "rust", limit = "100" },
  },

  text = {
    treesitter_grammars = {},
    fill_col_indicator = { type = "text", limit = "81" },
  },
}

local M = {}

M.treesitter_grammars = {}
for _, lang in pairs(langs) do
  utils.table.append_values(M.treesitter_grammars, lang.treesitter_grammars)
end

-- [[ Line width limit via colorcolumn ]]
M.setup_fill_col_indicator = function()
  -- NOTE: using column index + 1 to be an "untouchable" visual border

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

return M
