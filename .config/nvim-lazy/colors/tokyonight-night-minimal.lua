-- ============================================================================
-- tokyonight-night.lua — standalone, vendored port of tokyonight.nvim (Night)
--
-- Self-contained colors/ file: does NOT require the tokyonight plugin.
-- Palette values below were computed by actually running tokyonight's own
-- colors/init.lua derivation logic (diff/git/terminal/rainbow/etc. are all
-- generated, not hand-picked) against the upstream "night" palette, so every
-- hex value here is byte-identical to what :colorscheme tokyonight-night
-- would produce with default options.
--
-- Included groups (mirrors what tokyonight enables for a normal lazy.nvim
-- setup with these plugins installed): base (core editor/syntax/lsp),
-- treesitter, semantic_tokens, lsp/completion kinds, alpha, blink.cmp,
-- nvim-cmp, nvim-dap, dashboard-nvim, flash.nvim, fzf-lua, gitsigns,
-- vim-illuminate, indent-blankline, all of mini.nvim, neogit, neo-tree,
-- nvim-tree, rainbow-delimiters, telescope, nvim-treesitter-context.
--
-- Put this file at: ~/.config/nvim/colors/tokyonight-night.lua
-- Then: :colorscheme tokyonight-night
-- ============================================================================

vim.o.termguicolors = true
if vim.g.colors_name then
	vim.cmd("hi clear")
end
vim.g.colors_name = "tokyonight-night"

-- ----------------------------------------------------------------------------
-- Palette (Night) — computed via tokyonight's own colors/init.lua derivation
-- ----------------------------------------------------------------------------
local C = {
  bg = "#1a1b26",
  bg_dark = "#16161e",
  bg_dark1 = "#0C0E14",
  bg_float = "#16161e",
  bg_highlight = "#292e42",
  bg_popup = "#16161e",
  bg_search = "#3d59a1",
  bg_sidebar = "#16161e",
  bg_statusline = "#16161e",
  bg_visual = "#283457",
  black = "#15161e",
  blue = "#7aa2f7",
  blue0 = "#3d59a1",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#b4f9f8",
  blue7 = "#394b70",
  border = "#15161e",
  border_highlight = "#27a1b9",
  comment = "#565f89",
  cyan = "#7dcfff",
  dark3 = "#545c7e",
  dark5 = "#737aa2",
  diff = {
    add = "#243e4a",
    change = "#1f2231",
    delete = "#4a272f",
    text = "#394b70",
  },
  error = "#db4b4b",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_float = "#c0caf5",
  fg_gutter = "#3b4261",
  fg_sidebar = "#a9b1d6",
  git = {
    add = "#449dab",
    change = "#6183bb",
    delete = "#914c54",
    ignore = "#545c7e",
  },
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  hint = "#1abc9c",
  info = "#0db9d7",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  none = "NONE",
  orange = "#ff9e64",
  purple = "#9d7cd8",
  rainbow = {
    "#7aa2f7",
    "#e0af68",
    "#9ece6a",
    "#1abc9c",
    "#bb9af7",
    "#9d7cd8",
    "#ff9e64",
    "#f7768e",
  },
  red = "#f7768e",
  red1 = "#db4b4b",
  teal = "#1abc9c",
  terminal = {
    black = "#15161e",
    black_bright = "#414868",
    blue = "#7aa2f7",
    blue_bright = "#8db0ff",
    cyan = "#7dcfff",
    cyan_bright = "#a4daff",
    green = "#9ece6a",
    green_bright = "#9fe044",
    magenta = "#bb9af7",
    magenta_bright = "#c7a9ff",
    red = "#f7768e",
    red_bright = "#ff899d",
    white = "#a9b1d6",
    white_bright = "#c0caf5",
    yellow = "#e0af68",
    yellow_bright = "#faba4a",
  },
  terminal_black = "#414868",
  todo = "#7aa2f7",
  warning = "#e0af68",
  yellow = "#e0af68",
}

-- ----------------------------------------------------------------------------
-- Color utilities — verbatim (subset) from tokyonight.nvim util.lua
-- ----------------------------------------------------------------------------
local U = {}
U.bg = C.bg
U.fg = C.fg

local function rgb(c)
	c = string.lower(c)
	return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

function U.blend(foreground, alpha, background)
	alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
	local bg = rgb(background)
	local fg = rgb(foreground)
	local function blendChannel(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end
	return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

function U.blend_bg(hex, amount, bg)
	return U.blend(hex, amount, bg or U.bg)
end
U.darken = U.blend_bg

function U.blend_fg(hex, amount, fg)
	return U.blend(hex, amount, fg or U.fg)
end
U.lighten = U.blend_fg

local Util = U

-- ----------------------------------------------------------------------------
-- Options — verbatim tokyonight.config defaults (style = "night")
-- ----------------------------------------------------------------------------
local O = {
	style = "night",
	transparent = false,
	terminal_colors = true,
	styles = {
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		sidebars = "dark",
		floats = "dark",
	},
	day_brightness = 0.3,
	dim_inactive = false,
	lualine_bold = false,
}

-- ----------------------------------------------------------------------------
-- LSP / completion "kind" highlight table — verbatim from groups/kinds.lua
-- ----------------------------------------------------------------------------
local kinds = {
	Array = "@punctuation.bracket",
	Boolean = "@boolean",
	Class = "@type",
	Color = "Special",
	Constant = "@constant",
	Constructor = "@constructor",
	Enum = "@lsp.type.enum",
	EnumMember = "@lsp.type.enumMember",
	Event = "Special",
	Field = "@variable.member",
	File = "Normal",
	Folder = "Directory",
	Function = "@function",
	Interface = "@lsp.type.interface",
	Key = "@variable.member",
	Keyword = "@lsp.type.keyword",
	Method = "@function.method",
	Module = "@module",
	Namespace = "@module",
	Null = "@constant.builtin",
	Number = "@number",
	Object = "@constant",
	Operator = "@operator",
	Package = "@module",
	Property = "@property",
	Reference = "@markup.link",
	Snippet = "Conceal",
	String = "@string",
	Struct = "@lsp.type.struct",
	Unit = "@lsp.type.struct",
	Text = "@markup",
	TypeParameter = "@lsp.type.typeParameter",
	Variable = "@variable",
	Value = "@string",
}

local function apply_kinds(hl, pattern)
	hl = hl or {}
	for kind, link in pairs(kinds) do
		local base = "LspKind" .. kind
		if pattern then
			hl[pattern:format(kind)] = base
		else
			hl[base] = link
		end
	end
	return hl
end

-- ----------------------------------------------------------------------------
-- Highlight-group tables (vendored verbatim from tokyonight.nvim)
-- ----------------------------------------------------------------------------
-- ==== source: groups/base.lua ====
local function get_base(c, opts)
  -- stylua: ignore
  return {
    Foo                         = { bg = c.magenta2, fg = c.fg },

    Comment                     = { fg = c.comment, style = opts.styles.comments }, -- any comment
    ColorColumn                 = { bg = c.black }, -- used for the columns set with 'colorcolumn'
    Conceal                     = { fg = c.dark5 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor                      = { fg = c.bg, bg = c.fg }, -- character under the cursor
    lCursor                     = { fg = c.bg, bg = c.fg }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM                    = { fg = c.bg, bg = c.fg }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn                = { bg = c.bg_highlight }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine                  = { bg = c.bg_highlight }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory                   = { fg = c.blue }, -- directory names (and other special names in listings)
    DiffAdd                     = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
    DiffChange                  = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
    DiffDelete                  = { bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
    DiffText                    = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer                 = { fg = c.bg }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    ErrorMsg                    = { fg = c.error }, -- error messages on the command line
    VertSplit                   = { fg = c.border }, -- the column separating vertically split windows
    WinSeparator                = { fg = c.border, bold = true }, -- the column separating vertically split windows
    Folded                      = { fg = c.blue, bg = c.fg_gutter }, -- line used for closed folds
    FoldColumn                  = { bg = opts.transparent and c.none or c.bg, fg = c.comment }, -- 'foldcolumn'
    SignColumn                  = { bg = opts.transparent and c.none or c.bg, fg = c.fg_gutter }, -- column where |signs| are displayed
    SignColumnSB                = { bg = c.bg_sidebar, fg = c.fg_gutter }, -- column where |signs| are displayed
    Substitute                  = { bg = c.red, fg = c.black }, -- |:substitute| replacement text highlighting
    LineNr                      = { fg = c.fg_gutter }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr                = { fg = c.orange, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    LineNrAbove                 = { fg = c.fg_gutter },
    LineNrBelow                 = { fg = c.fg_gutter },
    MatchParen                  = { fg = c.orange, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg                     = { fg = c.fg_dark, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea                     = { fg = c.fg_dark }, -- Area for messages and cmdline
    MoreMsg                     = { fg = c.blue }, -- |more-prompt|
    NonText                     = { fg = c.dark3 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal                      = { fg = c.fg, bg = opts.transparent and c.none or c.bg }, -- normal text
    NormalNC                    = { fg = c.fg, bg = opts.transparent and c.none or opts.dim_inactive and c.bg_dark or c.bg }, -- normal text in non-current windows
    NormalSB                    = { fg = c.fg_sidebar, bg = c.bg_sidebar }, -- normal text in sidebar
    NormalFloat                 = { fg = c.fg_float, bg = c.bg_float }, -- Normal text in floating windows.
    FloatBorder                 = { fg = c.border_highlight, bg = c.bg_float },
    FloatTitle                  = { fg = c.border_highlight, bg = c.bg_float },
    Pmenu                       = { bg = c.bg_popup, fg = c.fg }, -- Popup menu: normal item.
    PmenuMatch                  = { bg = c.bg_popup, fg = c.blue1 }, -- Popup menu: Matched text in normal item.
    PmenuSel                    = { bg = Util.blend_bg(c.fg_gutter, 0.8) }, -- Popup menu: selected item.
    PmenuMatchSel               = { bg = Util.blend_bg(c.fg_gutter, 0.8), fg = c.blue1 }, -- Popup menu: Matched text in selected item.
    PmenuSbar                   = { bg = Util.blend_fg(c.bg_popup, 0.95) }, -- Popup menu: scrollbar.
    PmenuThumb                  = { bg = c.fg_gutter }, -- Popup menu: Thumb of the scrollbar.
    Question                    = { fg = c.blue }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine                = { bg = c.bg_visual, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search                      = { bg = c.bg_search, fg = c.fg }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    IncSearch                   = { bg = c.orange, fg = c.black }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    CurSearch                   =  "IncSearch",
    SpecialKey                  = { fg = c.dark3 }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad                    = { sp = c.error, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap                    = { sp = c.warning, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal                  = { sp = c.info, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare                   = { sp = c.hint, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    StatusLine                  = { fg = c.fg_sidebar, bg = c.bg_statusline }, -- status line of current window
    StatusLineNC                = { fg = c.fg_gutter, bg = c.bg_statusline }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine                     = { bg = c.bg_statusline, fg = c.fg_gutter }, -- tab pages line, not active tab page label
    TabLineFill                 = { bg = opts.transparent and c.none or c.black }, -- tab pages line, where there are no labels
    TabLineSel                  = { fg = c.black, bg = c.blue }, -- tab pages line, active tab page label
    Title                       = { fg = c.blue, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
    Visual                      = { bg = c.bg_visual }, -- Visual mode selection
    VisualNOS                   = { bg = c.bg_visual }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg                  = { fg = c.warning }, -- warning messages
    Whitespace                  = { fg = c.fg_gutter }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu                    = { bg = c.bg_visual }, -- current match in 'wildmenu' completion
    WinBar                      = "StatusLine" , -- window bar
    WinBarNC                    = "StatusLineNC", -- window bar in inactive windows

    Bold                        = { bold = true, fg = c.fg }, -- (preferred) any bold text
    Character                   = { fg = c.green }, --  a character constant: 'c', '\n'
    Constant                    = { fg = c.orange }, -- (preferred) any constant
    Debug                       = { fg = c.orange }, --    debugging statements
    Delimiter                   =  "Special", --  character that needs attention
    Error                       = { fg = c.error }, -- (preferred) any erroneous construct
    Function                    = { fg = c.blue, style = opts.styles.functions }, -- function name (also: methods for classes)
    Identifier                  = { fg = c.magenta, style = opts.styles.variables }, -- (preferred) any variable name
    Italic                      = { italic = true, fg = c.fg }, -- (preferred) any italic text
    Keyword                     = { fg = c.cyan, style = opts.styles.keywords }, --  any other keyword
    Operator                    = { fg = c.blue5 }, -- "sizeof", "+", "*", etc.
    PreProc                     = { fg = c.cyan }, -- (preferred) generic Preprocessor
    Special                     = { fg = c.blue1 }, -- (preferred) any special symbol
    Statement                   = { fg = c.magenta }, -- (preferred) any statement
    String                      = { fg = c.green }, --   a string constant: "this is a string"
    Todo                        = { bg = c.yellow, fg = c.bg }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Type                        = { fg = c.blue1 }, -- (preferred) int, long, char, etc.
    Underlined                  = { underline = true }, -- (preferred) text that stands out, HTML links
    debugBreakpoint             = { bg = Util.blend_bg(c.info, 0.1), fg = c.info }, -- used for breakpoint colors in terminal-debug
    debugPC                     = { bg = c.bg_sidebar }, -- used for highlighting the current line in terminal-debug
    dosIniLabel                 = "@property",
    helpCommand                 = { bg = c.terminal_black, fg = c.blue },
    htmlH1                      = { fg = c.magenta, bold = true },
    htmlH2                      = { fg = c.blue, bold = true },
    qfFileName                  = { fg = c.blue },
    qfLineNr                    = { fg = c.dark5 },

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own.
    LspReferenceText            = { bg = c.fg_gutter }, -- used for highlighting "text" references
    LspReferenceRead            = { bg = c.fg_gutter }, -- used for highlighting "read" references
    LspReferenceWrite           = { bg = c.fg_gutter }, -- used for highlighting "write" references
    LspSignatureActiveParameter = { bg = Util.blend_bg(c.bg_visual, 0.4), bold = true },
    LspCodeLens                 = { fg = c.comment },
    LspInlayHint                = { bg = Util.blend_bg(c.blue7, 0.1), fg = c.dark3 },
    LspInfoBorder               = { fg = c.border_highlight, bg = c.bg_float },
    ComplHint                   = { fg = c.terminal_black },

    -- diagnostics
    DiagnosticError             = { fg = c.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticWarn              = { fg = c.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticInfo              = { fg = c.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticHint              = { fg = c.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticUnnecessary       = { fg = c.terminal_black }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticVirtualTextError  = { bg = Util.blend_bg(c.error, 0.1), fg = c.error }, -- Used for "Error" diagnostic virtual text
    DiagnosticVirtualTextWarn   = { bg = Util.blend_bg(c.warning, 0.1), fg = c.warning }, -- Used for "Warning" diagnostic virtual text
    DiagnosticVirtualTextInfo   = { bg = Util.blend_bg(c.info, 0.1), fg = c.info }, -- Used for "Information" diagnostic virtual text
    DiagnosticVirtualTextHint   = { bg = Util.blend_bg(c.hint, 0.1), fg = c.hint }, -- Used for "Hint" diagnostic virtual text
    DiagnosticUnderlineError    = { undercurl = true, sp = c.error }, -- Used to underline "Error" diagnostics
    DiagnosticUnderlineWarn     = { undercurl = true, sp = c.warning }, -- Used to underline "Warning" diagnostics
    DiagnosticUnderlineInfo     = { undercurl = true, sp = c.info }, -- Used to underline "Information" diagnostics
    DiagnosticUnderlineHint     = { undercurl = true, sp = c.hint }, -- Used to underline "Hint" diagnostics

    -- Health
    healthError                 = { fg = c.error },
    healthSuccess               = { fg = c.green1 },
    healthWarning               = { fg = c.warning },

    -- diff (not needed anymore?)
    diffAdded                   = { bg = c.diff.add, fg = c.git.add },
    diffRemoved                 = { bg = c.diff.delete, fg = c.git.delete },
    diffChanged                 = { bg = c.diff.change, fg = c.git.change },
    diffOldFile                 = { fg = c.blue1, bg=c.diff.delete },
    diffNewFile                 = { fg = c.blue1, bg=c.diff.add },
    diffFile                    = { fg = c.blue },
    diffLine                    = { fg = c.comment },
    diffIndexLine               = { fg = c.magenta },
    helpExample                 = { fg = c.comment },
  }
end

-- ==== source: groups/kinds.lua ====
local function get_kinds()
  return apply_kinds()
end

-- ==== source: groups/treesitter.lua ====
local function get_treesitter(c, opts)
  -- stylua: ignore
  local ret = {
    ["@annotation"]                 = "PreProc",
    ["@attribute"]                  = "PreProc",
    ["@boolean"]                    = "Boolean",
    ["@character"]                  = "Character",
    ["@character.printf"]           = "SpecialChar",
    ["@character.special"]          = "SpecialChar",
    ["@comment"]                    = "Comment",
    ["@comment.error"]              = { fg = c.error },
    ["@comment.hint"]               = { fg = c.hint },
    ["@comment.info"]               = { fg = c.info },
    ["@comment.note"]               = { fg = c.hint },
    ["@comment.todo"]               = { fg = c.todo },
    ["@comment.warning"]            = { fg = c.warning },
    ["@constant"]                   = "Constant",
    ["@constant.builtin"]           = "Special",
    ["@constant.macro"]             = "Define",
    ["@constructor"]                = { fg = c.magenta }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
    ["@constructor.tsx"]            = { fg = c.blue1 },
    ["@diff.delta"]                 = "DiffChange",
    ["@diff.minus"]                 = "DiffDelete",
    ["@diff.plus"]                  = "DiffAdd",
    ["@function"]                   = "Function",
    ["@function.builtin"]           = "Special",
    ["@function.call"]              = "@function",
    ["@function.macro"]             = "Macro",
    ["@function.method"]            = "Function",
    ["@function.method.call"]       = "@function.method",
    ["@keyword"]                    = { fg = c.purple, style = opts.styles.keywords }, -- For keywords that don't fall in previous categories.
    ["@keyword.conditional"]        = "Conditional",
    ["@keyword.coroutine"]          = "@keyword",
    ["@keyword.debug"]              = "Debug",
    ["@keyword.directive"]          = "PreProc",
    ["@keyword.directive.define"]   = "Define",
    ["@keyword.exception"]          = "Exception",
    ["@keyword.function"]           = { fg = c.magenta, style = opts.styles.functions }, -- For keywords used to define a function.
    ["@keyword.import"]             = "Include",
    ["@keyword.operator"]           = "@operator",
    ["@keyword.repeat"]             = "Repeat",
    ["@keyword.return"]             = "@keyword",
    ["@keyword.storage"]            = "StorageClass",
    ["@label"]                      = { fg = c.blue }, -- For labels: `label:` in C and `:label:` in Lua.
    ["@markup"]                     = "@none",
    ["@markup.emphasis"]            = { italic = true },
    ["@markup.environment"]         = "Macro",
    ["@markup.environment.name"]    = "Type",
    ["@markup.heading"]             = "Title",
    ["@markup.italic"]              = { italic = true },
    ["@markup.link"]                = { fg = c.teal },
    ["@markup.link.label"]          = "SpecialChar",
    ["@markup.link.label.symbol"]   = "Identifier",
    ["@markup.link.url"]            = "Underlined",
    ["@markup.list"]                = { fg = c.blue5 }, -- For special punctutation that does not fall in the categories before.
    ["@markup.list.checked"]        = { fg = c.green1 }, -- For brackets and parens.
    ["@markup.list.markdown"]       = { fg = c.orange, bold = true },
    ["@markup.list.unchecked"]      = { fg = c.blue }, -- For brackets and parens.
    ["@markup.math"]                = "Special",
    ["@markup.raw"]                 = "String",
    ["@markup.raw.markdown_inline"] = { bg = c.terminal_black, fg = c.blue },
    ["@markup.strikethrough"]       = { strikethrough = true },
    ["@markup.strong"]              = { bold = true },
    ["@markup.underline"]           = { underline = true },
    ["@module"]                     = "Include",
    ["@module.builtin"]             = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
    ["@namespace.builtin"]          = "@variable.builtin",
    ["@none"]                       = {},
    ["@number"]                     = "Number",
    ["@number.float"]               = "Float",
    ["@operator"]                   = { fg = c.blue5 }, -- For any operator: `+`, but also `->` and `*` in C.
    ["@property"]                   = { fg = c.green1 },
    ["@punctuation.bracket"]        = { fg = c.fg_dark }, -- For brackets and parens.
    ["@punctuation.delimiter"]      = { fg = c.blue5 }, -- For delimiters ie: `.`
    ["@punctuation.special"]        = { fg = c.blue5 }, -- For special symbols (e.g. `{}` in string interpolation)
    ["@punctuation.special.markdown"] = { fg = c.orange }, -- For special symbols (e.g. `{}` in string interpolation)
    ["@string"]                     = "String",
    ["@string.documentation"]       = { fg = c.yellow },
    ["@string.escape"]              = { fg = c.magenta }, -- For escape characters within a string.
    ["@string.regexp"]              = { fg = c.blue6 }, -- For regexes.
    ["@tag"]                        = "Label",
    ["@tag.attribute"]              = "@property",
    ["@tag.delimiter"]              = "Delimiter",
    ["@tag.delimiter.tsx"]          = { fg = Util.blend_bg(c.blue, 0.7) },
    ["@tag.tsx"]                    = { fg = c.red },
    ["@tag.javascript"]             = { fg = c.red },
    ["@type"]                       = "Type",
    ["@type.builtin"]               = { fg = Util.blend_bg(c.blue1, 0.8) },
    ["@type.definition"]            = "Typedef",
    ["@type.qualifier"]             = "@keyword",
    ["@variable"]                   = { fg = c.fg, style = opts.styles.variables }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"]           = { fg = c.red }, -- Variable names that are defined by the languages, like `this` or `self`.
    ["@variable.member"]            = { fg = c.green1 }, -- For fields.
    ["@variable.parameter"]         = { fg = c.yellow }, -- For parameters of a function.
    ["@variable.parameter.builtin"] = { fg = Util.blend_fg(c.yellow, 0.8) }, -- For builtin parameters of a function, e.g. "..." or Smali's p[1-99]
  }

  for i, color in ipairs(c.rainbow) do
    ret["@markup.heading." .. i .. ".markdown"] = { fg = color, bold = true, bg = Util.blend_bg(color, 0.1) }
  end
  return ret
end

-- ==== source: groups/semantic_tokens.lua ====
local function get_semantic_tokens(c)
  -- stylua: ignore
  return {
    ["@lsp.type.boolean"]                      = "@boolean",
    ["@lsp.type.builtinType"]                  = "@type.builtin",
    ["@lsp.type.comment"]                      = "@comment",
    ["@lsp.type.decorator"]                    = "@attribute",
    ["@lsp.type.deriveHelper"]                 = "@attribute",
    ["@lsp.type.enum"]                         = "@type",
    ["@lsp.type.enumMember"]                   = "@constant",
    ["@lsp.type.escapeSequence"]               = "@string.escape",
    ["@lsp.type.formatSpecifier"]              = "@markup.list",
    ["@lsp.type.generic"]                      = "@variable",
    ["@lsp.type.interface"]                    = { fg = Util.blend_fg(c.blue1, 0.7) },
    ["@lsp.type.keyword"]                      = "@keyword",
    ["@lsp.type.lifetime"]                     = "@keyword.storage",
    ["@lsp.type.namespace"]                    = "@module",
    ["@lsp.type.namespace.python"]             = "@variable",
    ["@lsp.type.number"]                       = "@number",
    ["@lsp.type.operator"]                     = "@operator",
    ["@lsp.type.parameter"]                    = "@variable.parameter",
    ["@lsp.type.property"]                     = "@property",
    ["@lsp.type.selfKeyword"]                  = "@variable.builtin",
    ["@lsp.type.selfTypeKeyword"]              = "@variable.builtin",
    ["@lsp.type.string"]                       = "@string",
    ["@lsp.type.typeAlias"]                    = "@type.definition",
    ["@lsp.type.unresolvedReference"]          = { undercurl = true, sp = c.error },
    ["@lsp.type.variable"]                     = {}, -- use treesitter styles for regular variables
    ["@lsp.typemod.class.defaultLibrary"]      = "@type.builtin",
    ["@lsp.typemod.enum.defaultLibrary"]       = "@type.builtin",
    ["@lsp.typemod.enumMember.defaultLibrary"] = "@constant.builtin",
    ["@lsp.typemod.function.defaultLibrary"]   = "@function.builtin",
    ["@lsp.typemod.keyword.async"]             = "@keyword.coroutine",
    ["@lsp.typemod.keyword.injected"]          = "@keyword",
    ["@lsp.typemod.macro.defaultLibrary"]      = "@function.builtin",
    ["@lsp.typemod.method.defaultLibrary"]     = "@function.builtin",
    ["@lsp.typemod.operator.injected"]         = "@operator",
    ["@lsp.typemod.string.injected"]           = "@string",
    ["@lsp.typemod.struct.defaultLibrary"]     = "@type.builtin",
    ["@lsp.typemod.type.defaultLibrary"]       = { fg = Util.blend_bg(c.blue1, 0.8) },
    ["@lsp.typemod.typeAlias.defaultLibrary"]  = { fg = Util.blend_bg(c.blue1, 0.8) },
    ["@lsp.typemod.variable.callable"]         = "@function",
    ["@lsp.typemod.variable.defaultLibrary"]   = "@variable.builtin",
    ["@lsp.typemod.variable.injected"]         = "@variable",
    ["@lsp.typemod.variable.static"]           = "@constant",

  }
end

-- ==== source: groups/alpha.lua ====
local function get_alpha(c, opts)
  -- stylua: ignore
  return {
    AlphaShortcut    = { fg = c.orange },
    AlphaHeader      = { fg = c.blue },
    AlphaHeaderLabel = { fg = c.orange },
    AlphaFooter      = { fg = c.blue1 },
    AlphaButtons     = { fg = c.cyan },
  }
end

-- ==== source: groups/blink.lua ====
local function get_blink(c, opts)
  -- stylua: ignore
  local ret = {
    BlinkCmpDoc                 = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpDocBorder           = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpGhostText           = { fg = c.terminal_black },
    BlinkCmpKindCodeium         = { fg = c.teal, bg             = c.none },
    BlinkCmpKindCopilot         = { fg = c.teal, bg             = c.none },
    BlinkCmpKindDefault         = { fg = c.fg_dark, bg          = c.none },
    BlinkCmpKindSupermaven      = { fg = c.teal, bg             = c.none },
    BlinkCmpKindTabNine         = { fg = c.teal, bg             = c.none },
    BlinkCmpLabel               = { fg = c.fg, bg               = c.none },
    BlinkCmpLabelDeprecated     = { fg = c.fg_gutter, bg        = c.none, strikethrough = true },
    BlinkCmpLabelMatch          = { fg = c.blue1, bg            = c.none },
    BlinkCmpMenu                = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpMenuBorder          = { fg = c.border_highlight, bg = c.bg_float },
    BlinkCmpSignatureHelp       = { fg = c.fg, bg               = c.bg_float },
    BlinkCmpSignatureHelpBorder = { fg = c.border_highlight, bg = c.bg_float },
  }

  apply_kinds(ret, "BlinkCmpKind%s")
  return ret
end

-- ==== source: groups/cmp.lua ====
local function get_cmp(c, opts)
  -- stylua: ignore
  local ret = {
    CmpDocumentation       = { fg = c.fg, bg = c.bg_float },
    CmpDocumentationBorder = { fg = c.border_highlight, bg = c.bg_float },
    CmpGhostText           = { fg = c.terminal_black },
    CmpItemAbbr            = { fg = c.fg, bg = c.none },
    CmpItemAbbrDeprecated  = { fg = c.fg_gutter, bg = c.none, strikethrough = true },
    CmpItemAbbrMatch       = { fg = c.blue1, bg = c.none },
    CmpItemAbbrMatchFuzzy  = { fg = c.blue1, bg = c.none },
    CmpItemKindCodeium     = { fg = c.teal, bg = c.none },
    CmpItemKindCopilot     = { fg = c.teal, bg = c.none },
    CmpItemKindSupermaven  = { fg = c.teal, bg = c.none },
    CmpItemKindDefault     = { fg = c.fg_dark, bg = c.none },
    CmpItemKindTabNine     = { fg = c.teal, bg = c.none },
    CmpItemMenu            = { fg = c.comment, bg = c.none },
  }

  apply_kinds(ret, "CmpItemKind%s")
  return ret
end

-- ==== source: groups/dap.lua ====
local function get_dap(c, opts)
  -- stylua: ignore
  return {
    DapStoppedLine = { bg = Util.blend_bg(c.warning, 0.1) }, -- Used for "Warning" diagnostic virtual text
  }
end

-- ==== source: groups/dashboard.lua ====
local function get_dashboard(c, opts)
  -- stylua: ignore
  return {
    -- General
    DashboardHeader           = { fg = c.blue },
    DashboardFooter           = { fg = c.blue1 },
    -- Hyper theme
    DashboardProjectTitle     = { fg = c.cyan },
    DashboardProjectTitleIcon = { fg = c.orange },
    DashboardProjectIcon      = { fg = c.yellow },
    DashboardMruTitle         = { fg = c.cyan },
    DashboardMruIcon          = { fg = c.purple },
    DashboardFiles            = { fg = c.blue },
    DashboardShortCutIcon     = { fg = c.magenta },
    -- Doome theme
    DashboardDesc             = { fg = c.cyan },
    DashboardKey              = { fg = c.orange },
    DashboardIcon             = { fg = c.cyan },
    DashboardShortCut         = { fg = c.cyan },
  }
end

-- ==== source: groups/flash.lua ====
local function get_flash(c, opts)
  -- stylua: ignore
  return {
    FlashBackdrop = { fg = c.dark3 },
    FlashLabel    = { bg = c.magenta2, bold = true, fg = c.fg },
  }
end

-- ==== source: groups/fzf.lua ====
local function get_fzf(c)
  -- stylua: ignore
  return {
    FzfLuaBorder        = { fg = c.border_highlight, bg = c.bg_float },
    FzfLuaCursor        = "IncSearch",
    FzfLuaDirPart       = { fg = c.fg_dark },
    FzfLuaFilePart      = "FzfLuaFzfNormal",
    FzfLuaFzfCursorLine = "Visual",
    FzfLuaFzfNormal     = { fg = c.fg },
    FzfLuaFzfPointer    = { fg = c.magenta2 },
    FzfLuaFzfSeparator  = { fg = c.orange, bg = c.bg_float },
    FzfLuaHeaderBind    = "@punctuation.special",
    FzfLuaHeaderText    = "Title",
    FzfLuaNormal        = { fg = c.fg, bg = c.bg_float },
    FzfLuaPath          = "Directory",
    FzfLuaPreviewTitle  = { fg = c.border_highlight, bg = c.bg_float },
    FzfLuaTitle         = { fg = c.orange, bg = c.bg_float },
  }
end

-- ==== source: groups/gitsigns.lua ====
local function get_gitsigns(c, opts)
  -- stylua: ignore
  return {
    GitSignsAdd    = { fg = c.git.add }, -- diff mode: Added line |diff.txt|
    GitSignsChange = { fg = c.git.change }, -- diff mode: Changed line |diff.txt|
    GitSignsDelete = { fg = c.git.delete }, -- diff mode: Deleted line |diff.txt|
  }
end

-- ==== source: groups/illuminate.lua ====
local function get_illuminate(c)
  -- stylua: ignore
  return {
    IlluminatedWordRead  = { bg = c.fg_gutter },
    IlluminatedWordText  = { bg = c.fg_gutter },
    IlluminatedWordWrite = { bg = c.fg_gutter },
    illuminatedCurWord   = { bg = c.fg_gutter },
    illuminatedWord      = { bg = c.fg_gutter },
  }
end

-- ==== source: groups/indent-blankline.lua ====
local function get_indent_blankline(c, opts)
  -- stylua: ignore
  return {
    IndentBlanklineChar        = { fg = c.fg_gutter, nocombine = true },
    IndentBlanklineContextChar = { fg = c.blue1, nocombine = true },
    IblIndent                  = { fg = c.fg_gutter, nocombine = true },
    IblScope                   = { fg = c.blue1, nocombine = true },
  }
end

-- ==== source: groups/neogit.lua ====
local function get_neogit(c)
  -- stylua: ignore
  return {
    NeogitBranch               = { fg = c.magenta },
    NeogitRemote               = { fg = c.purple },
    NeogitHunkHeader           = { bg = c.bg_highlight, fg = c.fg },
    NeogitHunkHeaderHighlight  = { bg = c.fg_gutter, fg = c.blue },
    NeogitDiffContextHighlight = { bg = Util.blend_bg(c.fg_gutter, 0.5), fg = c.fg_dark },
    NeogitDiffDeleteHighlight  = { fg = c.git.delete, bg = c.diff.delete },
    NeogitDiffAddHighlight     = { fg = c.git.add, bg = c.diff.add },
  }
end

-- ==== source: groups/neo-tree.lua ====
local function get_neo_tree(c, opts)
  local dark = opts.styles.sidebars == "transparent" and c.none
    or Util.blend(c.bg_sidebar, 0.8, opts.style == "day" and c.blue or "#000000")
  -- stylua: ignore
  return {
    NeoTreeDimText             = { fg = c.fg_gutter },
    NeoTreeFileName            = { fg = c.fg_sidebar },
    NeoTreeGitModified         = { fg = c.orange },
    NeoTreeGitStaged           = { fg = c.green1 },
    NeoTreeGitUntracked        = { fg = c.magenta },
    NeoTreeNormal              = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NeoTreeNormalNC            = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NeoTreeTabActive           = { fg = c.blue, bg = c.bg_dark, bold = true },
    NeoTreeTabInactive         = { fg = c.dark3, bg = dark },
    NeoTreeTabSeparatorActive  = { fg = c.blue, bg = c.bg_dark },
    NeoTreeTabSeparatorInactive= { fg = c.bg, bg = dark },
  }
end

-- ==== source: groups/nvim-tree.lua ====
local function get_nvim_tree(c, opts)
  -- stylua: ignore
  return {
    NvimTreeFolderIcon   = { bg = c.none, fg = c.blue },
    NvimTreeGitDeleted   = { fg = c.git.delete },
    NvimTreeGitDirty     = { fg = c.git.change },
    NvimTreeGitNew       = { fg = c.git.add },
    NvimTreeImageFile    = { fg = c.fg_sidebar },
    NvimTreeIndentMarker = { fg = c.fg_gutter },
    NvimTreeNormal       = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NvimTreeNormalNC     = { fg = c.fg_sidebar, bg = c.bg_sidebar },
    NvimTreeOpenedFile   = { bg = c.bg_highlight },
    NvimTreeRootFolder   = { fg = c.blue, bold = true },
    NvimTreeSpecialFile  = { fg = c.purple, underline = true },
    NvimTreeSymlink      = { fg = c.blue },
    NvimTreeWinSeparator = { fg = opts.styles.sidebars == "transparent" and c.border or c.bg_sidebar, bg = c.bg_sidebar },
  }
end

-- ==== source: groups/rainbow.lua ====
local function get_rainbow(c, opts)
  -- stylua: ignore
  return {
    -- rainbow-delimiters
    RainbowDelimiterRed    = { fg = c.red },
    RainbowDelimiterOrange = { fg = c.orange },
    RainbowDelimiterYellow = { fg = c.yellow },
    RainbowDelimiterGreen  = { fg = c.green },
    RainbowDelimiterBlue   = { fg = c.blue },
    RainbowDelimiterViolet = { fg = c.purple },
    RainbowDelimiterCyan   = { fg = c.cyan },
  }
end

-- ==== source: groups/telescope.lua ====
local function get_telescope(c, opts)
  -- stylua: ignore
  return {
    TelescopeBorder         = { fg = c.border_highlight, bg = c.bg_float },
    TelescopeNormal         = { fg = c.fg, bg = c.bg_float },
    TelescopePromptBorder   = { fg = c.orange, bg = c.bg_float },
    TelescopePromptTitle    = { fg = c.orange, bg = c.bg_float },
    TelescopeResultsComment = { fg = c.dark3 },
  }
end

-- ==== source: groups/treesitter-context.lua ====
local function get_treesitter_context(c)
  -- stylua: ignore
  return {
    TreesitterContext = { bg = Util.blend_bg(c.fg_gutter, 0.8) },
  }
end

-- ==== source: groups/mini_animate.lua ====
local function get_mini_animate(c)
  -- stylua: ignore
  return {
    MiniAnimateCursor      = { reverse = true, nocombine = true },
    MiniAnimateNormalFloat = "NormalFloat",
  }
end

-- ==== source: groups/mini_clue.lua ====
local function get_mini_clue(c)
  -- stylua: ignore
  return {
    MiniClueBorder              = "FloatBorder",
    MiniClueDescGroup           = "DiagnosticFloatingWarn",
    MiniClueDescSingle          = "NormalFloat",
    MiniClueNextKey             = "DiagnosticFloatingHint",
    MiniClueNextKeyWithPostkeys = "DiagnosticFloatingError",
    MiniClueSeparator           = "DiagnosticFloatingInfo",
    MiniClueTitle               = "FloatTitle",
  }
end

-- ==== source: groups/mini_completion.lua ====
local function get_mini_completion(c)
  -- stylua: ignore
  return {
    MiniCompletionActiveParameter = { underline = true },
  }
end

-- ==== source: groups/mini_cursorword.lua ====
local function get_mini_cursorword(c)
  -- stylua: ignore
  return {
    MiniCursorword        = { bg = c.fg_gutter },
    MiniCursorwordCurrent = { bg = c.fg_gutter },
  }
end

-- ==== source: groups/mini_deps.lua ====
local function get_mini_deps(c)
  -- stylua: ignore
  return {
    MiniDepsChangeAdded   = "diffAdded",
    MiniDepsChangeRemoved = "diffRemoved",
    MiniDepsHint          = "DiagnosticHint",
    MiniDepsInfo          = "DiagnosticInfo",
    MiniDepsMsgBreaking   = "DiagnosticWarn",
    MiniDepsPlaceholder   = "Comment",
    MiniDepsTitle         = "Title",
    MiniDepsTitleError    = { fg = c.black, bg = c.git.delete },
    MiniDepsTitleSame     = "Comment",
    MiniDepsTitleUpdate   = { fg = c.black, bg = c.git.add },
  }
end

-- ==== source: groups/mini_diff.lua ====
local function get_mini_diff(c)
  -- stylua: ignore
  return {
    MiniDiffOverAdd     = "DiffAdd",
    MiniDiffOverChange  = "DiffText",
    MiniDiffOverContext = "DiffChange",
    MiniDiffOverDelete  = "DiffDelete",
    MiniDiffSignAdd     = { fg = c.git.add },
    MiniDiffSignChange  = { fg = c.git.change },
    MiniDiffSignDelete  = { fg = c.git.delete },
  }
end

-- ==== source: groups/mini_files.lua ====
local function get_mini_files(c)
  -- stylua: ignore
  return {
    MiniFilesBorder         = "FloatBorder",
    MiniFilesBorderModified = "DiagnosticFloatingWarn",
    MiniFilesCursorLine     = "CursorLine",
    MiniFilesDirectory      = "Directory",
    MiniFilesFile           = { fg = c.fg_float },
    MiniFilesNormal         = "NormalFloat",
    MiniFilesTitle          = "FloatTitle",
    MiniFilesTitleFocused   = { fg = c.border_highlight, bg = c.bg_float, bold = true },
  }
end

-- ==== source: groups/mini_hipatterns.lua ====
local function get_mini_hipatterns(c)
  -- stylua: ignore
  return {
    MiniHipatternsFixme = { fg = c.black, bg = c.error, bold = true },
    MiniHipatternsHack  = { fg = c.black, bg = c.warning, bold = true },
    MiniHipatternsNote  = { fg = c.black, bg = c.hint, bold = true },
    MiniHipatternsTodo  = { fg = c.black, bg = c.info, bold = true },
  }
end

-- ==== source: groups/mini_icons.lua ====
local function get_mini_icons(c)
  -- stylua: ignore
  return {
    MiniIconsGrey   = { fg = c.fg },
    MiniIconsPurple = { fg = c.purple },
    MiniIconsBlue   = { fg = c.blue },
    MiniIconsAzure  = { fg = c.info },
    MiniIconsCyan   = { fg = c.teal },
    MiniIconsGreen  = { fg = c.green },
    MiniIconsYellow = { fg = c.yellow },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsRed    = { fg = c.red },
  }
end

-- ==== source: groups/mini_indentscope.lua ====
local function get_mini_indentscope(c)
  -- stylua: ignore
  return {
    MiniIndentscopeSymbol = { fg = c.blue1, nocombine = true },
    MiniIndentscopePrefix = { nocombine = true }, -- Make it invisible
  }
end

-- ==== source: groups/mini_jump.lua ====
local function get_mini_jump(c)
  -- stylua: ignore
  return {
    MiniJump             = { bg = c.magenta2, fg = "#ffffff" },
    MiniJump2dDim        = "Comment",
    MiniJump2dSpot       = { fg = c.magenta2, bold = true, nocombine = true },
    MiniJump2dSpotAhead  = { fg = c.hint, bg = c.bg_dark, nocombine = true },
    MiniJump2dSpotUnique = { fg = c.orange, bold = true, nocombine = true },
  }
end

-- ==== source: groups/mini_map.lua ====
local function get_mini_map(c)
  -- stylua: ignore
  return {
    MiniMapNormal      = "NormalFloat",
    MiniMapSymbolCount = "Special",
    MiniMapSymbolLine  = "Title",
    MiniMapSymbolView  = "Delimiter",
  }
end

-- ==== source: groups/mini_notify.lua ====
local function get_mini_notify(c)
  -- stylua: ignore
  return {
    MiniNotifyBorder = "FloatBorder",
    MiniNotifyNormal = "NormalFloat",
    MiniNotifyTitle = "FloatTitle",
  }
end

-- ==== source: groups/mini_operators.lua ====
local function get_mini_operators(c)
  -- stylua: ignore
  return {
    MiniOperatorsExchangeFrom = "IncSearch",
  }
end

-- ==== source: groups/mini_pick.lua ====
local function get_mini_pick(c)
  -- stylua: ignore
  return {
    MiniPickBorder        = "FloatBorder",
    MiniPickBorderBusy    = "DiagnosticFloatingWarn",
    MiniPickBorderText    = { fg = c.hint, bg = c.bg_float },
    MiniPickIconDirectory = "Directory",
    MiniPickIconFile      = "MiniPickNormal",
    MiniPickHeader        = "DiagnosticFloatingHint",
    MiniPickMatchCurrent  = "CursorLine",
    MiniPickMatchMarked   = "Visual",
    MiniPickMatchRanges   = "DiagnosticFloatingHint",
    MiniPickNormal        = "NormalFloat",
    MiniPickPreviewLine   = "CursorLine",
    MiniPickPreviewRegion = "IncSearch",
    MiniPickPrompt        = { fg = c.info, bg = c.bg_float },
  }
end

-- ==== source: groups/mini_starter.lua ====
local function get_mini_starter(c, opts)
  -- stylua: ignore
  return {
    MiniStarterCurrent    = { nocombine = true },
    MiniStarterFooter     = { fg = c.yellow, italic = true },
    MiniStarterHeader     = { fg = c.blue },
    MiniStarterInactive   = { fg = c.comment, style = opts.styles.comments },
    MiniStarterItem       = { fg = c.fg, bg = opts.transparent and c.none or c.bg },
    MiniStarterItemBullet = { fg = c.border_highlight },
    MiniStarterItemPrefix = { fg = c.warning },
    MiniStarterQuery      = { fg = c.info },
    MiniStarterSection    = { fg = c.blue1 },
  }
end

-- ==== source: groups/mini_statusline.lua ====
local function get_mini_statusline(c)
  -- stylua: ignore
  return {
    MiniStatuslineDevinfo     = { fg = c.fg_dark, bg = c.fg_gutter },
    MiniStatuslineFileinfo    = { fg = c.fg_dark, bg = c.fg_gutter },
    MiniStatuslineFilename    = { fg = c.fg_dark, bg = c.bg_highlight },
    MiniStatuslineInactive    = { fg = c.blue, bg = c.bg_statusline },
    MiniStatuslineModeCommand = { fg = c.black, bg = c.yellow, bold = true },
    MiniStatuslineModeInsert  = { fg = c.black, bg = c.green, bold = true },
    MiniStatuslineModeNormal  = { fg = c.black, bg = c.blue, bold = true },
    MiniStatuslineModeOther   = { fg = c.black, bg = c.teal, bold = true },
    MiniStatuslineModeReplace = { fg = c.black, bg = c.red, bold = true },
    MiniStatuslineModeVisual  = { fg = c.black, bg = c.magenta, bold = true },
  }
end

-- ==== source: groups/mini_surround.lua ====
local function get_mini_surround(c)
  -- stylua: ignore
  return {
    MiniSurround = { bg = c.orange, fg = c.black },
  }
end

-- ==== source: groups/mini_tabline.lua ====
local function get_mini_tabline(c)
  -- stylua: ignore
  return {
    MiniTablineCurrent         = { fg = c.fg, bg = c.fg_gutter },
    MiniTablineFill            = { bg = c.black },
    MiniTablineHidden          = { fg = c.dark5, bg = c.bg_statusline },
    MiniTablineModifiedCurrent = { fg = c.warning, bg = c.fg_gutter },
    MiniTablineModifiedHidden  = { bg = c.bg_statusline, fg = Util.blend_bg(c.warning, 0.7) },
    MiniTablineModifiedVisible = { fg = c.warning, bg = c.bg_statusline },
    MiniTablineTabpagesection  = { bg = c.fg_gutter, fg = c.none },
    MiniTablineVisible         = { fg = c.fg, bg = c.bg_statusline },
  }
end

-- ==== source: groups/mini_test.lua ====
local function get_mini_test(c)
  -- stylua: ignore
  return {
    MiniTestEmphasis = { bold = true },
    MiniTestFail = { fg = c.red, bold = true },
    MiniTestPass = { fg = c.green, bold = true },
  }
end

-- ==== source: groups/mini_trailspace.lua ====
local function get_mini_trailspace(c)
  -- stylua: ignore
  return {
    MiniTrailspace = { bg = c.red },
  }
end

-- ----------------------------------------------------------------------------
-- Assemble theme (mirrors tokyonight groups/init.lua's simple merge-by-key)
-- ----------------------------------------------------------------------------
local tbl = {}

local function merge(fn, ...)
	for k, v in pairs(fn(...)) do
		tbl[k] = v
	end
end

-- always-on groups
merge(get_base, C, O)
merge(get_kinds)
merge(get_semantic_tokens, C)
merge(get_treesitter, C, O)

-- plugin groups (the set tokyonight enables automatically for a lazy.nvim
-- setup that has these plugins installed)
merge(get_alpha, C, O)
merge(get_blink, C, O)
merge(get_cmp, C, O)
merge(get_dap, C, O)
merge(get_dashboard, C, O)
merge(get_flash, C, O)
merge(get_fzf, C)
merge(get_gitsigns, C, O)
merge(get_illuminate, C)
merge(get_indent_blankline, C, O)
merge(get_neogit, C)
merge(get_neo_tree, C, O)
merge(get_nvim_tree, C, O)
merge(get_rainbow, C, O)
merge(get_telescope, C, O)
merge(get_treesitter_context, C)
merge(get_mini_animate, C)
merge(get_mini_clue, C)
merge(get_mini_completion, C)
merge(get_mini_cursorword, C)
merge(get_mini_deps, C)
merge(get_mini_diff, C)
merge(get_mini_files, C)
merge(get_mini_hipatterns, C)
merge(get_mini_icons, C)
merge(get_mini_indentscope, C)
merge(get_mini_jump, C)
merge(get_mini_map, C)
merge(get_mini_notify, C)
merge(get_mini_operators, C)
merge(get_mini_pick, C)
merge(get_mini_starter, C, O)
merge(get_mini_statusline, C)
merge(get_mini_surround, C)
merge(get_mini_tabline, C)
merge(get_mini_test, C)
merge(get_mini_trailspace, C)

-- ----------------------------------------------------------------------------
-- Apply (mirrors util.lua's M.resolve + theme.lua's M.setup loop)
-- ----------------------------------------------------------------------------
for group, hl in pairs(tbl) do
	hl = type(hl) == "string" and { link = hl } or hl
	if type(hl.style) == "table" then
		for k, v in pairs(hl.style) do
			hl[k] = v
		end
		hl.style = nil
	end
	vim.api.nvim_set_hl(0, group, hl)
end

-- ----------------------------------------------------------------------------
-- Terminal colors — tokyonight's default is terminal_colors = true
-- ----------------------------------------------------------------------------
if O.terminal_colors then
	vim.g.terminal_color_0 = C.terminal.black
	vim.g.terminal_color_8 = C.terminal.black_bright
	vim.g.terminal_color_7 = C.terminal.white
	vim.g.terminal_color_15 = C.terminal.white_bright
	vim.g.terminal_color_1 = C.terminal.red
	vim.g.terminal_color_9 = C.terminal.red_bright
	vim.g.terminal_color_2 = C.terminal.green
	vim.g.terminal_color_10 = C.terminal.green_bright
	vim.g.terminal_color_3 = C.terminal.yellow
	vim.g.terminal_color_11 = C.terminal.yellow_bright
	vim.g.terminal_color_4 = C.terminal.blue
	vim.g.terminal_color_12 = C.terminal.blue_bright
	vim.g.terminal_color_5 = C.terminal.magenta
	vim.g.terminal_color_13 = C.terminal.magenta_bright
	vim.g.terminal_color_6 = C.terminal.cyan
	vim.g.terminal_color_14 = C.terminal.cyan_bright
end
