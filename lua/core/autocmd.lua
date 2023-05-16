-- Highlight on yank
vim.api.nvim_create_autocmd(
  "TextYankPost",
  {
    callback = function()
      vim.highlight.on_yank { timeout = 300 }
    end,
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
  }
)

-- Don't list quickfix buffers
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = "qf",
    callback = function()
      vim.opt_local.buflisted = false
    end,
  }
)
