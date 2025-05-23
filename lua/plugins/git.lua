local utils = require("utils")

local M = {}

M.ids = {
  gitsigns = "lewis6991/gitsigns.nvim",
  gitblame = "f-person/git-blame.nvim",
}

M.require_module = {
  gitsigns = function()
    return require("gitsigns")
  end,
  gitblame = function()
    return require("gitblame")
  end,
}

M.cmd_toggle_gitblame = "GitBlameToggle"

M.none_ls_sources = function()
  local builtins = require("plugins.nullls").require_module.none_ls().builtins
  return {
    -- [[ Code actions ]]
    -- Injects code actions for Git operations at the current cursor
    -- position (stage / preview / reset hunks, blame, etc.).
    -- https://github.com/lewis6991/gitsigns.nvim
    builtins.code_actions.gitsigns,
  }
end

M.lazy_defs = {
  -- [[ Git releated signs for the gutter + utilities for managing changes ]]
  -- https://github.com/lewis6991/gitsigns.nvim
  {
    M.ids.gitsigns,
    lazy = true,
    ft = { "gitcommit", "diff" },
    init = function()
      -- Load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup(
          "GitSignsLazyLoad",
          { clear = true }
        ),
        callback = function()
          vim.fn.system(
            "git -C " .. "\"" .. vim.fn.expand("%:p:h") .. "\"" .. " rev-parse"
          )
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
            vim.schedule(function()
              require("plugins.lazy").require_module.lazy().load {
                plugins = {
                  utils.strings.substring_after_last(M.ids.gitsigns, "/"),
                },
              }
            end)
          end
        end,
      })
    end,
    config = function()
      vim.api.nvim_set_hl(0, "GitSignsAdd", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "GitSignsChange", { link = "DiffChange" })
      vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "DiffChangeDelete" })
      vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffChange" })
      vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "DiffDelete" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "DiffDelete" })
      vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })
      M.require_module.gitsigns().setup {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "󰍵" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "│" },
        },
      }
    end,
  },

  -- [[ Inline git blame ]]
  -- https://github.com/f-person/git-blame.nvim
  {
    M.ids.gitblame,
    priority = 1,
    init = function()
      vim.g.gitblame_enabled = 0
    end,
    config = function()
      vim.g.gitblame_date_format = "%Y-%m-%d"
      vim.g.gitblame_message_template =
      "    󰊢 <author> • <date> • <summary> "
      vim.g.gitblame_message_when_not_committed = "    󰊢 Not Committed Yet "
      vim.g.gitblame_delay = 500
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_set_extmark_options = { hl_mode = "combine" }
    end,
  },
}

return M
