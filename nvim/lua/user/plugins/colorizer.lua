local M = {}

local ns = vim.api.nvim_create_namespace("user_colorizer")
local enabled = false
local hl_cache = {}
local timers = {}

-- === Color math ===

local function clamp(v)
  return math.max(0, math.min(255, v))
end

local function expand_short_hex(hex)
  return hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
end

local function hex_to_rgb(hex)
  if #hex == 3 then
    hex = expand_short_hex(hex)
  end
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_hex(r, g, b)
  return string.format("%02x%02x%02x", clamp(r), clamp(g), clamp(b))
end

local function get_hl_group(hex)
  hex = hex:lower()

  if #hex == 3 then
    hex = expand_short_hex(hex)
  elseif #hex ~= 6 then
    return "Normal"
  end

  if not hex:match("^%x%x%x%x%x%x$") then
    return "Normal"
  end

  local name = "UserColorizer_" .. hex
  if hl_cache[name] then
    return name
  end

  local r, g, b = hex_to_rgb(hex)
  local luminance = 0.299 * r + 0.587 * g + 0.114 * b
  local fg = luminance > 140 and "#000000" or "#ffffff"

  vim.api.nvim_set_hl(0, name, { bg = "#" .. hex, fg = fg })
  hl_cache[name] = true
  return name
end

-- === Line scanning ===

-- word-boundary check: true if `ch` would extend an identifier (letter,
-- digit, or underscore). Rejecting on this -- not just on hex digits --
-- is what prevents "#define", "#decoded", etc. from being misread as
-- short hex colors.
local function is_word_char(ch)
  return ch ~= "" and ch:match("[%w_]") ~= nil
end

local function scan_line(line)
  local matches = {}

  -- hex: try 6-digit first (greedy), fall back to 3-digit only if a full
  -- 6-digit match isn't present at that position. Single pass, no overlap.
  do
    local pos = 1
    while true do
      local s = line:find("#", pos, true)
      if not s then break end

      local before = line:sub(s - 1, s - 1)
      if is_word_char(before) then
        -- "#" glued to a preceding identifier (e.g. "x#fff") -- skip
        pos = s + 1
      else
        local six = line:sub(s + 1, s + 6)
        local three = line:sub(s + 1, s + 3)
        local after6 = line:sub(s + 7, s + 7)
        local after3 = line:sub(s + 4, s + 4)

        if six:match("^%x%x%x%x%x%x$") and not is_word_char(after6) then
          table.insert(matches, { s = s, e = s + 6, hex = six })
          pos = s + 7
        elseif three:match("^%x%x%x$") and not is_word_char(after3) then
          table.insert(matches, { s = s, e = s + 3, hex = three })
          pos = s + 4
        else
          pos = s + 1
        end
      end
    end
  end

  -- rgb() / rgba()
  do
    local pos = 1
    while true do
      local s, e = line:find("rgba?%([^%)]+%)", pos)
      if not s then break end
      local body = line:sub(s, e)
      local r, g, b = body:match("(%d+)%s*,%s*(%d+)%s*,%s*(%d+)")
      if r then
        table.insert(matches, { s = s, e = e, hex = rgb_to_hex(tonumber(r), tonumber(g), tonumber(b)) })
      end
      pos = e + 1
    end
  end

  return matches
end

-- === Rendering ===

local function highlight_buffer(bufnr)
  if not enabled or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    for _, m in ipairs(scan_line(line)) do
      vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, m.s - 1, {
        end_col = m.e,
        hl_group = get_hl_group(m.hex),
      })
    end
  end
end

local function clear_timer(bufnr)
  local t = timers[bufnr]
  if t then
    t:stop()
    t:close()
    timers[bufnr] = nil
  end
end

local function schedule_highlight(bufnr)
  clear_timer(bufnr)
  local timer = vim.loop.new_timer()
  timers[bufnr] = timer
  timer:start(100, 0, vim.schedule_wrap(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      highlight_buffer(bufnr)
    end
    clear_timer(bufnr)
  end))
end

-- === Toggle API ===

function M.turn_on()
  enabled = true
  schedule_highlight(vim.api.nvim_get_current_buf())
end

function M.turn_off()
  enabled = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    end
  end
end

function M.toggle()
  if enabled then
    M.turn_off()
  else
    M.turn_on()
  end
end

-- === Setup ===

vim.api.nvim_create_user_command("HighlightColorsOn", M.turn_on, {})
vim.api.nvim_create_user_command("HighlightColorsOff", M.turn_off, {})
vim.api.nvim_create_user_command("HighlightColorsToggle", M.toggle, {})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
  callback = function(ev)
    if enabled then
      schedule_highlight(ev.buf)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(ev)
    clear_timer(ev.buf)
  end,
})

return M
