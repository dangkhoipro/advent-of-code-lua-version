local utils = require('./utils')
local lines = utils.lines_from("tests/day-4.txt")

-- get data
local data = lines
local sum = 0

-- horizontal
-- vertical
-- diagonal
-- written forward
-- written backward

-- solution
-- loop through char from left to right, top to bottom (main direction)
-- if char is 'X' or 'S' -> check if next combo (from main direction) is valid 'XMAS' or 'SAMX'
-- if so -> add to sum
--
-- first: write a function to check if the combo is valid is_valid_combo
-- follow direction
-- be careful of the boundary (max col, max row)

-- second: loop through the data (main direction)
-- if char is 'X' or 'S' -> count if is_valid_combo

-- NOTE: part 1
local KEY_WORD = 'XMAS'
local KEY_WORD_REVERSED = 'SAMX'

local function get_horizontal_text(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col + 3)
end

local function get_vertical_text(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col)
    .. (data[char_row + 1] or ""):sub(char_col, char_col)
    ..  (data[char_row + 2] or ""):sub(char_col, char_col)
    .. (data[char_row + 3] or ""):sub(char_col, char_col)
end

local function get_diagonal_text_1(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col)
    .. (data[char_row + 1] or ""):sub(char_col + 1, char_col + 1)
    ..  (data[char_row + 2] or ""):sub(char_col + 2, char_col + 2)
    .. (data[char_row + 3] or ""):sub(char_col + 3, char_col + 3)
end

local function get_diagonal_text_2(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col)
    .. (data[char_row + 1] or ""):sub(char_col - 1, char_col - 1)
    ..  (data[char_row + 2] or ""):sub(char_col - 2, char_col - 2)
    .. (data[char_row + 3] or ""):sub(char_col - 3, char_col - 3)
end

local function count_valid_combo(char_row, char_col, data)
  local hori_text = get_horizontal_text(char_row, char_col, data)
  local verti_text = get_vertical_text(char_row, char_col, data)
  local diag_text_1 = get_diagonal_text_1(char_row, char_col, data)
  local diag_text_2= get_diagonal_text_2(char_row, char_col, data)

  local valid = (hori_text == KEY_WORD or hori_text == KEY_WORD_REVERSED) and 1 or 0
  local valid2 = (verti_text == KEY_WORD or verti_text == KEY_WORD_REVERSED) and 1 or 0
  local valid3 = (diag_text_1 == KEY_WORD or diag_text_1 == KEY_WORD_REVERSED) and 1 or 0
  local valid4 = (diag_text_2 == KEY_WORD or diag_text_2 == KEY_WORD_REVERSED) and 1 or 0

  return valid + valid2 + valid3 + valid4
end

for i = 1, #data, 1 do
  for j = 1, #data[i], 1 do
    local char = data[i]:sub(j, j)

    if (char == 'X' or char == 'S') then
      sum = sum + count_valid_combo(i, j, data)
    end
  end
end

print(sum)

-- NOTE: part 2
-- two MAS in the shape of X
-- -> only diagonal
-- -> diagonal at pos1 pos3
local KEY_WORD_2 = 'MAS'
local KEY_WORD_REVERSED_2 = 'SAM'

local function get_diagonal_text_2_1(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col)
    .. (data[char_row + 1] or ""):sub(char_col + 1, char_col + 1)
    ..  (data[char_row + 2] or ""):sub(char_col + 2, char_col + 2)
end

local function get_diagonal_text_2_2(char_row, char_col, data)
  return data[char_row]:sub(char_col, char_col)
    .. (data[char_row + 1] or ""):sub(char_col - 1, char_col - 1)
    ..  (data[char_row + 2] or ""):sub(char_col - 2, char_col - 2)
end

local function is_valid_combo_2(char_row, char_col, data)
  local diag_text_1 = get_diagonal_text_2_1(char_row, char_col, data)
  local diag_text_2= get_diagonal_text_2_2(char_row, char_col + 2, data)

  local valid1 = diag_text_1 == KEY_WORD_2 or diag_text_1 == KEY_WORD_REVERSED_2
  local valid2 = diag_text_2 == KEY_WORD_2 or diag_text_2 == KEY_WORD_REVERSED_2

  return valid1 and valid2
end

local sum2 = 0

for i = 1, #data, 1 do
  for j = 1, #data[i], 1 do
    local char = data[i]:sub(j, j)

    if (char == 'M' or char == 'S') and is_valid_combo_2(i, j, data) then
      sum2 = sum2 + 1
    end
  end
end

print(sum2)
