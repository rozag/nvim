-- Inserts all items from table items into table tbl.
local tbl_insert_all = function(tbl, items)
  for _, item in ipairs(items) do
    table.insert(tbl, item)
  end
end

-- [[ Install lazy.nvim package manager ]]
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Name of colorscheme to reuse in several places ]]
local colorscheme_name = "monokai-pro"

-- TODO: extract on attach and formatting group
local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})
-- This function gets run when an LSP connects to a particular buffer.
local lsp_on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
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
  -- [[ Sort of stdlib ]]
  -- https://github.com/nvim-lua/plenary.nvim
  "nvim-lua/plenary.nvim",

  -- [[ tree-sitter ]]
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
        ensure_installed = {
          "bash",
          "c",
          "clojure",
          "cmake",
          "commonlisp",
          "cpp",
          "css",
          "cuda",
          "dart",
          "diff",
          "dockerfile",
          "elixir",
          "elm",
          "erlang",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "glsl",
          "go",
          "gomod",
          "gosum",
          "gowork",
          "graphql",
          "html",
          "htmldjango",
          "http",
          "ini",
          "java",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "json5",
          "jsonc",
          "kotlin",
          "latex",
          "lua",
          "luadoc",
          "luap",
          "luau",
          "make",
          "markdown",
          "ninja",
          "nix",
          "norg",
          "ocaml",
          "proto",
          "python",
          "racket",
          "regex",
          "ruby",
          "rust",
          "scala",
          "scheme",
          "scss",
          "smali",
          "solidity",
          "sql",
          "starlark",
          "swift",
          "terraform",
          "toml",
          "tsx",
          "typescript",
          "verilog",
          "vim",
          "vimdoc",
          "wgsl",
          "yaml",
          "zig",
        },
        sync_install = true,
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
        refactor = {
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grr",
            },
          },
        },
      }
    end,
  },

  -- [[ Colorscheme ]]
  -- https://github.com/loctvl842/monokai-pro.nvim
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require(colorscheme_name).setup {
        filter = "spectrum",
      }
      vim.cmd.colorscheme(colorscheme_name)

      -- Column limit indicator appearance, have to do it after colorscheme.
      vim.cmd("highlight ColorColumn ctermbg=0 guibg=#353435")
    end,
  },

  -- [[ Comments: `gcc` & `gc` while in visual ]]
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- [[ Surround: `yse"` & `cs"b` ]]
  -- https://github.com/kylechui/nvim-surround
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- [[ Indentation guides ]]
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        indentLine_enabled = 1,
        filetype_exclude = {
          "help",
          "terminal",
          "lazy",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "nvdash",
          "nvcheatsheet",
          "",
        },
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = false,
      }
    end,
  },

  -- [[ Preview for color literals, highlights #123456 strings ]]
  -- https://github.com/NvChad/nvim-colorizer.lua
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      local colorizer = require("colorizer")
      colorizer.setup()
      colorizer.attach_to_buffer(0)
    end,
  },

  -- [[ Show pending keybindings ]]
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- [[ Fancy icons , , , etc. ]]
  -- https://github.com/nvim-tree/nvim-web-devicons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  -- [[ File managing, picker etc. ]]
  -- https://github.com/nvim-tree/nvim-tree.lua
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup {
        filters = {
          dotfiles = false,
          exclude = { vim.fn.stdpath("config") .. "/lua/custom" },
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        view = {
          adaptive_size = true,
          side = "left",
          preserve_window_proportions = true,
        },
        git = {
          enable = true,
          ignore = true,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
        renderer = {
          root_folder_label = false,
          highlight_git = true,
          highlight_opened_files = "all",

          indent_markers = {
            enable = false,
          },

          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },

            glyphs = {
              default = "󰈚",
              symlink = "",
              folder = {
                default = "󰉋",
                empty = "",
                empty_open = "",
                open = "",
                symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
      }
      vim.g.nvimtree_side = "left"
    end,
  },

  -- [[ Telescope - fuzzy finder (files, lsp, etc) ]]
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = colorscheme_name,
          component_separators = "|",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "NvimTree" },
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

  -- [[ Sort of a package manager ]]
  -- https://github.com/williamboman/mason.nvim
  -- Package list: https://mason-registry.dev/registry/list
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonInstallAll",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    config = function()
      require("mason").setup {
        PATH = "skip",
        ui = {
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = " 󰚌",
          },
          keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
          },
        },
        max_concurrent_installers = 10,
      }
    end,
  },

  -- [[ Stuff for Mason ]]
  -- https://github.com/williamboman/mason-lspconfig.nvim
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "gopls",  -- gopls
          "lua_ls", -- lua-language-server
          -- "pyright",       -- pyright
          -- "rust_analyzer", -- rust-analyzer
          -- "tsserver",      -- typescript-language-server
        },
      }
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

  -- [[ Snippet engine ]]
  -- https://github.com/L3MON4D3/LuaSnip
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      }

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = vim.g.vscode_snippets_path or "",
      }

      require("luasnip.loaders.from_snipmate").load()
      require("luasnip.loaders.from_snipmate").lazy_load {
        paths = vim.g.snipmate_snippets_path or "",
      }

      require("luasnip.loaders.from_lua").load()
      require("luasnip.loaders.from_lua").lazy_load {
        paths = vim.g.lua_snippets_path or "",
      }

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          local currentBuf = vim.api.nvim_get_current_buf()
          local ses = luasnip.session
          if ses.current_nodes[currentBuf] and not ses.jump_active then
            luasnip.unlink_current()
          end
        end,
      })
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
          "TelescopePrompt",
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
      "L3MON4D3/LuaSnip",
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
            require("luasnip").lsp_expand(args.body)
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
            elseif require("luasnip").expand_or_jumpable() then
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
            elseif require("luasnip").jumpable(-1) then
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
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,

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

  -- [[ Dim inactive windows ]]
  -- https://github.com/sunjon/Shade.nvim
  {
    "sunjon/Shade.nvim",
    config = function()
      require("shade").setup {
        overlay_opacity = 50,
        opacity_step = 1,
      }
    end,
  },

  -- [[ Suggestions for commands menu ]]
  -- https://github.com/gelguy/wilder.nvim
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require("wilder")
      wilder.setup {
        modes = { ":" },
        next_key = "<C-n>",
        previous_key = "<C-p>",
        accept_key = "<Tab>",
        reject_key = "<S-Tab>",
      }
      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_palette_theme {
          border = "rounded",
          max_height = "50%",
          min_height = "50%",
          prompt_position = "top",
          reverse = 0,
          highlighter = wilder.basic_highlighter(),
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
          highlights = {
            default = "WilderMenu",
            accent = wilder.make_hl("WilderAccent", "Pmenu", {
              { a = 1 },
              { a = 1 },
              -- TODO: this color should be part of colorscheme layer
              { foreground = "#fd618e" }, -- color picked from monokai-pro
            }),
          },
        })
      )
      wilder.set_option(
        "pipeline",
        wilder.cmdline_pipeline {
          fuzzy = 1,
        }
      )
    end,
  },

  -- [[ Highlight and search TODO comments ]]
  -- https://github.com/folke/todo-comments.nvim
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- TODO: A lot of custom kbd and integrations available in their doc
      require("trouble").setup {
        mode = "document_diagnostics",
      }
    end,
  },

  -- [[ Seamless tmux+nvim navigation ]]
  -- https://github.com/aserowy/tmux.nvim
  {
    "aserowy/tmux.nvim",
    config = function()
      local tmux = require("tmux")
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
      -- TODO: extract bindings
      vim.keymap.set("n", "<C-h>", tmux.move_left)
      vim.keymap.set("n", "<C-Left>", tmux.move_left)
      vim.keymap.set("n", "<C-k>", tmux.move_top)
      vim.keymap.set("n", "<C-Up>", tmux.move_top)
      vim.keymap.set("n", "<C-l>", tmux.move_right)
      vim.keymap.set("n", "<C-Right>", tmux.move_right)
      vim.keymap.set("n", "<C-j>", tmux.move_bottom)
      vim.keymap.set("n", "<C-Down>", tmux.move_bottom)
    end,
  },

  -- [[ Github Copilot ]]
  -- https://github.com/zbirenbaum/copilot.lua
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          -- TODO: extract bindings
          keymap = {
            -- NOTE: use "C-v[your key]" in insert mode to see these key codes
            accept = "<C-Down>", -- C-j
            next = "<C-Right>",  -- C-l
            prev = "<C-Left>",   -- C-h
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
        },
      }
    end,
  },
}

tbl_insert_all(plugins, require("plugins.git").lazy_defs)

-- [[ Install and configure plugins via lazy.nvim ]]
-- https://github.com/folke/lazy.nvim
require("lazy").setup(
  plugins,

  -- [[ Options ]]
  -- https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
  {
    install = { colorscheme = { colorscheme_name } },

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
