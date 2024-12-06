local utils = require('./utils')
local lines = utils.lines_from("day-2.txt")

-- lines
--[[
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
]]--

-- get data
local data = {}

for col = 1, #lines, 1 do
  local index = 1
  for num in string.gmatch(lines[col], "[^%s]+") do
    if data[col] == nil then
      data[col] = {}
    end
    data[col][index] = tonumber(num)
    index = index + 1
  end
end


local function is_safe(input)
  if #input < 2 then
    return false
  end

  local increasing = input[1] < input[2]

  for i = 2, #input, 1 do
    local diff = input[i] - input[i - 1]

    if increasing then
      if diff < 1 or diff > 3 then
        return false
      end
    else
      if diff > -1 or diff < -3 then
        return false
      end
    end
  end

  return true
end

-- remove left|right item, check if it is save -> return
local function is_safe_after_remove(input, pos1, pos2, pos3)
  local input1 = utils.deepcopy(input)
  table.remove(input1, pos1)
  if is_safe(input1) then
    return true
  end

  local input2 = utils.deepcopy(input)
  table.remove(input2, pos2)
  if is_safe(input2) then
    return true
  end

  local input3 = utils.deepcopy(input)
  table.remove(input3, pos3)
  if is_safe(input3) then
    return true
  end

  return false
end

local function is_safe_dampener(input)
  -- check table length
  if #input < 2 then
    return false
  end

  local increasing = input[1] < input[2]

  for i = 2, #input, 1 do
    -- check distance
    local diff = input[i] - input[i - 1]
    local i2 = (i - 2 > 0) and i - 2 or i

    if increasing then
      if diff < 1 or diff > 3 then
        return is_safe_after_remove(input, i - 1, i, i2)
      end
    else
      if diff > -1 or diff < -3 then
        return is_safe_after_remove(input, i - 1, i, i2)
      end
    end
  end

  return true
end

-- process data
local count = 0
local count_damper = 0
for col = 1, #data, 1 do
  local line = data[col]
  local safe = is_safe(line)
  local safe_damper = is_safe_dampener(line)

  if safe then
    count = count + 1
  end

  if safe or safe_damper then
    count_damper = count_damper + 1
  end
end

print(count)
print(count_damper)

