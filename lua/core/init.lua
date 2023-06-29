-- Set <Space> as the leader key before everything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ General options ]]
require("core.opt")

-- [[ Autocommands ]]
require("core.autocmd")
