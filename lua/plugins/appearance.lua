local utils = require("utils")

local M = {}

M.ids = {
  colorizer = "NvChad/nvim-colorizer.lua",
  devicons = "nvim-tree/nvim-web-devicons",
  tint = "levouh/tint.nvim",
  todo_comments = "folke/todo-comments.nvim",
  indent_blankline = "lukas-reineke/indent-blankline.nvim",
  rainbow = "HiPhish/rainbow-delimiters.nvim",
}

M.require_module = {
  colorizer = function()
    return require("colorizer")
  end,
  devicons = function()
    return require("nvim-web-devicons")
  end,
  tint = function()
    return require("tint")
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
  -- [[ Preview for color literals, highlights #123456 strings ]]
  -- https://github.com/NvChad/nvim-colorizer.lua
  {
    M.ids.colorizer,
    config = function()
      local colorizer = M.require_module.colorizer()
      colorizer.setup {}
      colorizer.attach_to_buffer(0)
    end,
  },

  -- [[ Fancy icons , , , etc. ]]
  -- https://github.com/nvim-tree/nvim-web-devicons
  {
    M.ids.devicons,
    config = function()
      M.require_module.devicons().setup()
    end,
  },

  -- [[ Dim inactive windows ]]
  -- https://github.com/levouh/tint.nvim
  {
    M.ids.tint,
    config = function()
      M.require_module.tint().setup {
        tint = 0,
        saturation = 0.2,
        tint_background_colors = false,
        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)

          local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
          local is_terminal = buftype == "terminal"

          local filetype = vim.api.nvim_buf_get_option(bufid, "filetype")
          local is_tree = utils.table.contains_value(
            require("plugins.tree").filetypes,
            filetype
          )

          local is_floating = vim.api.nvim_win_get_config(winid).relative ~= ""

          return is_terminal or is_tree or is_floating
        end,
      }
    end,
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
        require("plugins.mason").filetypes
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
      M.require_module.rainbow_setup().setup()
    end,
  },
}

return M
