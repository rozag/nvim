local M = {}

M.ids = {
  surround = "kylechui/nvim-surround",
  which_key = "folke/which-key.nvim",
  comment = "numToStr/Comment.nvim",
  conjure = "Olical/conjure",
  cmp_conjure = "PaterJason/cmp-conjure",
  paredit = "julienvincent/nvim-paredit",
  mini_splitjoin = "echasnovski/mini.splitjoin",
}

M.require_module = {
  surround = function()
    return require("nvim-surround")
  end,
  which_key = function()
    return require("which-key")
  end,
  comment = function()
    return require("Comment")
  end,
  conjure = function()
    return require("conjure")
  end,
  paredit = function()
    return require("nvim-paredit")
  end,
  mini_splitjoin = function()
    return require("mini.splitjoin")
  end,
}

M.cmd_which_key_telescope = "which_key"

M.lazy_defs = {
  -- [[ Surround: `yse"` & `cs"b` ]]
  -- https://github.com/kylechui/nvim-surround
  {
    M.ids.surround,
    config = function()
      M.require_module.surround().setup()
    end,
  },

  -- [[ Show pending keybindings ]]
  -- https://github.com/folke/which-key.nvim
  {
    M.ids.which_key,
    config = function()
      M.require_module.which_key().setup {
        icons = {
          group = "  ",
        },
      }
    end,
  },

  -- [[ Comments: `gcc` & `gc` while in visual ]]
  -- https://github.com/numToStr/Comment.nvim
  {
    M.ids.comment,
    config = function()
      M.require_module.comment().setup()
      require("kbd").plugins.comment()
    end,
  },

  -- [[ Interactive evaluation for Neovim (Clojure, etc.) ]]
  -- https://github.com/Olical/conjure
  {
    M.ids.conjure,
    ft = { "clojure", "fennel", "python" },
    lazy = true,
    dependencies = { M.ids.cmp_conjure },
    init = function()
      vim.g["conjure#filetypes"] = { "clojure", "fennel", "python" }
      vim.g["conjure#log#wrap"] = true
      vim.g["conjure#mapping#doc_word"] = "gk"
    end,
  },

  -- [[ nvim-cmp source for conjure ]]
  -- https://github.com/PaterJason/cmp-conjure
  {
    M.ids.cmp_conjure,
    lazy = true,
    config = function()
      local cmp = require("plugins.completion").require_module.cmp()
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure" })
      return cmp.setup(config)
    end,
  },

  -- [[ A Paredit implementation for Neovim ]]
  -- https://github.com/julienvincent/nvim-paredit
  {
    M.ids.paredit,
    ft = { "clojure", "fennel", "scheme", "lisp" },
    lazy = true,
    config = function()
      M.require_module.paredit().setup()
    end,
  },

  -- [[ Split and join arguments ]]
  -- https://github.com/echasnovski/mini.splitjoin
  {
    M.ids.mini_splitjoin,
    config = function()
      local splitjoin = M.require_module.mini_splitjoin()
      splitjoin.setup {
        mappings = require("kbd").plugins.mini_splitjoin,
        split = {
          hooks_post = {
            splitjoin.gen_hook.add_trailing_separator(),
          },
        },
        join = {
          hooks_post = {
            splitjoin.gen_hook.del_trailing_separator(),
          },
        },
      }
    end,
  },
}

return M
