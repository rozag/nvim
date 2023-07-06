-- [[ Core keybindings, options, and autocommands ]]
require("core")

-- [[ 3rd-party plugins and their configurations ]]
local lazy = require("plugins.lazy")
lazy.install()
lazy.setup()

-- [[ All the keybindings ]]
require("kbd").general()
