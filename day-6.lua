local utils = require('./utils')
local lines = utils.lines_from("tests/day-6.txt")

-- NOTE: get data
local map = {}

for i, line in pairs(lines) do
  map[i] = {}
  for value in line:gmatch(".") do
    table.insert(map[i], value)
  end
end

local function get_current_position(map)
  for i, row in ipairs(map) do
    for j, val in ipairs(row) do
      if val == '^' or val == '<' or val == 'v' or val == '>' then
        return i,j
      end
    end
  end

  return nil
end

local char_to_direction = {
  ["<"] = "left",
  [">"] = "right",
  ["v"] = "down",
  ["^"] = "up",
}

local char_to_rotate = {
  ["<"] = "^",
  [">"] = "v",
  ["v"] = "<",
  ["^"] = ">",
}

local function is_at_boundary(map, x, y)
  local cur_direction = char_to_direction[map[x][y]]

  if cur_direction == "left" and y == 1 then
    return true
  end

  if cur_direction == "right" and y == #map[1] then
    return true
  end

  if cur_direction == "up" and x == 1 then
    return true
  end

  if cur_direction == "down" and x == #map then
    return true
  end
end

local function can_move_then_move(map, x, y)
  local cur_char = map[x][y]
  local cur_direction = char_to_direction[cur_char]

  if is_at_boundary(map, x, y) then
    map[x][y] = "."
    return true
  end

  if cur_direction == "left" and map[x][y - 1] == '.' then
    map[x][y] = "."
    map[x][y-1] = cur_char
    return true
  end

  if cur_direction == "right" and map[x][y + 1] == '.' then
    map[x][y] = "."
    map[x][y+1] = cur_char
    return true
  end

  if cur_direction == "up" and map[x - 1][y] == '.' then
    map[x][y] = "."
    map[x - 1][y] = cur_char
    return true
  end

  if cur_direction == "down" and map[x + 1][y] == '.' then
    map[x][y] = "."
    map[x + 1][y] = cur_char
    return true
  end

  return false
end

local function reach_obstruction(map, x, y)
  local cur_char = map[x][y]
  local cur_direction = char_to_direction[cur_char]

  if is_at_boundary(map, x, y) then
    return nil
  end

  if cur_direction == "left" and map[x][y - 1] == 'O' then
    return true
  end

  if cur_direction == "right" and map[x][y + 1] == 'O' then
    return true
  end

  if cur_direction == "up" and map[x - 1][y] == 'O' then
    return true
  end

  if cur_direction == "down" and map[x + 1][y] == 'O' then
    return true
  end

  return nil
end

-- NOTE: part 1
local visited_pos = {}
local map1 = utils.deepcopy(map, {})

repeat
  local x, y = get_current_position(map1)

  if x == nil or y == nil then
    break
  end

  visited_pos[x .. ',' .. y] = 1

  repeat
    if can_move_then_move(map1, x, y) then
      break
    end

    map1[x][y] = char_to_rotate[map1[x][y]]
  until false
until false

P(utils.get_table_length(visited_pos))

-- NOTE: part 2
local obstruction = 0
local start_x, start_y = get_current_position(map)

local function is_loop(map)
  local visited_pos_with_direction = {}

  repeat
    local x, y = get_current_position(map)

    if x == nil or y == nil then
      return false
    end

    local cur_dir = char_to_direction[map[x][y]]
    local key = x .. ',' .. y .. ',' .. cur_dir

    -- re-visit
    if visited_pos_with_direction[key] ~= nil then
      return true
    end
    visited_pos_with_direction[key] = 1

    local count = 0

    repeat
      -- rotate in circle
      if count >= 4 then
        return true
      end

      if can_move_then_move(map, x, y) then
        count = 0
        break
      end

      count = count + 1
      map[x][y] = char_to_rotate[map[x][y]]
    until false
  until false
end

local sample_pair = {
  -- ["10,102"] = 1,
  -- ["10,118"] = 1,
  -- ["10,124"] = 1,
  ["10,15"] = 1,
  ["10,29"] = 1,
  ["10,48"] = 1,
  ["10,79"] = 1,
  ["10,83"] = 1,
  ["10,105"] = 1,
  ["10,108"] = 1,
  ["10,114"] = 1,
  ["10,122"] = 1,
}
-- P(visited_pos)
for key, value in pairs(visited_pos) do
  if key ~= start_x .. ',' .. start_y then
    local temp_map = utils.deepcopy(map)
    local x, y = key:match("(%d+),(%d+)")
    temp_map[tonumber(x)][tonumber(y)] = "O"

    if is_loop(temp_map) then
      obstruction = obstruction + 1
    end
  end
end

print(obstruction)
