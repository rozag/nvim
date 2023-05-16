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

-- [[ Install and configure plugins via lazy.nvim ]]
require("lazy").setup(
  -- [[ Plugins ]]

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    branch = "main",
    lazy = false,
    config = function()
      -- vim.cmd.colorscheme("tokyonight-night")
      vim.cmd.colorscheme("tokyonight")
    end
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "frappe", -- latte, frappe, macchiato, mocha
  --       background = {
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --       transparent_background = false,
  --       show_end_of_buffer = false,
  --       term_colors = true,
  --       dim_inactive = {
  --         enabled = false,
  --         shade = "dark",
  --         percentage = 0.15,
  --       },
  --       no_italic = false, -- Force no italic
  --       no_bold = false, -- Force no bold
  --       styles = {
  --         comments = { "italic" },
  --         conditionals = { "italic" },
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       color_overrides = {},
  --       custom_highlights = {},
  --       integrations = {
  --         cmp = true,
  --         gitsigns = true,
  --         nvimtree = true,
  --         telescope = true,
  --         notify = false,
  --         mini = false,
  --         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  --       },
  --     })
  --     vim.cmd.colorscheme("catppuccin")
  --   end,
  -- },

  -- [[ Options ]]
  -- https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
  {
    defaults = { lazy = true },

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
