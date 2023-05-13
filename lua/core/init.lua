local globals = vim.g
local options = vim.opt

-- Disable ruby and perl providers to suppress :checkhealth warnings
globals["loaded_ruby_provider"] = 0
globals["loaded_perl_provider"] = 0

-- Set <space> as the leader key
globals.mapleader = ' '
globals.maplocalleader = ' '

-- TODO: set some options from kickstart.nvim and NvChad/lua/core/init.lua
