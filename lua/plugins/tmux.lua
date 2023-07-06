local M = {}

M.ids = {
  tmux = "aserowy/tmux.nvim",
}

M.require_module = {
  tmux = function()
    return require("tmux")
  end,
}

M.lazy_defs = {
  -- [[ Seamless tmux+nvim navigation ]]
  -- https://github.com/aserowy/tmux.nvim
  {
    M.ids.tmux,
    config = function()
      local tmux = M.require_module.tmux()
      tmux.setup {
        copy_sync = {
          enable = false,
        },
        navigation = {
          enable_default_keybindings = false,
        },
        resize = {
          enable_default_keybindings = false,
        },
      }

      require("kbd").plugins.tmux()
    end,
  },
}

return M
