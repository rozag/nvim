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
local plugins = {
  -- [[ LSP improvements - linters, formatters, etc. ]]
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  -- Available builtins:
  -- github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        on_attach = require("plugins.lsp").on_attach,
        sources = {
          -- TODO: many things here should be linked with other plugins

          -- [[ Code actions ]]
          -- Injects code actions for Git operations at the current cursor
          -- position (stage / preview / reset hunks, blame, etc.).
          -- https://github.com/lewis6991/gitsigns.nvim
          null_ls.builtins.code_actions.gitsigns,
          -- Go tool to modify struct field tags.
          -- https://github.com/fatih/gomodifytags
          null_ls.builtins.code_actions.gomodifytags,
          -- impl generates method stubs for implementing a Go interface.
          -- https://github.com/josharian/impl
          null_ls.builtins.code_actions.impl,

          -- [[ Completion ]]
          -- Snippet engine for Neovim, written in Lua.
          -- https://github.com/L3MON4D3/LuaSnip
          null_ls.builtins.completion.luasnip,

          -- [[ Diagnostics ]]
          -- A Go linter aggregator.
          -- https://golangci-lint.run/
          null_ls.builtins.diagnostics.golangci_lint,
          -- Fast, configurable, extensible, flexible, and beautiful linter
          -- for Go.
          -- https://revive.run/
          null_ls.builtins.diagnostics.revive,
          -- Advanced Go linter.
          -- https://staticcheck.io/
          null_ls.builtins.diagnostics.staticcheck,
          -- Uses inbuilt Lua code to detect lines with trailing whitespace
          -- and show a diagnostic warning on each line where it's present.
          null_ls.builtins.diagnostics.trail_space,

          -- [[ Formatting ]]
          -- Formats go programs.
          -- https://pkg.go.dev/cmd/gofmt
          null_ls.builtins.formatting.gofmt,
          -- Updates your Go import lines, adding missing ones and removing
          -- unreferenced ones.
          -- https://pkg.go.dev/golang.org/x/tools/cmd/goimports
          null_ls.builtins.formatting.goimports,
          -- Command-line JSON processor.
          -- https://github.com/stedolan/jq
          null_ls.builtins.formatting.jq,
          -- An opinionated code formatter for Lua.
          -- https://github.com/JohnnyMorganz/StyLua
          null_ls.builtins.formatting.stylua,
        },
      }
    end,
  },
}

M.setup = function()
  local utils = require("utils")
  utils.table.append_values(plugins, require("plugins.appearance").lazy_defs)
  utils.table.append_values(plugins, require("plugins.cmdmenu").lazy_defs)
  utils.table.append_values(plugins, require("plugins.colorscheme").lazy_defs)
  utils.table.append_values(plugins, require("plugins.completion").lazy_defs)
  utils.table.append_values(plugins, require("plugins.copilot").lazy_defs)
  utils.table.append_values(plugins, require("plugins.editing").lazy_defs)
  utils.table.append_values(plugins, require("plugins.git").lazy_defs)
  utils.table.append_values(plugins, require("plugins.lsp").lazy_defs)
  utils.table.append_values(plugins, require("plugins.mason").lazy_defs)
  utils.table.append_values(plugins, require("plugins.statusline").lazy_defs)
  utils.table.append_values(plugins, require("plugins.stdlib").lazy_defs)
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
