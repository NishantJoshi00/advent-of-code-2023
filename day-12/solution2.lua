-- @param line string
-- @return string
-- @return integer[]
function parse_input(line)
  local _, _, data, parity = string.find(line, "(.*) (.*)")
  local parity_list = {}
  for i in string.gmatch(parity, '([^,]+)') do
    table.insert(parity_list, tonumber(i))
  end

  return data, parity_list
end

function inspect(data, indent)
  indent = indent or 0
  local indentStr = string.rep("  ", indent)

  if type(data) == "table" then
    local output = "{\n"
    for key, value in pairs(data) do
      local keyStr = type(key) == "string" and '["' .. key .. '"]' or "[" .. tostring(key) .. "]"
      output = output .. indentStr .. "  " .. keyStr .. " = " .. inspect(value, indent + 1) .. ",\n"
    end
    return output .. indentStr .. "}"
  else
    return tostring(data)
  end
end

function solve(data, nums, cache)
  if cache == nil then
    cache = {}
  end
  local cache_key = data .. table.concat(nums, "")
  local cache_output = cache[cache_key]
  if cache_output ~= nil then
    return cache_output
  end
  if data == "" then
    if #nums == 0 then
      return 1
    else
      return 0
    end
  end

  if #nums == 0 then
    if string.find(data, "#") ~= nil then
      cache[cache_key] = 0
      return 0
    else
      cache[cache_key] = 1
      return 1
    end
  end

  local output = 0

  if string.find(string.sub(data, 1, 1), "[.?]") ~= nil then
    output = output + solve(string.sub(data, 2), nums, cache)
  end

  if string.find(string.sub(data, 1, 1), "[#?]") ~= nil then
    if ((nums[1] <= #data)
          and (string.find(string.sub(data, 1, nums[1]), "[.]") == nil)
          and (nums[1] == #data or string.sub(data, nums[1] + 1, nums[1] + 1) ~= "#")) then
      local new_table = table.list_copy(nums);
      table.remove(new_table, 1)
      output = output + solve(string.sub(data, nums[1] + 2), new_table, cache)
    end
  end
  cache[cache_key] = output
  return output
end

function merge(t1, t2)
  local output = {}
  for _, v in ipairs(t1) do
    table.insert(output, v)
  end

  for _, v in ipairs(t2) do
    table.insert(output, v)
  end
  return output
end

function repeat_data(t, count, sep)
  if type(t) == "table" then
    local output = {}
    local del = {}
    if sep ~= nil then
      del = sep
    end
    for i = 1, count do
      output = merge(merge(output, t), del)
    end
    return output
  else
    local output = t
    for i = 1, count - 1 do
      if sep ~= nil then
        output = output .. sep
      end
      output = output .. t
    end
    return output
  end
end

function table.list_copy(t)
  local output = {}
  for _, v in ipairs(t) do
    table.insert(output, v)
  end
  return output
end

local total = 0

while true do
  local line = io.read("l")
  if line == nil then break; end
  local data, parity_list = parse_input(line)
  data = repeat_data(data, 5, "?")
  parity_list = repeat_data(parity_list, 5)
  total = total + solve(data, parity_list)
end

print(total)
