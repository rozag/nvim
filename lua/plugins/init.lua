-- [[ Install lazy.nvim package manager ]]
-- https://github.com/folke/lazy.nvim
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

-- [[ Name of colorscheme to reuse in several places ]]
local colorschemeName = "onedark"

-- [[ Install and configure plugins via lazy.nvim ]]
-- https://github.com/folke/lazy.nvim
require("lazy").setup(
  -- [[ Plugins ]]
  {
    -- Sort of stdlib
    -- https://github.com/nvim-lua/plenary.nvim
    "nvim-lua/plenary.nvim",

    -- -- TODO: `opts = {}` is the same as calling `require('fidget').setup({})`
    -- { 'j-hui/fidget.nvim', opts = {} },

    -- tree-sitter
    -- https://github.com/nvim-treesitter/nvim-treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-refactor",
      },
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup {
          ensure_installed = { "lua" },
          highlight = {
            enable = true,
            use_languagetree = true,
          },
          indent = { enable = true },
        }
      end,
    },

    -- Colorscheme
    -- https://github.com/navarasu/onedark.nvim
    {
      "navarasu/onedark.nvim",
      config = function()
        local onedark = require(colorschemeName)
        onedark.setup {
          style = "darker",
        }
        onedark.load()
      end,
    },

    -- Comments: `gcc` & `gc` while in visual
    -- https://github.com/navarasu/onedark.nvim
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },

    -- Surround: `yse"` & `cs"b`
    -- https://github.com/kylechui/nvim-surround
    {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup()
      end
    },

    -- Indentation guides
    -- https://github.com/lukas-reineke/indent-blankline.nvim
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup {
          show_trailing_blankline_indent = false,
          show_current_context = true,
        }
      end,
    },
  },

  -- [[ Options ]]
  -- https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
  {
    -- defaults = { lazy = true },

    install = { colorscheme = { colorschemeName } },

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
