local opt = vim.opt
local cmd = vim.cmd

opt.path:append("**")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

opt.title = true
cmd("syntax on")
-- cmd([[ hi Normal guibg=NONE ]]) -- Enable Trans
opt.number = true
opt.relativenumber = false

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

-- -- Restore cursor position
-- cmd([[
--   autocmd bufreadpost *
--     \ if line("'\"") > 0 && line("'\"") <= line("$") |
--     \   exe "normal! g'\"" |
--     \ endif
-- ]])

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
    vim.api.nvim_set_hl(0, "Error",        { fg = "#AF5F5F", bg = "NONE" }) 
    vim.api.nvim_set_hl(0, "ErrorMsg",     { fg = "#AF5F5F", bg = "NONE" }) 
    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#AF5F5F", bg = "NONE" }) 
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
-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({
			timeout = 200,
			visual = true,
		})
	end,
})

-- restore last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("restore_cursor", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local last_line = vim.api.nvim_buf_line_count(args.buf)

		if mark[1] > 0 and mark[1] <= last_line then
			vim.api.nvim_win_set_cursor(0, mark)
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in a vertical split
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("help_vertical", { clear = true }),
	pattern = "help",
	command = "wincmd L",
})

-- do not continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
