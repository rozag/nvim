local utils = require("utils")

local M = {}

M.ids = {
  cmp = "hrsh7th/nvim-cmp",
  cmp_luasnip = "saadparwaiz1/cmp_luasnip",
  cmp_nvim_lua = "hrsh7th/cmp-nvim-lua",
  cmp_nvim_lsp = "hrsh7th/cmp-nvim-lsp",
  cmp_buffer = "hrsh7th/cmp-buffer",
  cmp_path = "hrsh7th/cmp-path",

  autopairs = "windwp/nvim-autopairs",

  luasnip = "L3MON4D3/LuaSnip",
}

M.require_module = {
  cmp = function()
    return require("cmp")
  end,
  cmp_nvim_lsp = function()
    return require("cmp_nvim_lsp")
  end,

  autopairs = function()
    return require("nvim-autopairs")
  end,
  autopairs_cmp = function()
    return require("nvim-autopairs.completion.cmp")
  end,

  luasnip = function()
    return require("luasnip")
  end,
}

M.toggle_cmp_enabled = function()
  vim.g.custom_cmp_disabled = not vim.g.custom_cmp_disabled
end

M.lazy_defs = {
  -- [[ Completions ]]
  -- https://github.com/hrsh7th/nvim-cmp
  {
    M.ids.cmp,
    event = "InsertEnter",
    dependencies = {
      M.ids.luasnip,
      M.ids.autopairs,
      M.ids.cmp_luasnip,
      M.ids.cmp_nvim_lua,
      M.ids.cmp_nvim_lsp,
      M.ids.cmp_buffer,
      M.ids.cmp_path,
    },
    config = function()
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      local cmp = M.require_module.cmp()
      local luasnip = M.require_module.luasnip()
      local kbd_cmp = require("kbd").plugins.cmp
      cmp.setup {
        enabled = function()
          local disabled = false
          disabled = disabled
            or (
              vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt"
            )
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          disabled = disabled
            or require("cmp.config.context").in_treesitter_capture("comment")
          disabled = disabled or vim.g.custom_cmp_disabled
          return not disabled
        end,
        completion = {
          completeopt = "menu,menuone",
        },
        window = {
          completion = {
            side_padding = 1,
            winhighlight = "Normal:CmpPmenu,Search:PmenuSel",
            scrollbar = false,
            border = border("CmpBorder"),
          },
          documentation = {
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          [kbd_cmp.select_prev] = cmp.mapping.select_prev_item(),
          [kbd_cmp.select_next] = cmp.mapping.select_next_item(),
          [kbd_cmp.scroll_docs_up] = cmp.mapping.scroll_docs(-4),
          [kbd_cmp.scroll_docs_down] = cmp.mapping.scroll_docs(4),
          [kbd_cmp.toggle_cmp] = cmp.mapping.complete(),
          [kbd_cmp.close] = cmp.mapping.close(),
          [kbd_cmp.confirm] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },
          [kbd_cmp.snippet_expand_or_jump.key] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                  "<Plug>luasnip-expand-or-jump",
                  true,
                  true,
                  true
                ),
                ""
              )
            else
              fallback()
            end
          end, kbd_cmp.snippet_expand_or_jump.modes),
          [kbd_cmp.snippet_jump_back.key] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                  "<Plug>luasnip-jump-prev",
                  true,
                  true,
                  true
                ),
                ""
              )
            else
              fallback()
            end
          end, kbd_cmp.snippet_jump_back.modes),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            -- Wrapped in a function to shut lint up
            function(entry1, entry2)
              return cmp.config.compare.recently_used(entry1, entry2)
            end,

            -- From https://github.com/lukas-reineke/cmp-under-comparator
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
    end,
  },

  -- [[ Autopairing of (){}[], etc. ]]
  -- https://github.com/windwp/nvim-autopairs
  {
    M.ids.autopairs,
    config = function()
      local disable_filetype = { "vim" }
      utils.table.append_values(
        disable_filetype,
        require("plugins.telescope").filetypes
      )

      local autopairs = M.require_module.autopairs()
      autopairs.setup {
        check_ts = true,
        enable_check_bracket_line = false,
        disable_filetype = disable_filetype,
      }
      autopairs.get_rules("'")[1].not_filetypes = {
        "scheme",
        "lisp",
        "clojure",
      }

      local autopairs_cmp = M.require_module.autopairs_cmp()
      local cmp = M.require_module.cmp()
      cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done())
    end,
  },

  -- [[ Snippet engine ]]
  -- https://github.com/L3MON4D3/LuaSnip
  {
    M.ids.luasnip,
    version = "1.*",
    build = "make install_jsregexp",
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
