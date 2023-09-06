-- NOTE: using N+1 for fill col indicator to be an "untouchable" visual border

local utils = require("utils")

local langs = {
  circom = {
    fill_col_indicator = { type = "circom", limit = "81" },
    treesitter_grammars = {},
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  dart = {
    fill_col_indicator = { type = "dart", limit = "81" },
    treesitter_grammars = { "dart" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  dockerfile = {
    fill_col_indicator = { type = "dockerfile", limit = "81" },
    treesitter_grammars = { "dockerfile" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  go = {
    fill_col_indicator = { type = "go", limit = "81" },
    treesitter_grammars = {
      "go",
      "gomod",
      "gosum",
      "gowork",
    },
    mason_lspconfig_ensure_installed = {
      "gopls", -- gopls
    },
    telescope_file_ignore_patterns = { "vendor" },
    lsp_settings = {
      server_name = "gopls",
      settings = {},
    },
    null_ls_sources = function()
      local null_ls = require("plugins.nullls").require_module.null_ls()
      local builtins = null_ls.builtins
      return {
        -- [[ Code actions ]]
        -- Go tool to modify struct field tags.
        -- https://github.com/fatih/gomodifytags
        builtins.code_actions.gomodifytags,
        -- impl generates method stubs for implementing a Go interface.
        -- https://github.com/josharian/impl
        builtins.code_actions.impl,

        -- TODO: uncomment linters when project is ready

        -- [[ Diagnostics ]]
        -- A Go linter aggregator.
        -- https://golangci-lint.run/
        -- builtins.diagnostics.golangci_lint,
        -- Fast, configurable, extensible, flexible, and beautiful linter
        -- for Go.
        -- https://revive.run/
        -- builtins.diagnostics.revive,
        -- Advanced Go linter.
        -- https://staticcheck.io/
        -- builtins.diagnostics.staticcheck,

        -- [[ Formatting ]]
        -- Updates your Go import lines, adding missing ones and removing
        -- unreferenced ones and formats go programs.
        -- https://pkg.go.dev/golang.org/x/tools/cmd/goimports
        builtins.formatting.goimports,
      }
    end,
  },

  java = {
    fill_col_indicator = { type = "java", limit = "141" },
    treesitter_grammars = { "java" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  javascript = {
    fill_col_indicator = { type = "javascript", limit = "81" },
    treesitter_grammars = {
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
    },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = { "node_modules" },
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  kotlin = {
    fill_col_indicator = { type = "kotlin", limit = "141" },
    treesitter_grammars = { "kotlin" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  lua = {
    fill_col_indicator = { type = "lua", limit = "81" },
    treesitter_grammars = {
      "lua",
      "luadoc",
      "luap",
      "luau",
    },
    mason_lspconfig_ensure_installed = {
      "lua_ls", -- lua-language-server
    },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "lua_ls",
      settings = {
        Lua = {
          completion = {
            callSnippet = "Disable",
            keywordSnippet = "Disable",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              [require("plugins.lazy").libpath] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
          telemetry = { enable = false },
        },
      },
    },
    null_ls_sources = function()
      local null_ls = require("plugins.nullls").require_module.null_ls()
      local builtins = null_ls.builtins
      return {
        -- [[ Diagnostics ]]
        -- Uses inbuilt Lua code to detect lines with trailing whitespace
        -- and show a diagnostic warning on each line where it's present.
        builtins.diagnostics.trail_space,

        -- [[ Formatting ]]
        -- An opinionated code formatter for Lua.
        -- https://github.com/JohnnyMorganz/StyLua
        builtins.formatting.stylua,
      }
    end,
  },

  markdown = {
    fill_col_indicator = { type = "markdown", limit = "81" },
    treesitter_grammars = { "markdown" },
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  org = {
    fill_col_indicator = { type = "org", limit = "81" },
    treesitter_grammars = {},
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  python = {
    fill_col_indicator = { type = "python", limit = "81" },
    treesitter_grammars = { "python", "starlark" },
    mason_lspconfig_ensure_installed = {
      -- "pyright", -- pyright
    },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      -- server_name = "pyright",
      -- settings = {},
    },
    null_ls_sources = function()
      return {}
    end,
  },

  rust = {
    fill_col_indicator = { type = "rust", limit = "100" },
    treesitter_grammars = { "rust", "toml" },
    mason_lspconfig_ensure_installed = {
      -- "rust_analyzer", -- rust-analyzer
    },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      -- server_name = "rust_analyzer",
      -- settings = {},
    },
    null_ls_sources = function()
      return {}
    end,
  },

  text = {
    fill_col_indicator = { type = "text", limit = "81" },
    treesitter_grammars = {},
    mason_lspconfig_ensure_installed = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    null_ls_sources = function()
      return {}
    end,
  },

  typescript = {
    fill_col_indicator = { type = "typescript", limit = "81" },
    treesitter_grammars = {
      "tsx",
      "typescript",
    },
    mason_lspconfig_ensure_installed = {
      "tsserver", -- typescript-language-server
    },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "tsserver",
      settings = {},
    },
    null_ls_sources = function()
      local null_ls = require("plugins.nullls").require_module.null_ls()
      local builtins = null_ls.builtins
      return {
        -- [[ Code Actions ]]
        -- Injects actions to fix ESLint issues or ignore broken rules.
        builtins.code_actions.eslint,

        -- [[ Diagnostics ]]
        -- A linter for the JavaScript ecosystem.
        builtins.diagnostics.eslint,
        -- Parses diagnostics from the TypeScript compiler.
        builtins.diagnostics.tsc,

        -- [[ Formatting ]]
        -- Find and fix problems in your JavaScript code.
        -- Prettier is an opinionated code formatter. It enforces a consistent
        -- style by parsing your code and re-printing it with its own rules
        -- that take the maximum line length into account, wrapping code when
        -- necessary.
        builtins.formatting.prettier,
      }
    end,
  },
}

local M = {}

-- [[ Line width limit via colorcolumn ]]
M.setup_fill_col_indicator = function()
  local fill_col_indicator_group =
    vim.api.nvim_create_augroup("FillColumnIndicator", { clear = true })

  local function bind_file_type_to_fill_col_indicator_limit(type, limit)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = type,
      group = fill_col_indicator_group,
      callback = function()
        vim.opt.colorcolumn = limit
      end,
    })
  end

  for _, lang in pairs(langs) do
    bind_file_type_to_fill_col_indicator_limit(
      lang.fill_col_indicator.type,
      lang.fill_col_indicator.limit
    )
  end
end

-- [[ Treesitter grammars ]]
M.treesitter_grammars = {}
for _, lang in pairs(langs) do
  utils.table.append_values(M.treesitter_grammars, lang.treesitter_grammars)
end

-- [[ Mason LSP config -> ensure installed ]]
-- Package list: https://mason-registry.dev/registry/list
M.mason_lspconfig_ensure_installed = {}
for _, lang in pairs(langs) do
  utils.table.append_values(
    M.mason_lspconfig_ensure_installed,
    lang.mason_lspconfig_ensure_installed
  )
end

-- [[ Files ignored by Telescope ]]
M.telescope_file_ignore_patterns = {}
for _, lang in pairs(langs) do
  utils.table.append_values(
    M.telescope_file_ignore_patterns,
    lang.telescope_file_ignore_patterns
  )
end

-- [[ Settings for LSP ]]
M.lsp_settings = {}
for _, lang in pairs(langs) do
  local lsp_settings = lang.lsp_settings
  local server_name = lsp_settings["server_name"]
  if server_name ~= nil then
    M.lsp_settings[server_name] = lsp_settings.settings
  end
end

-- [[ null-ls sources ]]
M.null_ls_sources = function()
  local null_ls_sources = {}
  for _, lang in pairs(langs) do
    utils.table.append_values(null_ls_sources, lang.null_ls_sources())
  end
  return null_ls_sources
end

return M
