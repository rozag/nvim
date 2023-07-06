local M = {}

M.ids = {
  copilot = "zbirenbaum/copilot.lua",
}

M.require_module = {
  copilot = function()
    return require("copilot")
  end,
}

M.lazy_defs = {
  -- [[ Github Copilot ]]
  -- https://github.com/zbirenbaum/copilot.lua
  {
    M.ids.copilot,
    cmd = { "Copilot" },
    event = "InsertEnter",
    config = function()
      M.require_module.copilot().setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = require("kbd").plugins.copilot,
        },
        filetypes = {
          yaml = true,
          markdown = true,
        },
      }
    end,
  },
}

return M
