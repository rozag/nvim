-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { timeout = 300 }
  end,
})

-- [[ Don't list quickfix buffers ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- [[ Line width limit via colorcolumn ]]
-- NOTE: using column index + 1 to be an "untouchable" visual border
local fill_col_indicator_group =
  vim.api.nvim_create_augroup("FillColumnIndicator", { clear = true })
local function bind_file_type_to_fill_col_indicator_limit(type, limit)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = type,
    group = fill_col_indicator_group,
    callback = function()
      vim.opt.colorcolumn = limit
    end,
  })
end
bind_file_type_to_fill_col_indicator_limit("dart", "81")
bind_file_type_to_fill_col_indicator_limit("dockerfile", "81")
bind_file_type_to_fill_col_indicator_limit("go", "81")
bind_file_type_to_fill_col_indicator_limit("java", "141")
bind_file_type_to_fill_col_indicator_limit("kotlin", "141")
bind_file_type_to_fill_col_indicator_limit("lua", "81")
bind_file_type_to_fill_col_indicator_limit("markdown", "81")
bind_file_type_to_fill_col_indicator_limit("org", "81")
bind_file_type_to_fill_col_indicator_limit("python", "81")
bind_file_type_to_fill_col_indicator_limit("rust", "100")
bind_file_type_to_fill_col_indicator_limit("text", "81")
