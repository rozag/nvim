-- [[ Highlight on yank ]]
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

-- [[ Don't list quickfix buffers ]]
vim.api.nvim_create_autocmd(
  "FileType",
  {
    pattern = "qf",
    callback = function()
      vim.opt_local.buflisted = false
    end,
  }
)

-- [[ Line width limit via colorcolumn ]]
-- NOTE: using column index + 1 to be an "untouchable" visual border
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
bindFileTypeToFillColumnIndicatorLimit("dart", "81")
bindFileTypeToFillColumnIndicatorLimit("dockerfile", "81")
bindFileTypeToFillColumnIndicatorLimit("go", "81")
bindFileTypeToFillColumnIndicatorLimit("java", "141")
bindFileTypeToFillColumnIndicatorLimit("kotlin", "141")
bindFileTypeToFillColumnIndicatorLimit("lua", "81")
bindFileTypeToFillColumnIndicatorLimit("markdown", "81")
bindFileTypeToFillColumnIndicatorLimit("org", "81")
bindFileTypeToFillColumnIndicatorLimit("python", "81")
bindFileTypeToFillColumnIndicatorLimit("rust", "100")
