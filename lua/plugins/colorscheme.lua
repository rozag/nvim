local M = {}

-- Name of colorscheme to reuse in several places
M.name = "monokai-pro"

-- Colors extracted from monokai-pro sources:
-- https://github.com/loctvl842/monokai-pro.nvim
--     /blob/master/lua/monokai-pro/colorscheme/palette/spectrum.lua
M.color_accent1 = "#fc618d"
M.color_dimmed5 = "#363537"

M.ids = {
  monokai_pro = "loctvl842/monokai-pro.nvim",
}

M.require_module = {
  monokai_pro = function()
    return require(M.name)
  end,
}

M.lazy_defs = {
  -- [[ Colorscheme ]]
  -- https://github.com/loctvl842/monokai-pro.nvim
  {
    M.ids.monokai_pro,
    priority = 100,
    config = function()
      M.require_module.monokai_pro().setup {
        filter = "spectrum",
      }
      vim.cmd.colorscheme(M.name)

      -- Column limit indicator appearance, have to do it after colorscheme.
      vim.cmd("highlight ColorColumn ctermbg=0 guibg=" .. M.color_dimmed5)
    end,
  },
}

return M
