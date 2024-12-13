local utils = require('./utils')
local lines = utils.lines_from("tests/day-5.txt")

-- NOTE: get data
local reqs = {}
local tests = {}
local switch_to_test = false

for i, line in pairs(lines) do
  if line == "" then
    switch_to_test = true
    goto continue
  end

  if switch_to_test == false then
    local first, second = line:match("(%d+)|(%d+)")
    reqs[i] = {first, second}
  end

  if switch_to_test == true then
    tests[#tests + 1] = {}
    for num in line:gmatch("%d+") do
      table.insert(tests[#tests], num)
    end
  end

  ::continue::
end

-- NOTE: part 1
local function is_nums_in_right_order(num1, num2, test)
  local num1_index = nil
  local num2_index = nil

  for key, num in pairs(test) do
    if num1 == num then
      num1_index = key
    end

    if num2 == num then
      num2_index = key
    end
  end

  if num1_index == nil or num2_index == nil then
    return true
  end

  return num1_index < num2_index
end

local valid_tests = {}

for _, test in pairs(tests) do
  local valid = true
  for key, req in pairs(reqs) do
    if not is_nums_in_right_order(req[1], req[2], test) then
      valid = false
      goto continue;
    end
  end
  ::continue::
  if valid then
    valid_tests[#valid_tests+1] = test
  end
end

local sum1 = 0

for key, test in pairs(valid_tests) do
  sum1 = sum1 + tonumber(test[(1 + #test)/2])
end

P(sum1)

-- NOTE: part 2

local prepared_tests = {}

for _, test in pairs(tests) do
  local valid = true
  -- loop through all req that contain tests (either left or right)
  for key, req in pairs(reqs) do
    if not is_nums_in_right_order(req[1], req[2], test) then
      valid = false
      prepared_tests[#prepared_tests+1] = test
      goto continue;
    end
  end
  ::continue::
  if valid then
    valid_tests[#valid_tests+1] = test
  end
end

local function get_index(num, tbl)
  for key, value in pairs(tbl) do
    if num == value then
      return key
    end
  end
end

for key, test in pairs(prepared_tests) do
  ::restart::
  for key, req in pairs(reqs) do
    if not is_nums_in_right_order(req[1], req[2], test) then
      local num1_index = get_index(req[1], test)
      local num2_index = get_index(req[2], test)

      test[num1_index] = req[2]
      test[num2_index] = req[1]
      goto restart
    end
  end
end

local sum2 = 0

for key, test in pairs(prepared_tests) do
  sum2 = sum2 + tonumber(test[(1 + #test)/2])
end

P(sum2)
