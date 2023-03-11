
--[[
  Utility function to split strings into tokens.
  Source: http://lua-users.org/wiki/SplitJoin
]]
function string.split(str, sep)
    local s, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", s)
    _ = str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string.trim(str)
    -- source: http://lua-users.org/wiki/StringTrim
    local from = str:match"^%s*()"
    return from > #str and "" or str:match(".*%S", from)
end

function string.isNilOrEmpty(str)
    return str == nil or string.trim(str) == ''
end