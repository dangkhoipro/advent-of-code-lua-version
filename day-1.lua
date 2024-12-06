local utils = require('./utils')
local lines = utils.lines_from("tests/day-1.txt")

local first_half = {}
local second_half = {}

for k,line in pairs(lines) do
  local index = 0
  for num in string.gmatch(line, "[^%s]+") do
    if index % 2 == 0 then
      table.insert(first_half, num)
    else
      table.insert(second_half, num)
    end
    index = index + 1
  end
end

table.sort(first_half)
table.sort(second_half)

local sum = 0

for i = 1, #first_half do
  sum = sum + math.abs(first_half[i] - second_half[i])
end
print(sum)

-- calculate similarity score
local function count_occurrence(num, arr)
  local count = 0

  for key, value in pairs(arr) do
    if value == num then
      count = count + 1
    end
  end

  return count
end

local similarity_sum = 0

for key, value in pairs(first_half) do
  similarity_sum = similarity_sum + value * count_occurrence(value, second_half)
end
P(similarity_sum)
