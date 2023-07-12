local utils = require("utils")

local M = {}

M.ids = {
  wilder = "gelguy/wilder.nvim",
}

M.require_module = {
  wilder = function()
    return require("wilder")
  end,
}

M.lazy_defs = {
  -- [[ Suggestions for commands menu ]]
  -- https://github.com/gelguy/wilder.nvim
  {
    M.ids.wilder,
    config = function()
      local wilder = M.require_module.wilder()

      local opts = { modes = { ":" } }
      utils.table.append_keys_values(opts, require("kbd").plugins.wilder)
      wilder.setup(opts)

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_palette_theme {
          border = "rounded",
          max_height = "50%",
          min_height = "50%",
          prompt_position = "top",
          reverse = 0,
          highlighter = wilder.basic_highlighter(),
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
          highlights = {
            default = "WilderMenu",
            accent = wilder.make_hl("WilderAccent", "Pmenu", {
              { a = 1 },
              { a = 1 },
              { foreground = require("plugins.colorscheme").color_accent1 },
            }),
          },
        })
      )
      wilder.set_option(
        "pipeline",
        wilder.cmdline_pipeline {
          fuzzy = 1,
        }
      )
    end,
  },
}

return M
