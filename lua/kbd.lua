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

local vmap = function(keys, func, desc)
  vim.keymap.set(
    "v",
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

  -- Swap arguments (for treesitter textobjects bindings)
  which_key.add { "gs", desc = "[s]wap" }

  -- Better default experience with <Space> as leader key
  vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", {
    desc = "map <Space> to <Nop> in normal and visual modes",
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
  nmap("^[[C-Tab", vim.cmd.bnext, "next buffer") -- C-Tab
  nmap("^[[C-S-Tab", vim.cmd.bprevious, "previous buffer") -- C-S-Tab
  nmap("^[[M-s", vim.cmd.write, "save buffer") -- Cmd-s
  nmap("^[[M-S-s", vim.cmd.wall, "save all buffers") -- Cmd-S-s
  nmap("<Esc><Esc>", vim.cmd.nohlsearch, "dismiss search highlight")
  nmap("^[[M-S-z", vim.cmd.redo, "redo") -- Cmd-S-z
  nmap("^[[M-z", vim.cmd.undo, "undo") -- Cmd-z
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
  which_key.add { "<leader>w", group = "[w]indow" }
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
  which_key.add { "<leader>b", group = "[b]uffer" }
  nmap("<leader>bn", vim.cmd.bnext, "[n]ext")
  nmap("<leader>bp", vim.cmd.bprevious, "[p]revious")
  nmap("<leader>bN", vim.cmd.enew, "[N]ew")
  nmap("<leader>bc", vim.cmd.bdelete, "[c]lose")
  nmap("<leader>bs", vim.cmd.write, "[s]ave")
  nmap("<leader>bS", vim.cmd.wall, "[S]ave all")

  -- Open commands
  which_key.add { "<leader>o", group = "[o]pen" }
  nmap("<leader>ot", vim.cmd.terminal, "[t]erminal")
  nmap("<leader>oh", vim.cmd.checkhealth, "check[h]ealth")

  -- Open commands
  which_key.add { "<leader>s", group = "Tele[s]cope" }

  -- Copilot commands
  which_key.add { "<leader>c", group = "[c]opilot" }
  which_key.add { "<leader>c", mode = "v", group = "[c]opilot" }
  which_key.add { "<leader>cc", group = "Copilot [c]hat" }
  which_key.add { "<leader>cc", mode = "v", group = "Copilot [c]hat" }

  -- Toggle commands
  which_key.add { "<leader>t", group = "[t]oggle" }
  nmap("<leader>tb", function()
    vim.cmd(require("plugins.git").cmd_toggle_gitblame)
  end, "git [b]lame")
end

-- [[ Plugin-specific keybindings ]]
M.plugins = {
  cmp = {
    select_prev = "<C-p>",
    select_next = "<C-n>",
    scroll_docs_up = "<C-d>",
    scroll_docs_down = "<C-f>",
    toggle_cmp = "<C-Right>",
    close = "<C-e>",
    confirm = "<CR>",
    snippet_expand_or_jump = {
      key = "<Tab>",
      modes = { "i", "s" },
    },
    snippet_jump_back = {
      key = "<S-Tab>",
      modes = { "i", "s" },
    },
  },

  comment = function()
    vim.keymap.set("n", "^[[M-/", function()
      return vim.api.nvim_get_vvar("count") == 0
          and "<Plug>(comment_toggle_linewise_current)"
        or "<Plug>(comment_toggle_linewise_count)"
    end, { expr = true, desc = "Comment toggle current line" })
    vim.keymap.set(
      "v",
      "^[[M-/",
      "<Plug>(comment_toggle_linewise_visual)",
      { desc = "Comment toggle linewise (visual)" }
    )
  end,

  copilot = {
    mappings = {
      accept = "<C-Down>", -- C-j
      next = "<C-Right>", -- C-l
      prev = "<C-Left>", -- C-h
      dismiss = "<C-]>",
    },
    core = function()
      local copilot = require("plugins.copilot")
      nmap("<leader>ce", function()
        vim.cmd(copilot.cmd.enable)
      end, "[e]nable Copilot")
      nmap("<leader>cd", function()
        vim.cmd(copilot.cmd.disable)
      end, "[d]isable Copilot")
      nmap("<leader>cs", function()
        vim.cmd(copilot.cmd.status)
      end, "Copilot [s]tatus")
    end,
    chat = function()
      local copilot = require("plugins.copilot")

      nmap("<leader>cco", function()
        vim.cmd(copilot.cmd.chatOpen)
      end, "[o]pen Copilot chat")
      nmap("<leader>ccc", function()
        vim.cmd(copilot.cmd.chatClose)
      end, "[c]lose Copilot chat")
      nmap("<leader>ccr", function()
        vim.cmd(copilot.cmd.chatReset)
      end, "[r]eset Copilot chat")
      nmap("<leader>cce", function()
        vim.cmd(copilot.cmd.chatExplain)
      end, "Copilot chat [e]xplain")
      nmap("<leader>ccv", function()
        vim.cmd(copilot.cmd.chatReview)
      end, "Copilot chat re[v]iew")
      nmap("<leader>ccf", function()
        vim.cmd(copilot.cmd.chatFix)
      end, "Copilot chat [f]ix")
      nmap("<leader>ccz", function()
        vim.cmd(copilot.cmd.chatOptimize)
      end, "Copilot chat optimi[z]e")
      nmap("<leader>ccd", function()
        vim.cmd(copilot.cmd.chatDocs)
      end, "Copilot chat [d]ocs")
      nmap("<leader>cct", function()
        vim.cmd(copilot.cmd.chatTests)
      end, "Copilot chat [t]ests")

      vmap("<leader>cce", function()
        vim.cmd(copilot.cmd.chatExplain)
      end, "Copilot chat [e]xplain")
      vmap("<leader>ccv", function()
        vim.cmd(copilot.cmd.chatReview)
      end, "Copilot chat re[v]iew")
      vmap("<leader>ccf", function()
        vim.cmd(copilot.cmd.chatFix)
      end, "Copilot chat [f]ix")
      vmap("<leader>ccz", function()
        vim.cmd(copilot.cmd.chatOptimize)
      end, "Copilot chat optimi[z]e")
      vmap("<leader>ccd", function()
        vim.cmd(copilot.cmd.chatDocs)
      end, "Copilot chat [d]ocs")
      vmap("<leader>cct", function()
        vim.cmd(copilot.cmd.chatTests)
      end, "Copilot chat [t]ests")
    end,
  },

  lazy = function()
    nmap("<leader>ol", function()
      vim.cmd(require("plugins.lazy").cmd)
    end, "[l]azy plugin manager")
  end,

  lsp = {
    lsp_on_attach = function(bufnr)
      local nmap_lsp = function(keys, func, desc)
        vim.keymap.set(
          "n",
          keys,
          func,
          { desc = desc, noremap = true, silent = true, buffer = bufnr }
        )
      end

      nmap_lsp("^[[M-l", function()
        vim.cmd(require("plugins.lsp").cmd_format)
      end, "format current buffer")
      nmap_lsp("gm", vim.lsp.buf.rename, "LSP rename")
      nmap_lsp("K", vim.lsp.buf.hover, "LSP hover docs")
      nmap_lsp("^[[A-S-k", vim.lsp.buf.signature_help, "LSP signature docs")
      nmap_lsp("<leader>oa", vim.lsp.buf.code_action, "LSP code [a]ction")
    end,
  },

  mason = function()
    nmap("<leader>om", function()
      vim.cmd(require("plugins.mason").cmd)
    end, "[m]ason package manager")
  end,

  telescope = {
    mappings = function()
      local actions =
        require("plugins.telescope").require_module.telescope_actions()
      local trouble =
        require("plugins.trouble").require_module.trouble_telescope()
      local editing = require("plugins.editing")
      return {
        -- Normal mode
        n = {
          ["^[[A-c"] = actions.delete_buffer,
          ["^[[M-S-h"] = editing.cmd_which_key_telescope,
          ["^[[A-q"] = actions.close,
          ["^[[M-Return"] = trouble.open,
        },
        -- Insert mode
        i = {
          ["^[[A-c"] = actions.delete_buffer,
          ["^[[M-S-h"] = editing.cmd_which_key_telescope,
          ["^[[A-q"] = actions.close,
          ["^[[M-Return"] = trouble.open,
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
      local open_file_browser_current = function()
        vim.cmd(require("plugins.telescope").cmd_file_browser_current)
      end
      nmap("<leader>sf", open_file_browser_current, "current [f]ile filetree")
      nmap("^[[A-2", open_file_browser_current, "file tree")
      nmap("<leader>sF", function()
        vim.cmd(require("plugins.telescope").cmd_file_browser_root)
      end, "[F] project root filetree")
      nmap("<leader>sh", builtin.help_tags, "[h]elp")
      nmap("<leader>sw", builtin.grep_string, "current [w]ord")
      nmap("<leader>su", builtin.resume, "res[u]me previous picker")
    end,

    lsp_on_attach = function()
      local builtin =
        require("plugins.telescope").require_module.telescope_builtin()
      nmap("gr", builtin.lsp_references, "[r]eferences")
      nmap("gd", builtin.lsp_definitions, "[d]efinition")
      nmap("gD", builtin.lsp_type_definitions, "type [D]efinition")
      nmap("gI", builtin.lsp_implementations, "[i]mplementations")
      nmap("<leader>sd", builtin.lsp_document_symbols, "[d]ocument symbols")
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

  todo_comments = function()
    nmap("<leader>sc", function()
      vim.cmd(require("plugins.appearance").cmd_todo_telescope)
    end, "TODO [c]omments")
    nmap("<leader>oc", function()
      vim.cmd(require("plugins.appearance").cmd_todo_trouble)
    end, "Trouble TODO [c]omments")
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
        swap_next = {
          ["gsn"] = "@parameter.inner",
        },
        swap_previous = {
          ["gsp"] = "@parameter.inner",
        },
      },
    },
    refactor_keymaps = {
      smart_rename = "gM",
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
    nmap("<leader>oy", function()
      vim.cmd(trouble.cmd_lsp_document_symbols)
    end, "Trouble LSP document s[y]mbols")
  end,

  wilder = {
    next_key = "<C-n>",
    previous_key = "<C-p>",
    accept_key = "<Tab>",
    reject_key = "<S-Tab>",
  },
}

return M
