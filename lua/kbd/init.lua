local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

-- TODO: extract plugin access
local wk = require("which-key")

local M = {}

-- [[ General keybindings ]]
M.general = function()
  -- Map <Esc> to exit terminal mode
  vim.cmd("tnoremap <Esc> <C-\\><C-n>")

  -- Without leader key
  nmap("^[[C-Tab", vim.cmd.bnext, "next buffer") -- C-Tab
  nmap("^[[C-S-Tab", vim.cmd.bprevious, "previous buffer") -- C-S-Tab
  nmap("^[[M-s", vim.cmd.write, "save buffer") -- Cmd-s
  nmap("^[[M-S-s", vim.cmd.wall, "save all buffers") -- Cmd-S-s
  nmap("^[[M-z", vim.cmd.undo, "undo") -- Cmd-z
  nmap("^[[M-S-z", vim.cmd.redo, "redo") -- Cmd-S-z
  nmap("<Esc><Esc>", vim.cmd.nohlsearch, "dismiss search highlight")

  -- Window-related keybindings
  wk.register { ["<leader>w"] = { name = "+window" } }
  nmap("<leader>ws", vim.cmd.split, "[w]indow [s]plit")
  nmap("<leader>wv", vim.cmd.vsplit, "[w]indow [v]ertical split")
  nmap("<leader>wk", vim.cmd.close, "[w]indow [k]ill")
  nmap("<leader>w=", function()
    vim.cmd("vertical wincmd =")
    vim.cmd("horizontal wincmd =")
  end, "[w]indows [=]equalize in size")

  -- Buffer-related keybindings
  wk.register { ["<leader>b"] = { name = "+buffer" } }
  nmap("<leader>bn", vim.cmd.bnext, "[b]uffer [n]ext")
  nmap("<leader>bp", vim.cmd.bprevious, "[b]uffer [p]revious")
  nmap("<leader>bn", vim.cmd.enew, "[b]uffer [n]ew")
  nmap("<leader>bk", vim.cmd.bdelete, "[b]uffer [k]ill")
  nmap("<leader>bs", vim.cmd.write, "[b]uffer [s]ave")
  nmap("<leader>bS", vim.cmd.wall, "[b]uffer [S]ave all")

  -- TODO: use for format
  -- - { key: L, mods: Command, chars: "^[[M-l" }

  -- TODO: use for comments
  -- - { key: Slash, mods: Command, chars: "^[[M-/" }

  -- TODO: use for tree
  -- - { key: Key1, mods: Option, chars: "^[[A-1" }

  -- TODO: general keybindings
end

-- [[ Plugin-specific keybindings ]]
M.plugins = {} -- TODO: plugin-specific keybindings

return M
