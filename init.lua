local kbd = require("kbd")

-- [[ Set leader key before everything else ]]
vim.g.mapleader = kbd.leader_key
vim.g.maplocalleader = kbd.local_leader_key

-- [[ Core keybindings, options, and autocommands ]]
require("core")

-- [[ 3rd-party plugins and their configurations ]]
local lazy = require("plugins.lazy")
lazy.install()
lazy.setup()

-- [[ Setup line length limit indicator for different languages ]]
require("plugins.langs").setup_fill_col_indicator()

-- [[ All the keybindings ]]
kbd.general()
