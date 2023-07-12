local M = {}

M.ids = {
  surround = "kylechui/nvim-surround",
  which_key = "folke/which-key.nvim",
}

M.require_module = {
  surround = function()
    return require("nvim-surround")
  end,
  which_key = function()
    return require("which-key")
  end,
}

M.lazy_defs = {
  -- [[ Surround: `yse"` & `cs"b` ]]
  -- https://github.com/kylechui/nvim-surround
  {
    M.ids.surround,
    config = function()
      M.require_module.surround().setup()
    end,
  },

  -- [[ Show pending keybindings ]]
  -- https://github.com/folke/which-key.nvim
  {
    M.ids.which_key,
    config = function()
      M.require_module.which_key().setup {
        icons = {
          group = "  ",
        },
      }
    end,
  },
}

return M
