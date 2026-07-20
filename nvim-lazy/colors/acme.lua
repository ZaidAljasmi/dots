vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.o.termguicolors = true
vim.g.colors_name = "acme"

local c = {
  white              = "#ffffff",
  bg                 = "#ffffea",
  black              = "#000000",
  selected           = "#eeee9e",
  bar_bg             = "#aeeeee",
  bar_inactive       = "#eaffff",
  cursor             = "#444444",
  red                = "#a0342f",
  green              = "#065905",
  indent             = "#aaaaaa",
  orange             = "#f0ad4e",
  gray               = "#777777",
  frameline          = "#da8581",
  bar_bg_brown       = "#E3BE92",
  bar_inactive_brown = "#EDD5B8",
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local link = function(group, target)
  vim.api.nvim_set_hl(0, group, { link = target })
end

-- ==========================================================================
-- Base editor UI (from ui.* entries in acme.toml)
-- ==========================================================================
hi("Normal",       { fg = c.black, bg = c.bg })
hi("NormalNC",     { fg = c.black, bg = c.bg })
hi("NormalFloat",  { fg = c.black, bg = c.bg })   -- ui.popup / ui.help
hi("FloatBorder",  { fg = c.black, bg = c.bg })
hi("LineNr",       { fg = c.black, bg = c.bg })   -- ui.linenr
hi("CursorLineNr", { fg = c.black, bg = c.bg })   -- ui.linenr.selected
hi("CursorLine",   { bg = c.selected })             -- ui.cursorline
hi("Cursor",       { fg = c.white, bg = c.cursor })
hi("lCursor",      { fg = c.white, bg = c.cursor })
hi("Visual",       { bg = c.selected })           -- ui.selection
hi("VisualNOS",    { bg = c.selected })
hi("Search",       { bg = c.bar_bg_brown, fg = c.black })
hi("IncSearch",    { bg = c.bar_bg_brown, fg = c.black })-- ui.cursor.match
hi("CurSearch",    { bg = c.bar_bg_brown, fg = c.black })
hi("MatchParen",   { bg = c.bar_bg_brown, fg = c.black })

hi("StatusLine",   { fg = c.black, bg = c.bar_bg_brown })       -- ui.statusline
hi("StatusLineNC", { fg = c.black, bg = c.bar_inactive_brown }) -- ui.statusline.inactive
hi("TabLine",      { fg = c.black, bg = c.bar_bg })       -- ui.bufferline
hi("TabLineSel",   { fg = c.black, bg = c.bg })           -- ui.bufferline.active
hi("TabLineFill",  { fg = c.black, bg = c.bar_bg })
hi("WinSeparator", { fg = c.cursor, bg = c.bg })
hi("VertSplit",    { fg = c.cursor, bg = c.bg })

hi("Pmenu",        { fg = c.black, bg = c.bg })    -- ui.menu
hi("PmenuSel",     { fg = c.black, bg = c.selected }) -- ui.menu.selected
hi("PmenuSbar",    { bg = c.bar_bg_brown })
hi("PmenuThumb",   { bg = c.cursor })
hi("WildMenu",     { fg = c.black, bg = c.selected })

hi("SignColumn",   { fg = c.black, bg = c.bg })
hi("FoldColumn",   { fg = c.black, bg = c.bg })
hi("Folded",       { fg = c.black, bg = c.bar_bg })
hi("ColorColumn",  { bg = c.bar_bg_brown })

hi("NonText",      { fg = c.indent })   -- ui.virtual
hi("Whitespace",   { fg = c.indent })
hi("SpecialKey",   { fg = c.indent })
link("IblIndent", "NonText")

hi("Title",        { fg = c.black })
hi("Directory",    { fg = c.black })
hi("ModeMsg",      { fg = c.black })
hi("MoreMsg",       { fg = c.green })
hi("Question",       { fg = c.green })
hi("WarningMsg",     { fg = c.orange })
hi("ErrorMsg",       { fg = c.white, bg = c.red })

-- ==========================================================================
-- Diagnostics (exact from acme.toml)
-- ==========================================================================
hi("DiagnosticError", { fg = c.white, bg = c.red, bold = true })
hi("DiagnosticWarn",  { fg = c.black, bg = c.orange, bold = true })
hi("DiagnosticHint",  { fg = c.gray, bold = true })
hi("DiagnosticInfo",  { fg = c.gray, bold = true }) -- helix has no "info"; hint style reused
link("DiagnosticUnderlineError", "DiagnosticError")
link("DiagnosticUnderlineWarn", "DiagnosticWarn")
link("DiagnosticUnderlineHint", "DiagnosticHint")
link("DiagnosticUnderlineInfo", "DiagnosticInfo")

-- ==========================================================================
-- Diff (exact from acme.toml)
-- ==========================================================================
hi("DiffAdd",    { fg = c.green })   -- diff.plus
hi("DiffDelete", { fg = c.red })     -- diff.minus
hi("DiffChange", { fg = c.bar_bg })  -- diff.delta
link("DiffText", "DiffChange")

-- ==========================================================================
-- Syntax: only string (red) and comment (green) are colored in acme.toml.
-- Everything else links to Normal, matching helix's ui.text fallback.
-- ==========================================================================
hi("Comment", { fg = c.green })
hi("String",  { fg = c.red })

local plain_groups = {
  "Constant", "Character", "Number", "Boolean", "Float",
  "Identifier", "Function",
  "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception",
  "PreProc", "Include", "Define", "Macro", "PreCondit",
  "Type", "StorageClass", "Structure", "Typedef",
  "Special", "SpecialChar", "Tag", "Delimiter", "SpecialComment", "Debug",
  "Underlined", "Ignore",
}
for _, g in ipairs(plain_groups) do
  link(g, "Normal")
end
hi("Todo",  { fg = c.white, bg = c.orange, bold = true })
hi("Error", { fg = c.white, bg = c.red })

-- ==========================================================================

-- Telescope
link("TelescopeNormal",        "Normal")
hi("TelescopeBorder",        { fg = c.cursor, bg = c.bg })
link("TelescopePromptNormal",  "Normal")
hi("TelescopePromptBorder",  { fg = c.cursor, bg = c.bg })
link("TelescopePromptTitle",   "Normal")
link("TelescopeResultsNormal", "Normal")
hi("TelescopeResultsBorder", { fg = c.cursor, bg = c.bg })
link("TelescopeResultsTitle",  "Normal")
link("TelescopePreviewNormal", "Normal")
hi("TelescopePreviewBorder", { fg = c.cursor, bg = c.bg })
link("TelescopePreviewTitle",  "Normal")
link("TelescopeSelection",      "Visual")
link("TelescopeSelectionCaret", "Visual")
link("TelescopeMultiSelection", "Visual")
hi("TelescopeMatching", { fg = c.red, bold = false })
