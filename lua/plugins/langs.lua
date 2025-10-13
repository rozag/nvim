-- NOTE: using N+1 for fill col indicator to be an "untouchable" visual border

local utils = require("utils")

local langs = {
  circom = {
    fill_col_indicator = { type = "circom", limit = "81" },
    treesitter_grammars = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  clojure = {
    fill_col_indicator = { type = "clojure", limit = "81" },
    treesitter_grammars = { "clojure" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "clojure_lsp",
      settings = {},
    },
    none_ls_sources = function()
      local plug_none_ls = require("plugins.nullls")
      local builtins = plug_none_ls.require_module.none_ls().builtins

      local methods = plug_none_ls.require_module.none_ls_methods()
      local helpers = plug_none_ls.require_module.none_ls_helpers()

      local function cljfmt()
        return helpers.make_builtin {
          name = "cljfmt",
          meta = {
            url = "https://github.com/weavejester/cljfmt",
            description = "A tool for formatting Clojure code.",
          },
          method = methods.internal.FORMATTING,
          filetypes = { "clojure" },
          generator_opts = {
            command = "cljfmt",
            args = {
              "fix",
              "-",
            },
            to_stdin = true,
          },
          factory = helpers.formatter_factory,
        }
      end

      return {
        -- [[ Diagnostics ]]
        -- A linter for clojure code that sparks joy.
        -- https://github.com/clj-kondo/clj-kondo
        builtins.diagnostics.clj_kondo,

        -- [[ Formatting ]]
        cljfmt(),
      }
    end,
  },

  dart = {
    fill_col_indicator = { type = "dart", limit = "81" },
    treesitter_grammars = { "dart" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  dockerfile = {
    fill_col_indicator = { type = "dockerfile", limit = "81" },
    treesitter_grammars = { "dockerfile" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
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
    telescope_file_ignore_patterns = { "vendor" },
    lsp_settings = {
      server_name = "gopls",
      settings = {},
    },
    none_ls_sources = function()
      local none_ls = require("plugins.nullls").require_module.none_ls()
      local builtins = none_ls.builtins
      return {
        -- [[ Code actions ]]
        -- Go tool to modify struct field tags.
        -- https://github.com/fatih/gomodifytags
        builtins.code_actions.gomodifytags,
        -- impl generates method stubs for implementing a Go interface.
        -- https://github.com/josharian/impl
        builtins.code_actions.impl,

        -- [[ Diagnostics ]]
        -- A Go linter aggregator.
        -- https://golangci-lint.run/
        builtins.diagnostics.golangci_lint,

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
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
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
    telescope_file_ignore_patterns = { "node_modules" },
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  kotlin = {
    fill_col_indicator = { type = "kotlin", limit = "141" },
    treesitter_grammars = { "kotlin" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
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
    none_ls_sources = function()
      local none_ls = require("plugins.nullls").require_module.none_ls()
      local builtins = none_ls.builtins
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
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  org = {
    fill_col_indicator = { type = "org", limit = "81" },
    treesitter_grammars = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  python = {
    fill_col_indicator = { type = "python", limit = "81" },
    treesitter_grammars = { "python", "starlark" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "pyright",
      settings = {},
    },
    none_ls_sources = function()
      local plug_none_ls = require("plugins.nullls")

      local none_ls = plug_none_ls.require_module.none_ls()
      local builtins = none_ls.builtins

      local methods = plug_none_ls.require_module.none_ls_methods()
      local helpers = plug_none_ls.require_module.none_ls_helpers()

      local function ruff_diag()
        local custom_end_col = {
          end_col = function(entries, line)
            if not line then
              return
            end

            local start_col = entries["col"]
            local message = entries["message"]
            local code = entries["code"]
            local default_position = start_col + 1

            local pattern = nil
            local trimmed_line = line:sub(start_col, -1)

            if code == "F841" or code == "F823" then
              pattern = [[Local variable %`(.*)%`]]
            elseif code == "F821" or code == "F822" then
              pattern = [[Undefined name %`(.*)%`]]
            elseif code == "F401" then
              pattern = [[%`(.*)%` imported but unused]]
            elseif code == "F841" then
              pattern =
                [[Local variable %`(.*)%` is assigned to but never used]]
            end
            if not pattern then
              return default_position
            end

            local results = message:match(pattern)
            local _, end_col = trimmed_line:find(results, 1, true)

            if not end_col then
              return default_position
            end

            end_col = end_col + start_col
            if end_col > tonumber(start_col) then
              return end_col
            end

            return default_position
          end,
        }
        return helpers.make_builtin {
          name = "ruff",
          meta = {
            url = "https://github.com/astral-sh/ruff",
            description = "An extremely fast Python linter, written in Rust.",
          },
          method = methods.internal.DIAGNOSTICS,
          filetypes = { "python" },
          generator_opts = {
            command = "ruff",
            args = {
              "check",
              "-n",
              "-e",
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
            format = "line",
            check_exit_code = function(code)
              return code == 0
            end,
            to_stdin = true,
            ignore_stderr = true,
            on_output = helpers.diagnostics.from_pattern(
              [[(%d+):(%d+): ((%u)%w+) (.*)]],
              { "row", "col", "code", "severity", "message" },
              {
                adapters = {
                  custom_end_col,
                },
                severities = {
                  -- pycodestyle errors
                  E = helpers.diagnostics.severities["error"],
                  -- pycodestyle warnings
                  W = helpers.diagnostics.severities["warning"],
                  -- pyflakes
                  F = helpers.diagnostics.severities["information"],
                  -- flake8-builtins
                  A = helpers.diagnostics.severities["information"],
                  -- flake8-bugbear
                  B = helpers.diagnostics.severities["warning"],
                  -- flake8-comprehensions
                  C = helpers.diagnostics.severities["warning"],
                  -- flake8-print
                  T = helpers.diagnostics.severities["information"],
                  -- pyupgrade
                  U = helpers.diagnostics.severities["information"],
                  -- pydocstyle
                  D = helpers.diagnostics.severities["information"],
                  -- Meta
                  M = helpers.diagnostics.severities["information"],
                },
              }
            ),
          },
          factory = helpers.generator_factory,
        }
      end

      local function ruff_fmt()
        return helpers.make_builtin {
          name = "ruff",
          meta = {
            url = "https://github.com/astral-sh/ruff",
            description = "An extremely fast Python linter, written in Rust.",
          },
          method = methods.internal.FORMATTING,
          filetypes = { "python" },
          generator_opts = {
            command = "ruff",
            args = {
              "format",
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
            to_stdin = true,
          },
          factory = helpers.formatter_factory,
        }
      end

      return {
        -- [[ Diagnostics ]]
        -- An extremely fast Python linter, written in Rust.
        -- https://github.com/astral-sh/ruff
        ruff_diag(),

        -- [[ Formatting ]]
        -- An extremely fast Python linter, written in Rust.
        -- https://github.com/astral-sh/ruff
        ruff_fmt(),
        -- Python utility / library to sort imports alphabetically and
        -- automatically separate them into sections and by type.
        -- https://github.com/PyCQA/isort
        builtins.formatting.isort,
      }
    end,
  },

  rust = {
    fill_col_indicator = { type = "rust", limit = "101" },
    treesitter_grammars = { "rust", "toml" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "rust_analyzer",
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            buildScripts = { enable = true },
            features = "all",
          },
          imports = {
            granularity = { group = "module" },
            prefix = "self",
          },
          procMacro = {
            enable = true,
            attributes = { enable = true },
          },
        },
      },
    },
    none_ls_sources = function()
      local none_ls = require("plugins.nullls").require_module.none_ls()
      local builtins = none_ls.builtins
      return {
        -- [[ Formatting ]]
        -- A tool for formatting rust code according to style guidelines.
        require("plugins.nullls").require_module.none_ls_formatting_rustfmt(),
      }
    end,
  },

  sql = {
    fill_col_indicator = { type = "sql", limit = "81" },
    treesitter_grammars = { "sql" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      local none_ls = require("plugins.nullls").require_module.none_ls()
      local builtins = none_ls.builtins
      return {
        -- [[ Diagnostics ]]
        -- A SQL linter and auto-formatter for Humans
        -- https://github.com/sqlfluff/sqlfluff
        builtins.diagnostics.sqlfluff.with {
          extra_args = { "--dialect", "postgres" },
        },

        -- [[ Formatting ]]
        -- A SQL linter and auto-formatter for Humans
        -- https://github.com/sqlfluff/sqlfluff
        builtins.formatting.sqlfluff.with {
          extra_args = { "--dialect", "postgres" },
        },
      }
    end,
  },

  terraform = {
    fill_col_indicator = { type = "terraform", limit = "81" },
    treesitter_grammars = { "terraform" },
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  text = {
    fill_col_indicator = { type = "text", limit = "81" },
    treesitter_grammars = {},
    telescope_file_ignore_patterns = {},
    lsp_settings = {},
    none_ls_sources = function()
      return {}
    end,
  },

  typescript = {
    fill_col_indicator = { type = "typescript", limit = "81" },
    treesitter_grammars = {
      "tsx",
      "typescript",
    },
    telescope_file_ignore_patterns = {},
    lsp_settings = {
      server_name = "ts_ls",
      settings = {},
    },
    none_ls_sources = function()
      local none_ls = require("plugins.nullls").require_module.none_ls()
      local builtins = none_ls.builtins
      return {
        -- [[ Code Actions ]]
        -- Injects actions to fix ESLint issues or ignore broken rules.
        require("plugins.nullls").require_module.none_ls_code_actions_eslint(),

        -- [[ Diagnostics ]]
        -- A linter for the JavaScript ecosystem.
        require("plugins.nullls").require_module.none_ls_diagnostics_eslint(),
        -- Parses diagnostics from the TypeScript compiler.
        -- builtins.diagnostics.tsc,

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

-- [[ none-ls sources ]]
M.none_ls_sources = function()
  local none_ls_sources = {}
  for _, lang in pairs(langs) do
    utils.table.append_values(none_ls_sources, lang.none_ls_sources())
  end
  return none_ls_sources
end

return M
