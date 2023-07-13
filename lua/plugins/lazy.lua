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
  local function nmap(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  -- TODO: review these mappings, they're from kickstart
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  local telescope_builtin = require("telescope.builtin")
  nmap("gr", telescope_builtin.lsp_references, "[G]oto [R]eferences")
  nmap(
    "<leader>ds",
    telescope_builtin.lsp_document_symbols,
    "[D]ocument [S]ymbols"
  )
  -- TODO: remap or smth b/c of conflict
  -- nmap(
  --   "<leader>ws",
  --   telescope_builtin.lsp_dynamic_workspace_symbols,
  --   "[W]orkspace [S]ymbols"
  -- )
  -- nmap(
  --   "<leader>wa",
  --   vim.lsp.buf.add_workspace_folder,
  --   "[W]orkspace [A]dd Folder"
  -- )
  -- nmap(
  --   "<leader>wr",
  --   vim.lsp.buf.remove_workspace_folder,
  --   "[W]orkspace [R]emove Folder"
  -- )
  -- nmap("<leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, "[W]orkspace [L]ist Folders")

  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

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
  -- [[ Comments: `gcc` & `gc` while in visual ]]
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- [[ Indentation guides ]]
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local filetype_exclude = {
        "checkhealth",
        "help",
        "lspinfo",
        "man",
        "terminal",
        "",
        "TelescopePrompt", -- TODO: extract filetypes
        "TelescopeResults", -- TODO: extract filetypes
      }
      utils.table.append_values(
        filetype_exclude,
        require("plugins.lazy").filetypes
      )
      utils.table.append_values(
        filetype_exclude,
        require("plugins.mason").filetypes
      )
      utils.table.append_values(
        filetype_exclude,
        require("plugins.tree").filetypes
      )
      require("indent_blankline").setup {
        indentLine_enabled = 1,
        filetype_exclude = filetype_exclude,
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = false,
      }
    end,
  },

  -- [[ Telescope - fuzzy finder (files, lsp, etc) ]]
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { require("plugins.stdlib").ids.plenary },
    config = function()
      -- TODO: SPC-o-???? -> :Telescope - might be useful raw
      local previewers = require("telescope.previewers")
      local actions = require("telescope.actions")
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.5,
              results_width = 0.5,
            },
            vertical = {
              mirror = true,
            },
            width = 0.90,
            height = 0.90,
            preview_cutoff = 120,
          },
          file_ignore_patterns = {
            "node_modules",
            "vendor", -- TODO: these could be part of lang specific layer
          },
          path_display = { "truncate" },
          winblend = 0,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          buffer_previewer_maker = previewers.buffer_previewer_maker,
          mappings = {
            n = {
              ["q"] = actions.close,
              ["bk"] = actions.delete_buffer,
            }, -- n
            i = {
              -- TODO: think about smth else here, these two conflict w/ tmux
              ["<C-k>"] = actions.delete_buffer,
              ["<C-h>"] = "which_key",
            },
          },
        },
      }

      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n",
        "<leader>?",
        builtin.oldfiles,
        { desc = "[?] Find recently opened files" }
      )
      vim.keymap.set(
        "n",
        "<leader><space>",
        builtin.buffers,
        { desc = "[ ] Find existing buffers" }
      )
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown {
            previewer = true,
          }
        )
      end, { desc = "[/] Fuzzily search in current buffer" })
      vim.keymap.set(
        "n",
        "<leader>gf",
        builtin.git_files,
        { desc = "Search [G]it [F]iles" }
      )
      vim.keymap.set(
        "n",
        "<leader>sf",
        builtin.find_files,
        { desc = "[S]earch [F]iles" }
      )
      vim.keymap.set(
        "n",
        "<leader>sh",
        builtin.help_tags,
        { desc = "[S]earch [H]elp" }
      )
      vim.keymap.set(
        "n",
        "<leader>sw",
        builtin.grep_string,
        { desc = "[S]earch current [W]ord" }
      )
      vim.keymap.set(
        "n",
        "<leader>sg",
        builtin.live_grep,
        { desc = "[S]earch by [G]rep" }
      )
      vim.keymap.set(
        "n",
        "<leader>sd",
        builtin.diagnostics,
        { desc = "[S]earch [D]iagnostics" }
      )
    end,
  },

  -- [[ Fuzzy Finder Algorithm ]]
  -- Requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- [[ LSP progress indicator ]]
  -- https://github.com/linrongbin16/lsp-progress.nvim
  {
    "linrongbin16/lsp-progress.nvim",
    event = { "VimEnter" },
    dependencies = { require("plugins.appearance").ids.devicons },
    config = function()
      require("lsp-progress").setup {
        max_size = 40,
        client_format = function(client_name, spinner, series_messages)
          return #series_messages > 0 and (client_name .. " " .. spinner) or nil
        end,
        format = function(client_messages)
          return #client_messages > 0 and (table.concat(client_messages, " "))
            or ""
        end,
      }
    end,
  },

  -- [[ Statusline ]]
  -- https://github.com/nvim-lualine/lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    event = { "VimEnter" },
    dependencies = {
      require("plugins.appearance").ids.devicons,
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      local disabled_filetypes = {}
      utils.table.append_values(
        disabled_filetypes,
        require("plugins.tree").filetypes
      )

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = require("plugins.colorscheme").name,
          component_separators = "|",
          section_separators = { left = "", right = "" },
          disabled_filetypes = disabled_filetypes,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              separator = { left = " ", right = "" },
              padding = 1,
            },
          },
          lualine_b = { "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            require("lsp-progress").progress,
          },
          lualine_y = { "filetype", "progress" },
          lualine_z = {
            {
              "location",
              separator = { left = "", right = " " },
              padding = 0,
            },
          },
        },
        inactive_sections = {
          lualine_a = {
            { "filename", path = 1 },
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
      }
      vim.cmd(
        "\naugroup lualine_augroup"
          .. "\n  autocmd!"
          .. "\n  autocmd User LspProgressStatusUpdated lua "
          .. "require('lualine').refresh()"
          .. "\naugroup END"
      )
    end,
  },

  -- [[ Neovim development stuff ]]
  -- https://github.com/folke/neodev.nvim
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup()
    end,
  },

  -- [[ Autopairing of (){}[], etc. ]]
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        fast_wrap = {},
        disable_filetype = {
          "TelescopePrompt", -- TODO: extract file type
          "vim",
        },
      }

      local autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", autopairs.on_confirm_done())
    end,
  },

  -- [[ Completions ]]
  -- https://github.com/hrsh7th/nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      require("plugins.snippets").ids.luasnip,
      "windwp/nvim-autopairs",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      local cmp = require("cmp")
      local luasnip = require("plugins.snippets").require_module.luasnip()
      cmp.setup {
        completion = {
          completeopt = "menu,menuone",
        },
        window = {
          completion = {
            side_padding = 1,
            winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
            scrollbar = false,
            border = border("CmpBorder"),
          },
          documentation = {
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                  "<Plug>luasnip-expand-or-jump",
                  true,
                  true,
                  true
                ),
                ""
              )
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                  "<Plug>luasnip-jump-prev",
                  true,
                  true,
                  true
                ),
                ""
              )
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = require("plugins.snippets").nvim_cmp_source },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- Wrapped in a function to shut lint up
            function(entry1, entry2)
              return cmp.config.compare.recently_used(entry1, entry2)
            end,

            -- From https://github.com/lukas-reineke/cmp-under-comparator
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
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
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
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

  -- [[ LSP improvements ]]
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

  -- [[ Highlight and search TODO comments ]]
  -- https://github.com/folke/todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    dependencies = { require("plugins.stdlib").ids.plenary },
    config = function()
      -- TODO: keybindings for TodoQuickFix and TodoTelescope (TodoTrouble?)
      require("todo-comments").setup {
        highlight = {
          before = "",
          keyword = "bg",
          after = "fg",
        },
      }
    end,
  },

  -- [[ Trouble: a panel for diagnostics, refs, etc. ]]
  -- https://github.com/folke/trouble.nvim
  {
    "folke/trouble.nvim",
    dependencies = { require("plugins.appearance").ids.devicons },
    config = function()
      -- TODO: A lot of custom kbd and integrations available in their doc
      -- TODO: how to send results from telescope to trouble?
      require("trouble").setup {
        mode = "document_diagnostics",
      }
    end,
  },
}

M.setup = function()
  utils.table.append_values(plugins, require("plugins.appearance").lazy_defs)
  utils.table.append_values(plugins, require("plugins.cmdmenu").lazy_defs)
  utils.table.append_values(plugins, require("plugins.colorscheme").lazy_defs)
  utils.table.append_values(plugins, require("plugins.copilot").lazy_defs)
  utils.table.append_values(plugins, require("plugins.editing").lazy_defs)
  utils.table.append_values(plugins, require("plugins.git").lazy_defs)
  utils.table.append_values(plugins, require("plugins.mason").lazy_defs)
  utils.table.append_values(plugins, require("plugins.snippets").lazy_defs)
  utils.table.append_values(plugins, require("plugins.stdlib").lazy_defs)
  utils.table.append_values(plugins, require("plugins.tmux").lazy_defs)
  utils.table.append_values(plugins, require("plugins.tree").lazy_defs)
  utils.table.append_values(plugins, require("plugins.treesitter").lazy_defs)

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
end

return M
