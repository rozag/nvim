local M = {}

M.ids = {
  none_ls = "nvimtools/none-ls.nvim",
  none_ls_extras = "nvimtools/none-ls-extras.nvim",
}

M.require_module = {
  none_ls = function()
    return require("null-ls")
  end,
  none_ls_methods = function()
    return require("null-ls.methods")
  end,
  none_ls_helpers = function()
    return require("null-ls.helpers")
  end,
  none_ls_formatting_jq = function()
    return require("none-ls.formatting.jq")
  end,
  none_ls_code_actions_eslint = function()
    return require("none-ls.code_actions.eslint")
  end,
  none_ls_diagnostics_eslint = function()
    return require("none-ls.diagnostics.eslint")
  end,
  none_ls_formatting_rustfmt = function()
    return require("none-ls.formatting.rustfmt")
  end,
}

M.lazy_defs = {
  -- [[ LSP improvements - linters, formatters, etc. ]]
  -- https://github.com/nvimtools/none-ls.nvim
  -- Available builtins:
  -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
  {
    M.ids.none_ls,
    dependencies = { M.ids.none_ls_extras },
    config = function()
      local none_ls = M.require_module.none_ls()
      local utils = require("utils")

      local sources = {
        -- [[ Formatting ]]
        -- Command-line JSON processor.
        -- https://github.com/stedolan/jq
        M.require_module.none_ls_formatting_jq(),
      }
      utils.table.append_values(
        sources,
        require("plugins.git").none_ls_sources()
      )
      utils.table.append_values(
        sources,
        require("plugins.langs").none_ls_sources()
      )

      none_ls.setup {
        on_attach = require("plugins.lsp").on_attach,
        sources = sources,
      }
    end,
  },
}

return M
