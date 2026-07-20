local opt = vim.opt
local cmd = vim.cmd

opt.title = true
cmd("syntax on")
-- cmd([[ hi Normal guibg=NONE ]]) -- Enable Trans
opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- vim.opt.colorcolumn = "80"
opt.cursorcolumn = false 
opt.cursorline = false
opt.termguicolors = true
opt.signcolumn = "no"

opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true

-- Set the cursor style for different modes in Neovim
-- opt.guicursor = {
--   "n-v-c:block",
--   "i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150",
--   "r-cr:hor20",
--   "o:hor50",
-- }
opt.guicursor = {
  "n-v-c:block",
  "i-ci-ve:block",
  "r-cr:block",
  "o:block",
}

-- Restore cursor position
cmd([[
  autocmd bufreadpost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
]])

-- Modeline setup
local function get_format()
  return vim.bo.fileformat:lower()
end
local function get_encoding()
  return (vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc):lower()
end
local function get_filetype()
  return vim.bo.filetype
end
local function get_git_branch()
  local head_file = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
  if head_file == "" then return "" end
  local ok, lines = pcall(vim.fn.readfile, head_file .. "/HEAD")
  if not ok or not lines[1] then return "" end
  local branch = lines[1]:match("ref: refs/heads/(.+)$")
  branch = branch or lines[1]:sub(1, 7)
  return "[" .. branch .. "]"
end
function MyStatusLine()
  return table.concat({
    " %f ",                 
    " %m%r%h%w ",           
    " " .. get_git_branch() .. " ",
    "%=",                   
    " %y ",                 
    " " .. get_format() .. " ",   
    " " .. get_encoding() .. " ", 
    " %l:%c ",              
    " %P "                  
  })
end
opt.statusline = "%!v:lua.MyStatusLine()"

-- vim.opt.laststatus = 3
-- opt.cmdheight = 1

-- Show the dots in the code working with indent-blankline plugin
opt.list = false
opt.listchars:append("space:·")
---------------------------------------------------------
-- Habamax theme settings:
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "habamax",
  callback = function()
   -- vim.api.nvim_set_hl(0, "TelescopeBorder",         { fg = "#767676", bg = "#1c1c1c" })
   -- vim.api.nvim_set_hl(0, "TelescopeSelection",      { bg = "#3a3a3a", fg = "#c7c7c7" })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#181818", bg = "#181818" })
    vim.api.nvim_set_hl(0, "VertSplit",    { fg = "#181818", bg = "#181818" })
    vim.api.nvim_set_hl(0, "StatusLine",   { fg = "#c7c7c7", bg = "#181818" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#767676", bg = "#181818" })
    vim.api.nvim_set_hl(0, "Error",        { fg = "#AF5F5F", bg = "NONE" }) -- خطأ الواجهة العام
    vim.api.nvim_set_hl(0, "ErrorMsg",     { fg = "#AF5F5F", bg = "NONE" }) -- رسائل الخطأ في سطر الأوامر
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#AF5F5F", bg = "NONE" }) -- أخطاء الـ LSP والـ Linters
    vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#AF5F5F", bg = "NONE" })
    local hl_groups = vim.fn.getcompletion("", "highlight")
    for _, group in ipairs(hl_groups) do
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
      if ok and hl.bold then
        hl.bold = false
        vim.api.nvim_set_hl(0, group, hl)
      end
    end
  end,
})
---------------------------------------------------------------------------------
