-- Install lazy.nvim package manager: https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- TODO: set up autoformatting and use stylua.toml

-- Install and configure plugins via lazy.nvim
require("lazy").setup(
  -- Plugins - either a table or a string:
  -- • table: a list with your Plugin Spec:
  --   https://github.com/folke/lazy.nvim#-plugin-spec
  -- • string: a Lua module name that contains your Plugin Spec. See Structuring
  --   Your Plugins:
  --   https://github.com/folke/lazy.nvim#-structuring-your-plugins
  {
    -- TODO extract definitions and settings for them
  },

  -- Options: https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
  {
    defaults = { lazy = true },
    -- install = { colorscheme = { "nvchad" } }, -- TODO get some NvChad scheme?

    ui = {
      icons = {
        cmd = " ",
        config = "",
        event = "",
        ft = " ",
        init = " ",
        import = " ",
        keys = " ",
        lazy = "󰒲 ",
        loaded = "●",
        not_loaded = "○",
        plugin = " ",
        runtime = " ",
        source = " ",
        start = "",
        task = "✔ ",
        list = {
          "●",
          "➜",
          "★",
          "‒",
        },
      },
    },

    -- TODO: got this block from NvChad, should probably be reviewed
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "tohtml",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchit",
          "tar",
          "tarPlugin",
          "rrhelper",
          "spellfile_plugin",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "bugreport",
          "ftplugin",
        },
      },
    },
  }
)
