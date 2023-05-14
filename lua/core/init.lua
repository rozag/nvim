--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------

-- TODO

--------------------------------------------------------------------------------
-- General options
--------------------------------------------------------------------------------

-- Disable some default providers to suppress :checkhealth warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Set <Space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- TODO: set some options from kickstart.nvim and NvChad/lua/core/init.lua

-- Highlight on search; <C-l> clears highlight
vim.o.hlsearch = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- -- Enable mouse mode
-- vim.o.mouse = 'a'

-- -- Sync clipboard between OS and Neovim.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- -- Enable break indent
-- vim.o.breakindent = true

-- -- Save undo history
-- vim.o.undofile = true

-- -- Case insensitive searching UNLESS /C or capital in search
-- vim.o.ignorecase = true
-- vim.o.smartcase = true

-- -- Keep signcolumn on by default
-- vim.wo.signcolumn = 'yes'

-- -- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeout = true
-- vim.o.timeoutlen = 300

-- -- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menuone,noselect'

-- -- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true

-- -- [[ Basic Keymaps ]]

-- -- Keymaps for better default experience
-- -- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- -- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

------------------------------------------------------- FROM NV CHAD
-- opt.laststatus = 3 -- global statusline
-- opt.showmode = false

-- opt.clipboard = "unnamedplus"
-- opt.cursorline = true

-- -- Indenting
-- opt.expandtab = true
-- opt.shiftwidth = 2
-- opt.smartindent = true
-- opt.tabstop = 2
-- opt.softtabstop = 2

-- opt.fillchars = { eob = " " }
-- opt.ignorecase = true
-- opt.smartcase = true
-- opt.mouse = "a"

-- -- disable nvim intro
-- opt.shortmess:append "sI"

-- opt.signcolumn = "yes"
-- opt.splitbelow = true
-- opt.splitright = true
-- opt.termguicolors = true
-- opt.timeoutlen = 400
-- opt.undofile = true

-- -- interval for writing swap file to disk, also used by gitsigns
-- opt.updatetime = 250

-- -- go to previous/next line with h,l,left arrow and right arrow
-- -- when cursor reaches end/beginning of line
-- opt.whichwrap:append "<>[]hl"
