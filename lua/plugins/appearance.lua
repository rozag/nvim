local utils = require("utils")

local M = {}

M.ids = {
  colorizer = "NvChad/nvim-colorizer.lua",
  devicons = "nvim-tree/nvim-web-devicons",
  tint = "levouh/tint.nvim",
}

M.require_module = {
  colorizer = function()
    return require("colorizer")
  end,
  devicons = function()
    return require("nvim-web-devicons")
  end,
  tint = function()
    return require("tint")
  end,
}

M.lazy_defs = {
  -- [[ Preview for color literals, highlights #123456 strings ]]
  -- https://github.com/NvChad/nvim-colorizer.lua
  {
    M.ids.colorizer,
    config = function()
      local colorizer = M.require_module.colorizer()
      colorizer.setup {}
      colorizer.attach_to_buffer(0)
    end,
  },

  -- [[ Fancy icons , , , etc. ]]
  -- https://github.com/nvim-tree/nvim-web-devicons
  {
    M.ids.devicons,
    config = function()
      M.require_module.devicons().setup()
    end,
  },

  -- [[ Dim inactive windows ]]
  -- https://github.com/levouh/tint.nvim
  {
    M.ids.tint,
    config = function()
      M.require_module.tint().setup {
        tint = 0,
        saturation = 0.2,
        tint_background_colors = false,
        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)

          local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
          local is_terminal = buftype == "terminal"

          local filetype = vim.api.nvim_buf_get_option(bufid, "filetype")
          local is_tree = utils.table.contains_value(
            require("plugins.tree").filetypes,
            filetype
          )

          local is_floating = vim.api.nvim_win_get_config(winid).relative ~= ""

          return is_terminal or is_tree or is_floating
        end,
      }
    end,
  },
}

return M
