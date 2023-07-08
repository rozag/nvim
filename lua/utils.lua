local M = {}

M.strings = {
  -- Returns the substring after the last occurrence of delim in str.
  substring_after_last = function(str, delim)
    return string.match(str, ".*" .. delim .. "(.*)")
  end,
}

M.table = {
  -- Inserts all items from table items into table tbl.
  insert_all = function(tbl, items)
    for _, item in ipairs(items) do
      table.insert(tbl, item)
    end
  end,
}

return M
