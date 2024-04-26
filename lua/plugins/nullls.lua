local M = {}

M.ids = {
  null_ls = "jose-elias-alvarez/null-ls.nvim",
}

M.require_module = {
  null_ls = function()
    return require("null-ls")
  end,
  null_ls_methods = function()
    return require("null-ls.methods")
  end,
  null_ls_helpers = function()
    return require("null-ls.helpers")
  end,
}

M.lazy_defs = {
  -- [[ LSP improvements - linters, formatters, etc. ]]
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  -- Available builtins:
  -- github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  {
    M.ids.null_ls,
    config = function()
      local null_ls = M.require_module.null_ls()
      local utils = require("utils")

      local sources = {
        -- [[ Formatting ]]
        -- Command-line JSON processor.
        -- https://github.com/stedolan/jq
        null_ls.builtins.formatting.jq,
      }
      utils.table.append_values(
        sources,
        require("plugins.git").null_ls_sources()
      )
      utils.table.append_values(
        sources,
        require("plugins.langs").null_ls_sources()
      )

      null_ls.setup {
        on_attach = require("plugins.lsp").on_attach,
        sources = sources,
      }
    end,
  },
}

return M
