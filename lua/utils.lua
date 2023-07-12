local M = {}

M.strings = {
  -- Returns the substring after the last occurrence of delim in str.
  substring_after_last = function(str, delim)
    return string.match(str, ".*" .. delim .. "(.*)")
  end,
}

M.table = {
  -- Inserts all values from table items into table tbl.
  append_values = function(tbl, items)
    for _, value in ipairs(items) do
      table.insert(tbl, value)
    end
  end,

  -- Inserts all keys and values from table items into table tbl.
  append_keys_values = function(tbl, items)
    for key, value in pairs(items) do
      tbl[key] = value
    end
  end,
}

return M
