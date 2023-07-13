-- NOTE: bindings that start with ^[[ are from custom Alacritty setup for macOS

-- NOTE: use "C-v[your key]" in insert mode to see the key codes nvim receives

local nmap = function(keys, func, desc)
  vim.keymap.set(
    "n",
    keys,
    func,
    { desc = desc, noremap = true, silent = true }
  )
end

local M = {}

M.leader_key = " "

-- [[ General keybindings ]]
M.general = function()
  local which_key = require("plugins.editing").require_module.which_key()

  -- Better default experience with <Space> as leader key
  vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", {
    desc = "map <Space> to <Nop>",
    noremap = true,
    silent = true,
  })

  -- Remap for dealing with word wrap
  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", {
    desc = "go up in wrapped lines",
    noremap = true,
    silent = true,
    expr = true,
  })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", {
    desc = "go down in wrapped lines",
    noremap = true,
    silent = true,
    expr = true,
  })

  -- Map jj to <Esc> in insert mode
  vim.keymap.set("i", "jj", "<Esc>", {
    desc = "map jj to <Esc>",
    noremap = true,
    silent = true,
  })

  -- Terminal remappings
  vim.cmd("tnoremap jj <C-\\><C-n>")
  vim.cmd("tnoremap <Esc> <C-\\><C-n>")

  -- Without leader key
  nmap("^[[C-Tab", vim.cmd.bnext, "next buffer")           -- C-Tab
  nmap("^[[C-S-Tab", vim.cmd.bprevious, "previous buffer") -- C-S-Tab
  nmap("^[[M-s", vim.cmd.write, "save buffer")             -- Cmd-s
  nmap("^[[M-S-s", vim.cmd.wall, "save all buffers")       -- Cmd-S-s
  nmap("<Esc><Esc>", vim.cmd.nohlsearch, "dismiss search highlight")
  nmap("^[[M-S-z", vim.cmd.redo, "redo")                   -- Cmd-S-z
  nmap("^[[M-z", vim.cmd.undo, "undo")                     -- Cmd-z
  vim.keymap.set("i", "^[[M-z", vim.cmd.undo, {
    desc = "undo",
    noremap = true,
    silent = true,
  }) -- Cmd-z
  vim.keymap.set("i", "^[[M-S-z", vim.cmd.redo, {
    desc = "redo",
    noremap = true,
    silent = true,
  }) -- Cmd-S-z

  -- Window-related keybindings
  which_key.register { ["<leader>w"] = { name = "[w]indow" } }
  nmap("<leader>ws", vim.cmd.split, "horizontal [s]plit")
  nmap("<leader>wv", vim.cmd.vsplit, "[v]ertical split")
  nmap("<leader>wc", vim.cmd.close, "[c]lose")
  nmap("<leader>w=", function()
    vim.cmd("vertical wincmd =")
    vim.cmd("horizontal wincmd =")
  end, "[=]equalize in size")
  nmap("<leader>wh", "<C-w>h", "[h]left")
  nmap("<leader>wk", "<C-w>k", "[k]top")
  nmap("<leader>wl", "<C-w>l", "[l]right")
  nmap("<leader>wj", "<C-w>j", "[j]bottom")
  nmap("<leader>ww", "<C-w>w", "[w]cycle")

  -- Buffer-related keybindings
  which_key.register { ["<leader>b"] = { name = "[b]uffer" } }
  nmap("<leader>bn", vim.cmd.bnext, "[n]ext")
  nmap("<leader>bp", vim.cmd.bprevious, "[p]revious")
  nmap("<leader>bN", vim.cmd.enew, "[N]ew")
  nmap("<leader>bc", vim.cmd.bdelete, "[c]lose")
  nmap("<leader>bs", vim.cmd.write, "[s]ave")
  nmap("<leader>bS", vim.cmd.wall, "[S]ave all")

  -- Open commands
  which_key.register { ["<leader>o"] = { name = "[o]pen" } }
  nmap("<leader>ot", vim.cmd.terminal, "[t]erminal")
  nmap("<leader>oh", vim.cmd.checkhealth, "check[h]ealth")

  -- Open commands
  which_key.register { ["<leader>s"] = { name = "Tele[s]cope" } }

  -- TODO: use for format
  -- - { key: L, mods: Command, chars: "^[[M-l" }

  -- TODO: use for comments
  -- - { key: Slash, mods: Command, chars: "^[[M-/" }

  -- TODO: general keybindings
end

-- [[ Plugin-specific keybindings ]]
M.plugins = {
  copilot = {
    accept = "<C-Down>", -- C-j
    next = "<C-Right>",  -- C-l
    prev = "<C-Left>",   -- C-h
    dismiss = "<C-]>",
  },

  lazy = function()
    nmap("<leader>ol", function()
      vim.cmd(require("plugins.lazy").cmd)
    end, "[l]azy plugin manager")
  end,

  mason = function()
    nmap("<leader>om", function()
      vim.cmd(require("plugins.mason").cmd)
    end, "[m]ason package manager")
  end,

  telescope = {
    mappings = function()
      local telescope = require("plugins.telescope")
      local actions = telescope.require_module.telescope_actions()

      local trouble =
          require("plugins.trouble").require_module.trouble_telescope()
      local editing = require("plugins.editing")

      return {
        -- Normal mode
        n = {
          ["^[[A-c"] = actions.delete_buffer,
          ["^[[A-h"] = editing.cmd_which_key_telescope,
          ["^[[A-q"] = actions.close,
          ["^[[M-Return"] = trouble.open_with_trouble,
        },
        -- Insert mode
        i = {
          ["^[[A-c"] = actions.delete_buffer,
          ["^[[A-h"] = editing.cmd_which_key_telescope,
          ["^[[A-q"] = actions.close,
          ["^[[M-Return"] = trouble.open_with_trouble,
        },
      }
    end,

    core = function()
      local telescope = require("plugins.telescope")
      local builtin = telescope.require_module.telescope_builtin()
      local themes = telescope.require_module.telescope_themes()

      nmap("<leader>os", function()
        vim.cmd(require("plugins.telescope").cmd)
      end, "Tele[s]cope")

      nmap("<leader><space>", builtin.git_files, "Find git file")
      nmap("<leader>,", builtin.buffers, "Find existing buffer")
      nmap("<leader>b/", function()
        builtin.current_buffer_fuzzy_find(themes.get_dropdown {
          previewer = true,
        })
      end, "[/]search in current buffer")
      nmap("<leader>/", builtin.live_grep, "[/]grep in project")

      nmap("<leader>sr", builtin.oldfiles, "[r]ecent files")
      nmap("<leader>sh", builtin.help_tags, "[h]elp")
      nmap("<leader>sw", builtin.grep_string, "current [w]ord")
    end,

    lsp_on_attach = function()
      -- TODO: work on this section, need more sane mappings
      local telescope = require("plugins.telescope")
      local builtin = telescope.require_module.telescope_builtin()
      nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
      nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    end,
  },

  tmux = function()
    local tmux = require("plugins.tmux").require_module.tmux()
    nmap("<C-h>", tmux.move_left, "move to window on the left")
    nmap("<C-Left>", tmux.move_left, "move to window on the left")
    nmap("<C-k>", tmux.move_top, "move to window on the top")
    nmap("<C-Up>", tmux.move_top, "move to window on the top")
    nmap("<C-l>", tmux.move_right, "move to window on the right")
    nmap("<C-Right>", tmux.move_right, "move to window on the right")
    nmap("<C-j>", tmux.move_bottom, "move to window on the bottom")
    nmap("<C-Down>", tmux.move_bottom, "move to window on the bottom")
  end,

  tree = function()
    local function open_tree()
      local api = require("plugins.tree").require_module.nvim_tree_api()
      if api.tree.is_tree_buf() then
        api.tree.toggle()
      else
        api.tree.focus()
      end
    end
    nmap("<leader>of", open_tree, "[f]ile tree")
    nmap("^[[A-1", open_tree, "file tree")
  end,

  treesitter = {
    incremental_selection_keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
    },
    textobjects = {
      selection_keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
      move_keymaps = {
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap_keymaps = {
        -- TODO: move these from leader to somewhere else
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
    refactor_keymaps = {
      smart_rename = "grr",
    },
  },

  trouble = function()
    local trouble = require("plugins.trouble")
    nmap("<leader>or", function()
      vim.cmd(trouble.cmd_toggle)
    end, "T[r]ouble")
    nmap("<leader>od", function()
      vim.cmd(trouble.cmd_doc_diagnostics)
    end, "Trouble [d]iagnostics")
  end,

  wilder = {
    next_key = "<C-n>",
    previous_key = "<C-p>",
    accept_key = "<Tab>",
    reject_key = "<S-Tab>",
  },
}

return M
