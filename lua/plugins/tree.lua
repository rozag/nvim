local M = {}

M.ids = {
  nvim_tree = "nvim-tree/nvim-tree.lua",
}

M.require_module = {
  nvim_tree = function()
    return require("nvim-tree")
  end,
  nvim_tree_api = function()
    return require("nvim-tree.api")
  end,
}

M.filetypes = {
  "NvimTree",
}

M.lazy_defs = {
  -- [[ File managing, picker etc. ]]
  -- https://github.com/nvim-tree/nvim-tree.lua
  {
    M.ids.nvim_tree,
    config = function()
      M.require_module.nvim_tree().setup {
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

      require("kbd").plugins.tree()
    end,
  },
}

return M
