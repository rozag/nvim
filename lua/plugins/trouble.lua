local M = {}

M.ids = {
  trouble = "folke/trouble.nvim",
}

M.require_module = {
  trouble = function()
    return require("trouble")
  end,
  trouble_telescope = function()
    return require("trouble.sources.telescope")
  end,
}

M.cmd_toggle = "TroubleToggle"
M.cmd_doc_diagnostics = "TroubleToggle document_diagnostics"

M.lazy_defs = {
  -- [[ Trouble: a panel for diagnostics, refs, etc. ]]
  -- https://github.com/folke/trouble.nvim
  {
    M.ids.trouble,
    dependencies = { require("plugins.appearance").ids.devicons },
    config = function()
      M.require_module.trouble().setup {
        mode = "document_diagnostics",
      }

      require("kbd").plugins.trouble()
    end,
  },
}

return M
