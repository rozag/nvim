local utils = require("utils")

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

M.install = function()
  -- [[ Install lazy.nvim package manager ]]
  -- https://github.com/folke/lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/" .. M.ids.lazy .. ".git",
      "--branch=stable", -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)
end

-- TODO: extract on attach and formatting group
local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})
-- This function gets run when an LSP connects to a particular buffer.
local lsp_on_attach = function(client, bufnr)
  -- local function nmap(keys, func, desc)
  --   if desc then
  --     desc = "LSP: " .. desc
  --   end
  --
  --   vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  -- end

  -- TODO: review these mappings, they're from kickstart
  -- nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  -- nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  require("kbd").plugins.telescope.lsp_on_attach()

  -- TODO: these 2 things below should be linked with null-ls
  -- TODO: Cmd+L to run format?
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format { async = false }
  end, { desc = "Format current buffer with LSP" })

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds { group = formatting_group, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = formatting_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end
end

-- [[ Plugins ]]
local plugins = {
  -- [[ Neovim development stuff ]]
  -- https://github.com/folke/neodev.nvim
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup()
    end,
  },

  -- [[ LSP configuration ]]
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("plugins.completion").require_module
        .cmp_nvim_lsp()
        .default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      lspconfig.gopls.setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        settings = {},
      }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = lsp_on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
            telemetry = { enable = false },
          },
        },
      }
      -- lspconfig.pyright.setup {
      --   capabilities = capabilities,
      --   on_attach = lsp_on_attach,
      --   settings = {},
      -- }
      -- lspconfig.rust_analyzer.setup {
      --   capabilities = capabilities,
      --   on_attach = lsp_on_attach,
      --   settings = {},
      -- }
      -- lspconfig.tsserver.setup {
      --   capabilities = capabilities,
      --   on_attach = lsp_on_attach,
      --   settings = {},
      -- }
    end,
  },

  -- [[ LSP improvements - linters, formatters, etc. ]]
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  -- Available builtins:
  -- github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup {
        on_attach = lsp_on_attach,
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
  utils.table.append_values(plugins, require("plugins.appearance").lazy_defs)
  utils.table.append_values(plugins, require("plugins.cmdmenu").lazy_defs)
  utils.table.append_values(plugins, require("plugins.colorscheme").lazy_defs)
  utils.table.append_values(plugins, require("plugins.completion").lazy_defs)
  utils.table.append_values(plugins, require("plugins.copilot").lazy_defs)
  utils.table.append_values(plugins, require("plugins.editing").lazy_defs)
  utils.table.append_values(plugins, require("plugins.git").lazy_defs)
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
