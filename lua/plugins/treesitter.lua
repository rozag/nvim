local kbd = require("kbd")
local utils = require("utils")

local M = {}

M.ids = {
  treesitter = "nvim-treesitter/nvim-treesitter",
  treesitter_textobjects = "nvim-treesitter/nvim-treesitter-textobjects",
}

M.require_module = {
  treesitter = function()
    return require("nvim-treesitter")
  end,
  textobjects = function()
    return require("nvim-treesitter-textobjects")
  end,
  textobjects_select = function()
    return require("nvim-treesitter-textobjects.select")
  end,
  textobjects_move = function()
    return require("nvim-treesitter-textobjects.move")
  end,
  textobjects_swap = function()
    return require("nvim-treesitter-textobjects.swap")
  end,
}

local ensure_grammars_installed = {
  "bash",
  "c",
  "cmake",
  "commonlisp",
  "cpp",
  "css",
  "cuda",
  "diff",
  "elixir",
  "elm",
  "erlang",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "glsl",
  "graphql",
  "html",
  "htmldjango",
  "http",
  "ini",
  "jq",
  "latex",
  "make",
  "ninja",
  "nix",
  "ocaml",
  "proto",
  "racket",
  "regex",
  "ruby",
  "scala",
  "scheme",
  "scss",
  "smali",
  "solidity",
  "swift",
  "vim",
  "vimdoc",
  "wgsl",
  "yaml",
  "zig",
}
utils.table.append_values(
  ensure_grammars_installed,
  require("plugins.langs").treesitter_grammars
)

M.lazy_defs = {
  -- [[ tree-sitter ]]
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    M.ids.treesitter,
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    config = function()
      M.require_module.treesitter().install(ensure_grammars_installed)

      -- parser names -> filetypes (bash -> sh, vimdoc -> help, ...)
      local filetypes = {}
      for _, lang in ipairs(ensure_grammars_installed) do
        vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function(args)
          -- pcall: install is async, so the parser may not exist yet on 1st run
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  {
    M.ids.treesitter_textobjects,
    branch = "main",
    dependencies = { M.ids.treesitter },
    init = function()
      -- keep built-in ftplugins from overriding ]m [m ]] [[ etc.
      vim.g.no_plugin_maps = true
    end,
    config = function()
      local keymaps = kbd.plugins.treesitter.textobjects

      M.require_module.textobjects().setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      local select = M.require_module.textobjects_select()
      for lhs, query in pairs(keymaps.selection_keymaps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      local move = M.require_module.textobjects_move()
      for fn, maps in pairs(keymaps.move_keymaps) do
        for lhs, query in pairs(maps) do
          vim.keymap.set({ "n", "x", "o" }, lhs, function()
            move[fn](query, "textobjects")
          end)
        end
      end

      local swap = M.require_module.textobjects_swap()
      for fn, maps in pairs(keymaps.swap_keymaps) do
        for lhs, query in pairs(maps) do
          vim.keymap.set("n", lhs, function()
            swap[fn](query)
          end)
        end
      end
    end,
  },
}

return M
