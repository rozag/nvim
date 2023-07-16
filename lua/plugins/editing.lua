local M = {}

M.ids = {
  surround = "kylechui/nvim-surround",
  which_key = "folke/which-key.nvim",
  comment = "numToStr/Comment.nvim",
}

M.require_module = {
  surround = function()
    return require("nvim-surround")
  end,
  which_key = function()
    return require("which-key")
  end,
  comment = function()
    return require("Comment")
  end,
}

M.cmd_which_key_telescope = "which_key"

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

  -- [[ Comments: `gcc` & `gc` while in visual ]]
  -- https://github.com/numToStr/Comment.nvim
  {
    M.ids.comment,
    config = function()
      M.require_module.comment().setup()
      require("kbd").plugins.comment()
    end,
  },
}

return M
