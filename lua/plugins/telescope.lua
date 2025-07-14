local M = {}

M.ids = {
  telescope = "nvim-telescope/telescope.nvim",
  telescope_fzf = "nvim-telescope/telescope-fzf-native.nvim",
  telescope_file_browser = "nvim-telescope/telescope-file-browser.nvim",
}

M.require_module = {
  telescope = function()
    return require("telescope")
  end,
  telescope_actions = function()
    return require("telescope.actions")
  end,
  telescope_builtin = function()
    return require("telescope.builtin")
  end,
  telescope_previewers = function()
    return require("telescope.previewers")
  end,
  telescope_themes = function()
    return require("telescope.themes")
  end,
}

M.filetypes = {
  "TelescopePrompt",
  "TelescopeResults",
}

M.cmd = "Telescope"
M.cmd_file_browser_current =
  "Telescope file_browser path=%:p:h select_buffer=true"
M.cmd_file_browser_root = "Telescope file_browser"

M.lazy_defs = {
  -- [[ Telescope - fuzzy finder (files, lsp, etc) ]]
  -- https://github.com/nvim-telescope/telescope.nvim
  {
    M.ids.telescope,
    branch = "0.1.x",
    dependencies = { require("plugins.stdlib").ids.plenary },
    config = function()
      local telescope = M.require_module.telescope()
      local previewers = M.require_module.telescope_previewers()

      local utils = require("utils")
      local kbd = require("kbd")

      local file_ignore_patterns = {}
      utils.table.append_values(
        file_ignore_patterns,
        require("plugins.langs").telescope_file_ignore_patterns
      )

      telescope.setup {
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
            "--no-ignore",
            "--hidden",
            "--glob",
            "!**/.git/**",
            "--glob",
            "!**/go.sum",
            "--glob",
            "!**/.terraform/**",
            "--glob",
            "!**/.cpcache/**",
            "--glob",
            "!**/.lsp/**",
            "--glob",
            "!**/.clj-kondo/.cache/**",
            "--glob",
            "!**/.clj-kondo/imports/**",
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
          file_ignore_patterns = file_ignore_patterns,
          path_display = { "truncate" },
          winblend = 0,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          buffer_previewer_maker = previewers.buffer_previewer_maker,
          mappings = kbd.plugins.telescope.mappings(),
        },
        extensions = {
          file_browser = {
            grouped = true,
            hidden = {
              file_browser = true,
              folder_browser = true,
            },
            respect_gitignore = false,
            follow_symlinks = true,
          },
        },
      }

      kbd.plugins.telescope.core()
    end,
  },

  -- [[ Fuzzy Finder Algorithm ]]
  -- Requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    M.ids.telescope_fzf,
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
    config = function()
      M.require_module.telescope().load_extension("fzf")
    end,
  },

  {
    M.ids.telescope_file_browser,
    dependencies = {
      M.ids.telescope,
      require("plugins.stdlib").ids.plenary,
    },
    config = function()
      M.require_module.telescope().load_extension("file_browser")
    end,
  },
}

return M
