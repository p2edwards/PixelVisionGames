string.rpad = function(str, len, char)
  if char == nil then char = ' ' end
  return str .. string.rep(char, len - #str)
end

string.lpad = function(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

table.indexOf = function( t, object )
  if "table" == type( t ) then
    for i = 1, #t do
      if object == t[i] then
        return i
      end
    end
    return - 1
  else
    error("table.indexOf expects table for first argument, " .. type(t) .. " given")
  end
end

function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"'..k..'"' end
      s = s .. '['..k..'] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end
