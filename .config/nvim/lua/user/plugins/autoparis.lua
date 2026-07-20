local M = {}

M.opts = {
  disable_filetype = { "spectre_panel" },
  disable_in_macro = true,
  disable_in_replace_mode = true,
  disable_in_visualblock = false,
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  break_undo = true,
  enable_moveright = true,
  enable_check_bracket_line = true,
  enable_bracket_in_quote = true,
  map_bs = true,
  map_cr = true,
}

local api = vim.api

-- ============================================================
-- Utils
-- ============================================================

local Utils = {}

Utils.key = {
  del = "<del>",
  bs = "<bs>",
  left = "<left>",
  right = "<right>",
  join_left = "<c-g>U<left>",
  join_right = "<c-g>U<right>",
  undo_sequence = "<c-g>u",
}

Utils.is_quote = function(char)
  return char == "'" or char == '"' or char == "`"
end

Utils.is_bracket = function(char)
  return char == "(" or char == "[" or char == "{" or char == "<"
end

Utils.is_close_bracket = function(char)
  return char == ")" or char == "]" or char == "}" or char == ">"
end

Utils.compare = function(value, text)
  return text == value
end

Utils.is_in_quotes = function(line, pos, quote_type)
  local cIndex = 0
  local result = false
  local last_char = quote_type or ""
  while cIndex < string.len(line) and cIndex < pos do
    cIndex = cIndex + 1
    local char = line:sub(cIndex, cIndex)
    local prev_char = line:sub(cIndex - 1, cIndex - 1)
    if result == true and char == last_char and prev_char ~= "\\" then
      result = false
      last_char = quote_type or ""
    elseif
      result == false
      and Utils.is_quote(char)
      and (not quote_type or char == quote_type)
      and not (char == "'" and prev_char:match("%w"))
    then
      last_char = quote_type or char
      result = true
    end
  end
  return result
end

Utils.text_sub_char = function(line, start, num)
  local finish = start
  if num < 0 then
    start = start + num + 1
  else
    finish = start + num - 1
  end
  if start + finish < 0 then
    return ""
  end
  return string.sub(line, start, finish)
end

Utils.text_cusor_line = function(line, col, prev_count, next_count)
  local prev = Utils.text_sub_char(line, col, -prev_count)
  local next = Utils.text_sub_char(line, col + 1, next_count)
  return prev, next
end

Utils.repeat_key = function(key, num)
  local text = ""
  for _ = 1, num, 1 do
    text = text .. key
  end
  return text
end

Utils.esc = function(cmd)
  return api.nvim_replace_termcodes(cmd, true, false, true)
end

Utils.text_get_current_line = function()
  local row = api.nvim_win_get_cursor(0)[1]
  return api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""
end

Utils.get_cursor_col = function()
  return api.nvim_win_get_cursor(0)[2]
end

-- ============================================================
-- Cond
-- ============================================================

local Cond = {}

Cond.not_after_regex = function(regex, length)
  length = length or 1
  return function(opts)
    local str = Utils.text_sub_char(opts.line, opts.col, length or #opts.line)
    if str:match(regex) then
      return false
    end
  end
end

local function count_bracket_char(line, prev_char, next_char)
  local count_prev, count_next = 0, 0
  for i = 1, #line, 1 do
    local c = line:sub(i, i)
    if c == prev_char then
      count_prev = count_prev + 1
    elseif c == next_char then
      count_next = count_next + 1
    end
  end
  return count_prev, count_next
end

local function is_brackets_balanced_around_position(line, open_char, close_char, col)
  local balance = 0
  for i = 1, #line, 1 do
    local c = line:sub(i, i)
    if c == open_char then
      balance = balance + 1
    elseif balance > 0 and c == close_char then
      balance = balance - 1
      if col <= i and balance == 0 then
        break
      end
    end
  end
  return balance == 0
end

Cond.is_bracket_line = function()
  return function(opts)
    if
      Utils.is_bracket(opts.char)
      and (opts.next_char == opts.rule.end_pair or opts.next_char == opts.rule.start_pair)
    then
      local count_prev, count_next = count_bracket_char(opts.line, opts.rule.start_pair, opts.rule.end_pair)
      if count_prev ~= count_next then
        return false
      end
    end
  end
end

Cond.is_bracket_line_move = function()
  return function(opts)
    if Utils.is_close_bracket(opts.char) and opts.char == opts.rule.end_pair then
      return is_brackets_balanced_around_position(opts.line, opts.rule.start_pair, opts.char, opts.col)
    end
  end
end

Cond.not_add_quote_inside_quote = function()
  return function(opts)
    if Utils.is_quote(opts.char) and Utils.is_in_quotes(opts.text, opts.col - 1) then
      return false
    end
  end
end

Cond.move_right = function()
  return function(opts)
    if opts.next_char == opts.char then
      if Utils.is_close_bracket(opts.char) then
        return
      end
      if Utils.is_quote(opts.char) then
        if opts.col == string.len(opts.line) then
          return
        end
        if Utils.is_in_quotes(opts.line, opts.col - 1, opts.char) then
          return
        end
      end
    end
    return false
  end
end

Cond.is_bracket_in_quote = function()
  return function(opts)
    if
      Utils.is_bracket(opts.char)
      and Utils.is_quote(opts.next_char)
      and Utils.is_in_quotes(opts.line, opts.col - 1, opts.next_char)
    then
      return true
    end
  end
end

-- ============================================================
-- Rule
-- ============================================================

local Rule = {}
Rule.__index = Rule

function Rule.new(start_pair, end_pair)
  return setmetatable({
    start_pair = start_pair,
    end_pair = end_pair,
    is_undo = M.opts.break_undo,
    pair_cond = {},
    move_cond = {},
    del_cond = {},
    cr_cond = {},
  }, Rule)
end

function Rule:with_move(cond)
  table.insert(self.move_cond, cond)
  return self
end

function Rule:with_pair(cond, pos)
  if pos then
    table.insert(self.pair_cond, pos, cond)
  else
    table.insert(self.pair_cond, cond)
  end
  return self
end

local function can_do(conds, opt)
  for _, cond in ipairs(conds) do
    local result = cond(opt)
    if result ~= nil then
      return result
    end
  end
  return true
end

function Rule:can_pair(opt)
  return can_do(self.pair_cond, opt)
end
function Rule:can_move(opt)
  return can_do(self.move_cond, opt)
end
function Rule:can_del(opt)
  return can_do(self.del_cond, opt)
end
function Rule:can_cr(opt)
  return can_do(self.cr_cond, opt)
end

-- ============================================================
-- Rules setup
-- ============================================================

local function build_rule(open, close, is_bracket_rule)
  local rule = Rule.new(open, close)
  rule:with_move(Cond.move_right())
  rule:with_pair(Cond.not_add_quote_inside_quote())
  if #M.opts.ignored_next_char > 1 then
    rule:with_pair(Cond.not_after_regex(M.opts.ignored_next_char))
  end
  if is_bracket_rule then
    if M.opts.enable_check_bracket_line then
      rule:with_pair(Cond.is_bracket_line())
      rule:with_move(Cond.is_bracket_line_move())
    end
    if M.opts.enable_bracket_in_quote then
      rule:with_pair(Cond.is_bracket_in_quote(), 1)
    end
  end
  return rule
end

local rules = {}

local function build_rules()
  rules = {
    build_rule("(", ")", true),
    build_rule("[", "]", true),
    build_rule("{", "}", true),
    build_rule("'", "'", false),
    build_rule('"', '"', false),
    build_rule("`", "`", false),
  }
end

-- ============================================================
-- Core
-- ============================================================

local function is_disabled()
  if vim.tbl_contains(M.opts.disable_filetype, vim.bo.filetype) then
    return true
  end
  if vim.bo.modifiable == false then
    return true
  end
  if M.opts.disable_in_macro and (vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "") then
    return true
  end
  if M.opts.disable_in_replace_mode and api.nvim_get_mode().mode == "R" then
    return true
  end
  if M.opts.disable_in_visualblock and vim.fn.visualmode() == "\22" then
    return true
  end
  if vim.v.count > 0 then
    return true
  end
  return false
end

function M.autopairs_map(char)
  if is_disabled() then
    return char
  end
  local line = Utils.text_get_current_line()
  local col = Utils.get_cursor_col()

  for _, rule in ipairs(rules) do
    local new_text = line:sub(1, col) .. char .. line:sub(col + 1, #line)
    local prev_char, next_char = Utils.text_cusor_line(new_text, col + 1, #rule.start_pair, #rule.end_pair)
    local cond_opt = {
      rule = rule,
      char = char,
      line = line,
      text = new_text,
      col = col + 1,
      prev_char = prev_char,
      next_char = next_char,
    }

    if rule.end_pair == char and Utils.compare(rule.end_pair, next_char) and rule:can_move(cond_opt) then
      return Utils.esc(Utils.repeat_key(Utils.key.join_right, #rule.end_pair))
    end

    if rule.start_pair == char and Utils.compare(rule.start_pair, prev_char) and rule:can_pair(cond_opt) then
      local move_text = Utils.repeat_key(Utils.key.join_left, #rule.end_pair)
      local result = char .. rule.end_pair .. Utils.esc(move_text)
      if rule.is_undo then
        result = Utils.esc(Utils.key.undo_sequence) .. result .. Utils.esc(Utils.key.undo_sequence)
      end
      return result
    end
  end

  return char
end

function M.autopairs_bs()
  if is_disabled() then
    return Utils.esc("<bs>")
  end
  local line = Utils.text_get_current_line()
  local col = Utils.get_cursor_col()

  for _, rule in ipairs(rules) do
    local prev_char, next_char = Utils.text_cusor_line(line, col, #rule.start_pair, #rule.end_pair)
    if
      Utils.compare(rule.start_pair, prev_char)
      and Utils.compare(rule.end_pair, next_char)
      and rule:can_del({ rule = rule, prev_char = prev_char, next_char = next_char, line = line, col = col })
    then
      local input = Utils.repeat_key(Utils.key.bs, #rule.start_pair) .. Utils.repeat_key(Utils.key.del, #rule.end_pair)
      return Utils.esc("<c-g>U" .. input)
    end
  end

  return Utils.esc("<bs>")
end

function M.autopairs_cr()
  if is_disabled() then
    return Utils.esc("<CR>")
  end
  local line = Utils.text_get_current_line()
  local col = Utils.get_cursor_col()

  for _, rule in ipairs(rules) do
    local prev_char, next_char = Utils.text_cusor_line(line, col, #rule.start_pair, #rule.end_pair)
    if
      Utils.compare(rule.start_pair, prev_char)
      and Utils.compare(rule.end_pair, next_char)
      and rule:can_cr({ rule = rule, line = line, col = col, prev_char = prev_char, next_char = next_char })
    then
      return Utils.esc("<c-g>u<CR><CMD>normal! ====<CR><up><end><CR>")
    end
  end

  return Utils.esc("<CR>")
end

function M.completion_confirm()
  if vim.fn.pumvisible() ~= 0 then
    return Utils.esc("<CR>")
  end
  return M.autopairs_cr()
end

-- ============================================================
-- Setup
-- ============================================================

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  build_rules()

  local chars = { "(", ")", "[", "]", "{", "}", "'", '"', "`" }
  for _, char in ipairs(chars) do
    vim.keymap.set("i", char, function()
      return M.autopairs_map(char)
    end, { expr = true, replace_keycodes = false, desc = "autopairs " .. char })
  end

  if M.opts.map_bs then
    vim.keymap.set("i", "<bs>", M.autopairs_bs, { expr = true, replace_keycodes = false, desc = "autopairs delete" })
  end

  if M.opts.map_cr then
    vim.keymap.set("i", "<CR>", M.completion_confirm, {
      expr = true,
      replace_keycodes = false,
      desc = "autopairs completion confirm",
    })
  end
end

return M
