-- Highlight on yank
vim.api.nvim_create_autocmd(
  "TextYankPost",
  {
    pattern = "*",
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    callback = function()
      vim.highlight.on_yank { timeout = 300 }
    end,
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

-- Line width limit via colorcolumn
local fillColumnIndicatorGroup = vim.api.nvim_create_augroup(
  "FillColumnIndicator",
  { clear = true }
)
local function bindFileTypeToFillColumnIndicatorLimit(type, limit)
  vim.api.nvim_create_autocmd(
    "FileType",
    {
      pattern = type,
      group = fillColumnIndicatorGroup,
      callback = function()
        vim.opt.colorcolumn = limit
      end,
    }
  )
end
bindFileTypeToFillColumnIndicatorLimit("dart", "80")
bindFileTypeToFillColumnIndicatorLimit("dockerfile", "80")
bindFileTypeToFillColumnIndicatorLimit("go", "80")
bindFileTypeToFillColumnIndicatorLimit("java", "140")
bindFileTypeToFillColumnIndicatorLimit("kotlin", "140")
bindFileTypeToFillColumnIndicatorLimit("lua", "80")
bindFileTypeToFillColumnIndicatorLimit("markdown", "80")
bindFileTypeToFillColumnIndicatorLimit("python", "80")
bindFileTypeToFillColumnIndicatorLimit("rust", "99")
