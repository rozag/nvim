local M = {}

M.ids = {
  lspconfig = "neovim/nvim-lspconfig",
  neodev = "folke/neodev.nvim",
}

M.require_module = {
  lspconfig = function()
    return require("lspconfig")
  end,
  neodev = function()
    return require("neodev")
  end,
}

M.cmd_format = "Format"

local formatting_group = vim.api.nvim_create_augroup("LspFormatting", {})

-- This function gets run when an LSP connects to a particular buffer.
M.on_attach = function(client, bufnr)
  -- local function nmap(keys, func, desc)
  --   if desc then
  --     desc = "LSP: " .. desc
  --   end
  --
  --   vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  -- end

  -- TODO: review these mappings, they're from kickstart
  -- nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  -- nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- TODO: Cmd+L to run format (M.cmd_format)?

  require("kbd").plugins.telescope.lsp_on_attach()

  vim.api.nvim_buf_create_user_command(bufnr, M.cmd_format, function(_)
    vim.lsp.buf.format { async = false }
  end, { desc = "Format current buffer with LSP" })

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds { group = formatting_group, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = formatting_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end
end

M.lazy_defs = {
  -- [[ LSP configuration ]]
  -- https://github.com/neovim/nvim-lspconfig
  {
    M.ids.lspconfig,
    dependencies = {
      M.ids.neodev,
    },
    config = function()
      local lspconfig = M.require_module.lspconfig()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("plugins.completion").require_module
          .cmp_nvim_lsp()
          .default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
          },
        },
      }

      -- TODO: extract to langs?
      lspconfig["gopls"].setup {
        capabilities = capabilities,
        on_attach = M.on_attach,
        settings = {},
      }
      lspconfig["lua_ls"].setup {
        capabilities = capabilities,
        on_attach = M.on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [require("plugins.lazy").libpath] = true,
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
            telemetry = { enable = false },
          },
        },
      }
      -- lspconfig["pyright"].setup {
      --   capabilities = capabilities,
      --   on_attach = M.on_attach,
      --   settings = {},
      -- }
      -- lspconfig["rust_analyzer"].setup {
      --   capabilities = capabilities,
      --   on_attach = M.on_attach,
      --   settings = {},
      -- }
      -- lspconfig["tsserver"].setup {
      --   capabilities = capabilities,
      --   on_attach = M.on_attach,
      --   settings = {},
      -- }
    end,
  },

  -- [[ Neovim development stuff ]]
  -- https://github.com/folke/neodev.nvim
  {
    M.ids.neodev,
    config = function()
      M.require_module.neodev().setup()
    end,
  },
}

return M
