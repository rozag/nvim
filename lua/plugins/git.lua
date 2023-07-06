local function substring_after_last(str, delim)
  return string.match(str, ".*" .. delim .. "(.*)")
end

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
                plugins = { substring_after_last(M.ids.gitsigns, "/") },
              }
            end)
          end
        end,
      })
    end,
    config = function()
      M.require_module.gitsigns().setup {
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

  -- [[ Inline git blame ]]
  -- https://github.com/f-person/git-blame.nvim
  {
    M.ids.gitblame,
    config = function()
      vim.g.gitblame_date_format = "%Y-%m-%d"
      vim.g.gitblame_message_template =
      "    󰊢 <author> • <date> • <summary> "
      vim.g.gitblame_message_when_not_committed = "    󰊢 Not Committed Yet "
      vim.g.gitblame_delay = 500
      vim.g.gitblame_display_virtual_text = 1
      vim.g.gitblame_enabled = 1
      vim.g.gitblame_set_extmark_options = { hl_mode = "combine" }
    end,
  },
}

return M
