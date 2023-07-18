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

  local kbd = require("kbd")
  kbd.plugins.lsp.lsp_on_attach()
  kbd.plugins.telescope.lsp_on_attach()
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

      local langs = require("plugins.langs")
      for server_name, settings in pairs(langs.lsp_settings) do
        lspconfig[server_name].setup {
          capabilities = capabilities,
          on_attach = M.on_attach,
          settings = settings,
        }
      end
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
