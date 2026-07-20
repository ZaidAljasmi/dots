vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.o.termguicolors = true
vim.g.colors_name = "acme"

local c = {
  white        = "#ffffff",
  bg           = "#ffffea",
  black        = "#000000",
  selected     = "#eeee9e",
  bar_bg       = "#aeeeee",
  bar_inactive = "#eaffff",
  cursor       = "#444444",
  red          = "#a0342f",
  green        = "#065905",
  indent       = "#aaaaaa",
  orange       = "#f0ad4e",
  gray         = "#777777",
  frameline    = "#da8581",
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
hi("CursorLine",   { bg = c.bar_bg })             -- ui.cursorline
hi("Cursor",       { fg = c.white, bg = c.cursor })
hi("lCursor",      { fg = c.white, bg = c.cursor })
hi("Visual",       { bg = c.selected })           -- ui.selection
hi("VisualNOS",    { bg = c.selected })
hi("Search",       { bg = c.selected, fg = c.black })
hi("IncSearch",    { bg = c.bar_bg, fg = c.black })-- ui.cursor.match
hi("CurSearch",    { bg = c.bar_bg, fg = c.black })
hi("MatchParen",   { bg = c.bar_bg, fg = c.black })

hi("StatusLine",   { fg = c.black, bg = c.bar_bg })       -- ui.statusline
hi("StatusLineNC", { fg = c.black, bg = c.bar_inactive }) -- ui.statusline.inactive
hi("TabLine",      { fg = c.black, bg = c.bar_bg })       -- ui.bufferline
hi("TabLineSel",   { fg = c.black, bg = c.bg })           -- ui.bufferline.active
hi("TabLineFill",  { fg = c.black, bg = c.bar_bg })
hi("WinSeparator", { fg = c.bar_bg, bg = c.bg })
hi("VertSplit",    { fg = c.bar_bg, bg = c.bg })

hi("Pmenu",        { fg = c.black, bg = c.bg })    -- ui.menu
hi("PmenuSel",     { fg = c.black, bg = c.selected }) -- ui.menu.selected
hi("PmenuSbar",    { bg = c.bar_bg })
hi("PmenuThumb",   { bg = c.cursor })
hi("WildMenu",     { fg = c.black, bg = c.selected })

hi("SignColumn",   { fg = c.black, bg = c.bg })
hi("FoldColumn",   { fg = c.black, bg = c.bg })
hi("Folded",       { fg = c.black, bg = c.bar_bg })
hi("ColorColumn",  { bg = c.bar_bg })

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
-- Treesitter (@-prefixed captures) mapped the same way: only strings and
-- comments diverge from Normal, nothing else is invented.
-- ==========================================================================
local ts_plain = {
  "@variable", "@variable.builtin", "@variable.parameter", "@variable.member",
  "@constant", "@constant.builtin", "@constant.macro",
  "@module", "@module.builtin", "@label",
  "@function", "@function.builtin", "@function.call", "@function.macro",
  "@method", "@method.call", "@constructor",
  "@keyword", "@keyword.function", "@keyword.operator", "@keyword.return",
  "@keyword.conditional", "@keyword.repeat", "@keyword.import", "@keyword.exception",
  "@operator", "@type", "@type.builtin", "@type.definition", "@type.qualifier",
  "@attribute", "@property", "@punctuation.delimiter", "@punctuation.bracket",
  "@punctuation.special", "@tag", "@tag.attribute", "@tag.delimiter",
  "@markup", "@markup.heading", "@markup.strong", "@markup.italic",
  "@markup.link", "@markup.link.url", "@markup.list", "@markup.quote",
  "@number", "@boolean", "@character", "@float",
  "@diff.plus", "@diff.minus", "@diff.delta",
}
for _, g in ipairs(ts_plain) do
  link(g, "Normal")
end
link("@string", "String")
link("@string.escape", "String")
link("@string.special", "String")
link("@comment", "Comment")
link("@comment.documentation", "Comment")
link("@spell", "Normal")
link("@markup.raw", "Normal")

-- LSP semantic tokens: same discipline, everything -> Normal except strings/comments
local lsp_plain = {
  "@lsp.type.variable", "@lsp.type.parameter", "@lsp.type.property",
  "@lsp.type.function", "@lsp.type.method", "@lsp.type.class",
  "@lsp.type.interface", "@lsp.type.enum", "@lsp.type.enumMember",
  "@lsp.type.type", "@lsp.type.namespace", "@lsp.type.keyword",
  "@lsp.type.macro", "@lsp.type.decorator", "@lsp.type.struct",
}
for _, g in ipairs(lsp_plain) do
  link(g, "Normal")
end
link("@lsp.type.comment", "Comment")
link("@lsp.type.string", "String")

-- ==========================================================================
-- Telescope: helix has no picker, so this reuses the theme's existing UI
-- colors instead of introducing new ones. bg=ui.popup, selection=ui.selection,
-- border=statusline color (the only "accent" bg the theme defines).
-- ==========================================================================
hi("TelescopeNormal",       { fg = c.black, bg = c.bg })
hi("TelescopeBorder",       { fg = c.bar_bg, bg = c.bg })
hi("TelescopePromptNormal", { fg = c.black, bg = c.bg })
hi("TelescopePromptBorder", { fg = c.bar_bg, bg = c.bg })
hi("TelescopePromptTitle",  { fg = c.black, bg = c.bar_bg })
hi("TelescopeResultsNormal",{ fg = c.black, bg = c.bg })
hi("TelescopeResultsBorder",{ fg = c.bar_bg, bg = c.bg })
hi("TelescopeResultsTitle", { fg = c.black, bg = c.bar_bg })
hi("TelescopePreviewNormal",{ fg = c.black, bg = c.bg })
hi("TelescopePreviewBorder",{ fg = c.bar_bg, bg = c.bg })
hi("TelescopePreviewTitle", { fg = c.black, bg = c.bar_bg })
hi("TelescopeSelection",    { fg = c.black, bg = c.selected })   -- ui.selection
hi("TelescopeSelectionCaret", { fg = c.black, bg = c.selected })
hi("TelescopeMultiSelection",{ fg = c.black, bg = c.selected })
hi("TelescopeMatching",     { fg = c.red, bold = true })

