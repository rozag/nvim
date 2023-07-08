local utils = require("utils")

local langs = {
  lua = {
    treesitter_grammars = {
      "lua",
      "luadoc",
      "luap",
      "luau",
    },
  },

  go = {
    treesitter_grammars = {
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
  },
}

local M = {}

M.treesitter_grammars = {}
for _, lang in pairs(langs) do
  utils.table.insert_all(M.treesitter_grammars, lang.treesitter_grammars)
end

return M
