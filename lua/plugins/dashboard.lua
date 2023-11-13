local M = {}

M.ids = {
  dashboard = "nvimdev/dashboard-nvim",
}

M.require_module = {
  dashboard = function()
    return require("dashboard")
  end,
}

M.filetypes = {
  "dashboard",
}

M.lazy_defs = {
  -- [[ Dashboard ]]
  -- https://github.com/nvimdev/dashboard-nvim
  {
    M.ids.dashboard,
    dependencies = { { require("plugins.appearance").ids.devicons } },
    event = "VimEnter",
    config = function()
      M.require_module.dashboard().setup {
        theme = "hyper",
        config = {
          header = {},
          footer = {},
          shortcut = {
            { desc = "🚀 Per aspera ad astra", group = "DashboardShortCut" },
          },
          week_header = {
            enable = true,
            concat = "",
            append = {},
          },
        },
        shortcut_type = "number",
        hide = {
          statusline = false,
        },
      }
    end,
  },
}

return M
