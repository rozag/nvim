local M = {}

-- show LSP float markdown as-is: keep fences/markup and highlight, no conceal
local open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  local bufnr, winid = open_floating_preview(contents, syntax, opts, ...)
  vim.wo[winid].conceallevel = 0
  return bufnr, winid
end

M.ids = {
  lspconfig = "neovim/nvim-lspconfig",
  neodev = "folke/neodev.nvim",
}

M.require_module = {
  lspconfig = function()
    return require("lspconfig")
  end,
  lspconfig_configs = function()
    return require("lspconfig.configs")
  end,
  lspconfig_util = function()
    return require("lspconfig.util")
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
  kbd.plugins.lsp.lsp_on_attach(bufnr)
  kbd.plugins.telescope.lsp_on_attach()
end

M.lazy_defs = {
  -- [[ LSP configuration ]]
  -- https://github.com/neovim/nvim-lspconfig
  {
    M.ids.lspconfig,
    commit = "624088f6478f7019b873a07527d2521e771fb8ce",
    dependencies = {
      M.ids.neodev,
    },
    config = function()
      local lspconfig = M.require_module.lspconfig()
      local configs = M.require_module.lspconfig_configs()
      local util = M.require_module.lspconfig_util()

      if not configs.ty then
        configs.ty = {
          default_config = {
            cmd = { "ty", "server" },
            filetypes = { "python" },
            root_dir = util.root_pattern(
              "ty.toml",
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              ".git"
            ),
            single_file_support = true,
            settings = {},
          },
        }
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = false,
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
      local cmp_nvim_lsp =
        require("plugins.completion").require_module.cmp_nvim_lsp()
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

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
