local utils = require("utils")

local M = {}

M.ids = {
  lsp_progress = "linrongbin16/lsp-progress.nvim",
  lualine = "nvim-lualine/lualine.nvim",
}

M.require_module = {
  lsp_progress = function()
    return require("lsp-progress")
  end,
  lualine = function()
    return require("lualine")
  end,
}

M.lazy_defs = {
  -- [[ LSP progress indicator ]]
  -- https://github.com/linrongbin16/lsp-progress.nvim
  {
    M.ids.lsp_progress,
    event = { "VimEnter" },
    dependencies = { require("plugins.appearance").ids.devicons },
    config = function()
      M.require_module.lsp_progress().setup {
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
    M.ids.lualine,
    event = { "VimEnter" },
    dependencies = {
      require("plugins.appearance").ids.devicons,
      M.ids.lsp_progress,
    },
    config = function()
      local disabled_filetypes = {}
      utils.table.append_values(
        disabled_filetypes,
        require("plugins.tree").filetypes
      )

      M.require_module.lualine().setup {
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
            M.require_module.lsp_progress().progress,
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
      vim.cmd([[
        augroup lualine_augroup
          autocmd!
          autocmd User LspProgressStatusUpdated
          \ lua require("plugins.statusline").require_module.lualine().refresh()
        augroup END
      ]])
    end,
  },
}

return M
