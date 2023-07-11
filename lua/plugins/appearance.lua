local M = {}

M.ids = {
  colorizer = "NvChad/nvim-colorizer.lua",
  devicons = "nvim-tree/nvim-web-devicons",
  shade = "sunjon/Shade.nvim",
}

M.require_module = {
  colorizer = function()
    return require("colorizer")
  end,
  devicons = function()
    return require("nvim-web-devicons")
  end,
  shade = function()
    return require("shade")
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
  -- https://github.com/sunjon/Shade.nvim
  {
    M.ids.shade,
    config = function()
      M.require_module.shade().setup {
        overlay_opacity = 50,
        opacity_step = 1,
      }
    end,
  },
}

return M
