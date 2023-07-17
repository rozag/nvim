local M = {}

M.ids = {
  luasnip = "L3MON4D3/LuaSnip",
  friendly_snippets = "rafamadriz/friendly-snippets",
}

M.require_module = {
  luasnip = function()
    return require("luasnip")
  end,
  luasnip_loaders_vscode = function()
    return require("luasnip.loaders.from_vscode")
  end,
  luasnip_loaders_snipmate = function()
    return require("luasnip.loaders.from_snipmate")
  end,
  luasnip_loaders_lua = function()
    return require("luasnip.loaders.from_lua")
  end,
}

M.nvim_cmp_source = "luasnip"

M.lazy_defs = {
  -- [[ Snippet engine ]]
  -- https://github.com/L3MON4D3/LuaSnip
  {
    M.ids.luasnip,
    version = "1.*",
    build = "make install_jsregexp",
    dependencies = {
      M.ids.friendly_snippets,
    },
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
    },
    config = function()
      local luasnip = M.require_module.luasnip()
      luasnip.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
      }

      local from_vscode = M.require_module.luasnip_loaders_vscode()
      from_vscode.lazy_load()
      from_vscode.lazy_load {
        paths = vim.g.vscode_snippets_path or "",
      }

      local from_snipmate = M.require_module.luasnip_loaders_snipmate()
      from_snipmate.load()
      from_snipmate.lazy_load {
        paths = vim.g.snipmate_snippets_path or "",
      }

      local from_lua = M.require_module.luasnip_loaders_lua()
      from_lua.load()
      from_lua.lazy_load {
        paths = vim.g.lua_snippets_path or "",
      }

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          local currentBuf = vim.api.nvim_get_current_buf()
          local ses = luasnip.session
          if ses.current_nodes[currentBuf] and not ses.jump_active then
            luasnip.unlink_current()
          end
        end,
      })
    end,
  },
}

return M
