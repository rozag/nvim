local kbd = require("kbd")
local lazy = require("plugins.lazy")

-- Set leader key before everything else
vim.g.mapleader = kbd.leader_key
vim.g.maplocalleader = kbd.leader_key

-- [[ Core keybindings, options, and autocommands ]]
require("core")

-- [[ 3rd-party plugins and their configurations ]]
lazy.install()
lazy.setup()

-- [[ Setup line length limit indicator for different languages ]]
require("plugins.langs").setup_fill_col_indicator()

-- [[ All the keybindings ]]
kbd.general()
