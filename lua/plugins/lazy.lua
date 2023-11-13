local M = {}

M.ids = {
  lazy = "folke/lazy.nvim",
}

M.require_module = {
  lazy = function()
    return require("lazy")
  end,
}

M.filetypes = {
  "lazy",
}

M.cmd = "Lazy"

M.lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
M.libpath = M.lazypath .. "/lua/lazy"

M.install = function()
  -- [[ Install lazy.nvim package manager ]]
  -- https://github.com/folke/lazy.nvim
  if not vim.loop.fs_stat(M.lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/" .. M.ids.lazy .. ".git",
      "--branch=stable", -- latest stable release
      M.lazypath,
    }
  end
  vim.opt.rtp:prepend(M.lazypath)
end

-- [[ Plugins ]]
M.setup = function()
  local utils = require("utils")
  local plugins = {}
  utils.table.append_values(plugins, require("plugins.appearance").lazy_defs)
  utils.table.append_values(plugins, require("plugins.cmdmenu").lazy_defs)
  utils.table.append_values(plugins, require("plugins.colorscheme").lazy_defs)
  utils.table.append_values(plugins, require("plugins.completion").lazy_defs)
  utils.table.append_values(plugins, require("plugins.copilot").lazy_defs)
  utils.table.append_values(plugins, require("plugins.dashboard").lazy_defs)
  utils.table.append_values(plugins, require("plugins.editing").lazy_defs)
  utils.table.append_values(plugins, require("plugins.git").lazy_defs)
  utils.table.append_values(plugins, require("plugins.lsp").lazy_defs)
  utils.table.append_values(plugins, require("plugins.mason").lazy_defs)
  utils.table.append_values(plugins, require("plugins.nullls").lazy_defs)
  utils.table.append_values(plugins, require("plugins.statusline").lazy_defs)
  utils.table.append_values(plugins, require("plugins.stdlib").lazy_defs)
  utils.table.append_values(plugins, require("plugins.syntax").lazy_defs)
  utils.table.append_values(plugins, require("plugins.telescope").lazy_defs)
  utils.table.append_values(plugins, require("plugins.tmux").lazy_defs)
  utils.table.append_values(plugins, require("plugins.tree").lazy_defs)
  utils.table.append_values(plugins, require("plugins.treesitter").lazy_defs)
  utils.table.append_values(plugins, require("plugins.trouble").lazy_defs)

  -- [[ Install and configure plugins via lazy.nvim ]]
  -- https://github.com/folke/lazy.nvim
  M.require_module.lazy().setup(
    plugins,

    -- [[ Options ]]
    -- https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
    {
      install = { colorscheme = { require("plugins.colorscheme").name } },

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
            "bugreport",
            "compiler",
            "ftplugin",
            "getscript",
            "getscriptPlugin",
            "gzip",
            "logipat",
            "matchit",
            "netrw",
            "netrwFileHandlers",
            "netrwPlugin",
            "netrwSettings",
            "optwin",
            "rplugin",
            "rrhelper",
            "spellfile_plugin",
            "synmenu",
            "syntax",
            "tar",
            "tarPlugin",
            "tohtml",
            "tutor",
            "vimball",
            "vimballPlugin",
            "zip",
            "zipPlugin",
          },
        },
      },
    }
  )

  require("kbd").plugins.lazy()
end

return M
