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
local colorschemeName = "monokai-pro"

-- [[ Install and configure plugins via lazy.nvim ]]
-- https://github.com/folke/lazy.nvim
require("lazy").setup(
  -- [[ Plugins ]]
  {
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
        require(colorschemeName).setup {
          filter = "spectrum",
        }
        vim.cmd.colorscheme(colorschemeName)

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

    -- [[ Git releated signs for the gutter + utilities for managing changes ]]
    -- https://github.com/lewis6991/gitsigns.nvim
    {
      "lewis6991/gitsigns.nvim",
      lazy = true,
      ft = { "gitcommit", "diff" },
      init = function()
        -- Load gitsigns only when a git file is opened
        vim.api.nvim_create_autocmd(
          { "BufRead" },
          {
            group = vim.api.nvim_create_augroup(
              "GitSignsLazyLoad",
              { clear = true }
            ),
            callback = function()
              vim.fn.system(
                "git -C "
                  .. "\""
                  .. vim.fn.expand("%:p:h")
                  .. "\""
                  .. " rev-parse"
              )
              if vim.v.shell_error == 0 then
                vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                vim.schedule(
                  function()
                    require("lazy").load { plugins = { "gitsigns.nvim" } }
                  end
                )
              end
            end,
          }
        )
      end,
      config = function()
        require("gitsigns").setup {
          signs = {
            add = {
              hl = "DiffAdd",
              text = "│",
              numhl = "GitSignsAddNr",
            },
            change = {
              hl = "DiffChange",
              text = "│",
              numhl = "GitSignsChangeNr",
            },
            delete = {
              hl = "DiffDelete",
              text = "󰍵",
              numhl = "GitSignsDeleteNr",
            },
            topdelete = {
              hl = "DiffDelete",
              text = "‾",
              numhl = "GitSignsDeleteNr",
            },
            changedelete = {
              hl = "DiffChangeDelete",
              text = "~",
              numhl = "GitSignsChangeNr",
            },
            untracked = {
              hl = "GitSignsAdd",
              text = "│",
              numhl = "GitSignsAddNr",
              linehl = "GitSignsAddLn",
            },
          },
        }
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
            exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
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
            adaptive_size = false,
            side = "left",
            width = 40,
            preserve_window_proportions = true,
          },
          git = {
            enable = false,
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

    ----------------------------------------------------------------------------
    -- NOTE: From kickstart
    ----------------------------------------------------------------------------
    -- [[ Telescope - fuzzy finder (files, lsp, etc) ]]
    -- https://github.com/nvim-telescope/telescope.nvim
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
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
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
              horizontal = {
                prompt_position = "top",
                preview_width = 0.6,
                results_width = 0.4,
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
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            mappings = {
              n = { ["q"] = require("telescope.actions").close },
            },
          },
        }

        vim.keymap.set(
          "n",
          "<leader>?",
          require("telescope.builtin").oldfiles,
          { desc = "[?] Find recently opened files" }
        )
        vim.keymap.set(
          "n",
          "<leader><space>",
          require("telescope.builtin").buffers,
          { desc = "[ ] Find existing buffers" }
        )
        vim.keymap.set(
          "n",
          "<leader>/",
          function()
            require("telescope.builtin").current_buffer_fuzzy_find(
              require("telescope.themes").get_dropdown {
                previewer = true,
              }
            )
          end,
          { desc = "[/] Fuzzily search in current buffer" }
        )
        vim.keymap.set(
          "n",
          "<leader>gf",
          require("telescope.builtin").git_files,
          { desc = "Search [G]it [F]iles" }
        )
        vim.keymap.set(
          "n",
          "<leader>sf",
          require("telescope.builtin").find_files,
          { desc = "[S]earch [F]iles" }
        )
        vim.keymap.set(
          "n",
          "<leader>sh",
          require("telescope.builtin").help_tags,
          { desc = "[S]earch [H]elp" }
        )
        vim.keymap.set(
          "n",
          "<leader>sw",
          require("telescope.builtin").grep_string,
          { desc = "[S]earch current [W]ord" }
        )
        vim.keymap.set(
          "n",
          "<leader>sg",
          require("telescope.builtin").live_grep,
          { desc = "[S]earch by [G]rep" }
        )
        vim.keymap.set(
          "n",
          "<leader>sd",
          require("telescope.builtin").diagnostics,
          { desc = "[S]earch [D]iagnostics" }
        )

        -- TODO: they also do the following in LSP setup
        -- nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        -- nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        -- nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
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
        return vim.fn.executable "make" == 1
      end,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },

    -- [[ Statusline ]]
    -- https://github.com/nvim-lualine/lualine.nvim
    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup {
          options = {
            icons_enabled = true,
            theme = colorschemeName,
            component_separators = "|",
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = {
              { "mode", separator = { left = "" }, right_padding = 2 },
            },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = {},
            lualine_y = { "filetype", "progress" },
            lualine_z = {
              { 'location', separator = { right = '' }, left_padding = 2 },
            },
          },
          inactive_sections = {
            lualine_a = { "filename" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "location" }
          },
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
