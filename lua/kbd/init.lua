local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

-- TODO: extract plugin access
local wk = require("which-key")

local M = {}

-- [[ General keybindings ]]
M.general = function()
  -- Window-related keybindings
  wk.register { ["<leader>w"] = { name = "+window" } }
  nmap("<leader>ws", vim.cmd.split, "[w]indow [s]plit")
  nmap("<leader>wv", vim.cmd.vsplit, "[w]indow [v]ertical split")
  nmap("<leader>wk", vim.cmd.close, "[w]indow [k]ill")
  nmap("<leader>w=", function()
    vim.cmd("vertical wincmd =")
    vim.cmd("horizontal wincmd =")
  end, "[w]indows [=] equalize size")

  -- TODO: general keybindings
end

-- [[ Plugin-specific keybindings ]]
M.plugins = {} -- TODO: plugin-specific keybindings

return M
