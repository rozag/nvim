-- Disable some default providers to suppress :checkhealth warnings
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Highlight on search; <C-l> clears highlight
vim.opt.hlsearch = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent: every wrapped line will continue visually indented (same
-- amount of space as the beginning of that line), thus preserving horizontal
-- blocks of text.
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 250

-- This option and "timeoutlen" determine the behavior when part of a mapped key
-- sequence has been received. For example, if <C-f> is pressed and "timeout" is
-- set, Nvim will wait "timeoutlen" milliseconds for any key that can follow
-- <C-f> in a mapping.
vim.opt.timeout = true
vim.opt.timeoutlen = 400

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"

-- Enables 24-bit RGB color in the TUI
vim.opt.termguicolors = true

-- If in Insert, Replace or Visual mode put a message on the last line.
vim.opt.showmode = false

-- Highlight the text line of the cursor with
vim.opt.cursorline = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Characters to fill the statuslines, vertical separators and special lines in
-- the window
vim.opt.fillchars = { eob = " " }

-- This option helps to avoid all the |hit-enter| prompts caused by file
-- messages, for example  with CTRL-G, and to avoid some other messages.
-- s:
-- don't give "search hit BOTTOM, continuing at TOP" or "search hit TOP,
-- continuing at BOTTOM" messages; when using the search count do not show "W"
-- after the count message (see S below).
-- I:
-- don't give the intro message when starting Vim.
vim.opt.shortmess:append("sI")

-- When on, splitting a window will put the new window below the current one.
vim.opt.splitbelow = true

-- When on, splitting a window will put the new window right of the current one.
vim.opt.splitright = true

-- Go to previous/next line with h,l,left arrow and right arrow when cursor
-- reaches end/beginning of line.
vim.opt.whichwrap:append("<>[]hl")

-- Wildmenu kbd
vim.cmd("set wildchar=<C-n>")

-- Some space around the cursor while scrolling
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
