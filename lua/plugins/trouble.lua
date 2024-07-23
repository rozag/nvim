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

M.cmd_toggle = "Trouble"
M.cmd_doc_diagnostics = "Trouble project_diagnostics"
M.cmd_lsp_document_symbols = "Trouble lsp_document_symbols"

M.lazy_defs = {
  -- [[ Trouble: a panel for diagnostics, refs, etc. ]]
  -- https://github.com/folke/trouble.nvim
  {
    M.ids.trouble,
    dependencies = { require("plugins.appearance").ids.devicons },
    config = function()
      M.require_module.trouble().setup {
        auto_close = true,
        focus = true,
        max_items = 512,
        modes = {
          project_diagnostics = {
            mode = "diagnostics", -- inherit from diagnostics mode
            filter = {
              any = {
                buf = 0, -- current buffer
                {
                  -- limit to files in the current project
                  function(item)
                    return item.filename:find(
                      (vim.loop or vim.uv).cwd(),
                      1,
                      true
                    )
                  end,
                },
              },
            },
          },
        },
      }

      require("kbd").plugins.trouble()
    end,
  },
}

return M
