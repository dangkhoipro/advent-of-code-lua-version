local utils = require('./utils')
local lines = utils.lines_from("tests/day-3.txt")

-- get data
local data = lines[1]
local sum = 0

-- NOTE: part 1
for num1, num2 in string.gmatch(data, "mul%((%d+),(%d+)%)") do
  sum = sum + tonumber(num1)*tonumber(num2)
end
print(sum)

-- NOTE: part 2
local function add_data_from_pattern(s, pattern, all_data, all_index)
  local condition = true
  local start_post, end_post = 1, 1

  while condition do
    start_post, end_post = s:find(pattern, start_post)

    if start_post == nil then
      condition = false
    else
      all_data[start_post] = s:sub(start_post, end_post)
      table.insert(all_index, start_post)

      -- increase cur_post to find next position
      start_post = start_post + 1
    end
  end

  return all_data
end

local all_data = {}
local all_index = {}
add_data_from_pattern(data, "do%(%)", all_data, all_index)
add_data_from_pattern(data, "don't%(%)", all_data, all_index)
add_data_from_pattern(data, "mul%((%d+),(%d+)%)", all_data, all_index)

-- sort index
table.sort(all_index)

local sum2 = 0
local enabled = true

for _, key in pairs(all_index) do
  local value = all_data[key]

  if value == "do()" then
    enabled = true
    goto continue
  end
  if value == "don't()" then
    enabled = false
    goto continue
  end

  if enabled then
    local num1, num2 = string.match(value, "mul%((%d+),(%d+)%)")
    sum2 = sum2 + tonumber(num1)*tonumber(num2)
  end

  ::continue::
end
print(sum2)


-- try to print data
-- sum data
