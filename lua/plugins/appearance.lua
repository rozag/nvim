local utils = require("utils")

local M = {}

M.ids = {
  devicons = "nvim-tree/nvim-web-devicons",
  vimade = "tadaa/vimade",
  todo_comments = "folke/todo-comments.nvim",
  indent_blankline = "lukas-reineke/indent-blankline.nvim",
  rainbow = "HiPhish/rainbow-delimiters.nvim",
}

M.require_module = {
  devicons = function()
    return require("nvim-web-devicons")
  end,
  todo_comments = function()
    return require("todo-comments")
  end,
  indent_blankline = function()
    return require("ibl")
  end,
  rainbow_setup = function()
    return require("rainbow-delimiters.setup")
  end,
}

M.cmd_todo_telescope = "TodoTelescope"
M.cmd_todo_trouble = "TodoTrouble"

M.lazy_defs = {
  -- [[ Fancy icons , , , etc. ]]
  -- https://github.com/nvim-tree/nvim-web-devicons
  {
    M.ids.devicons,
    config = function()
      M.require_module.devicons().setup()
    end,
  },

  -- [[ Vimade helps you maintain focus on the active part of the screen ]]
  -- https://github.com/TaDaa/vimade
  {
    M.ids.vimade,
    opts = {
      ncmode = "windows",
      fadelevel = 0.7,
    },
  },

  -- [[ Highlight and search TODO comments ]]
  -- https://github.com/folke/todo-comments.nvim
  {
    M.ids.todo_comments,
    dependencies = { require("plugins.stdlib").ids.plenary },
    config = function()
      M.require_module.todo_comments().setup {
        highlight = {
          before = "",
          keyword = "bg",
          after = "fg",
        },
      }
      require("kbd").plugins.todo_comments()
    end,
  },

  -- [[ Indentation guides ]]
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  {
    M.ids.indent_blankline,
    main = "ibl",
    config = function()
      local filetype_exclude = {
        "checkhealth",
        "help",
        "lspinfo",
        "man",
        "terminal",
        "",
      }
      utils.table.append_values(
        filetype_exclude,
        require("plugins.dashboard").filetypes
      )
      utils.table.append_values(
        filetype_exclude,
        require("plugins.lazy").filetypes
      )
      utils.table.append_values(
        filetype_exclude,
        require("plugins.telescope").filetypes
      )
      utils.table.append_values(
        filetype_exclude,
        require("plugins.tree").filetypes
      )
      M.require_module.indent_blankline().setup {
        enabled = true,
        exclude = {
          filetypes = filetype_exclude,
          buftypes = { "terminal" },
        },
        scope = {
          enabled = false,
        },
      }
    end,
  },

  -- [[ Rainbow delimiters for Neovim with Tree-sitter ]]
  -- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
  {
    M.ids.rainbow,
    setup = function()
      M.require_module.rainbow_setup().setup {}
    end,
  },
}

return M
