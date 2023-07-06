local M = {}

-- Returns the substring after the last occurrence of delim in str.
M.substring_after_last = function(str, delim)
  return string.match(str, ".*" .. delim .. "(.*)")
end

-- Inserts all items from table items into table tbl.
M.tbl_insert_all = function(tbl, items)
  for _, item in ipairs(items) do
    table.insert(tbl, item)
  end
end

return M
