-- ============================================================================
-- catppuccin-mocha.lua — standalone, vendored port of Catppuccin (Mocha)
--
-- This is a self-contained colors/ file: it does NOT require the catppuccin
-- plugin to be installed. It bakes in the Mocha palette, the default
-- catppuccin options, and the exact highlight-group tables from upstream
-- catppuccin/nvim (editor, lsp, syntax, semantic_tokens, treesitter, terminal)
-- plus the integrations that are enabled by default upstream:
-- alpha, blink.cmp, blink.indent, nvim-cmp, nvim-dap, nvim-dap-ui, dashboard-nvim,
-- dropbar, flash.nvim, fzf-lua, gitsigns, vim-illuminate, indent-blankline,
-- mini.nvim, neogit, neo-tree, nvim-tree, rainbow-delimiters, telescope,
-- nvim-treesitter-context, nvim-ufo.
--
-- Put this file at: ~/.config/nvim/colors/catppuccin-mocha-minimal.lua
-- Then: :colorscheme catppuccin-mocha-minimal
--
-- Edit freely below — this is now yours.
-- ============================================================================

vim.o.termguicolors = true
if vim.g.colors_name then
	vim.cmd("hi clear")
end
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "catppuccin-mocha-minimal"

-- ----------------------------------------------------------------------------
-- Palette (Mocha) — verbatim from catppuccin/nvim palettes/mocha.lua
-- ----------------------------------------------------------------------------
local C = {
    rosewater = "#ABB2BF",
    flamingo  = "#ABB2BF",
    pink      = "#ABB2BF",
    mauve     = "#ABB2BF",
    red       = "#ABB2BF",
    maroon    = "#ABB2BF",
    peach     = "#ABB2BF",
    yellow    = "#ABB2BF",
    green     = "#ABB2BF",
    teal      = "#ABB2BF",
    sky       = "#ABB2BF",
    sapphire  = "#ABB2BF",
    blue      = "#ABB2BF",
    lavender  = "#ABB2BF",
    text      = "#ABB2BF",
    subtext1  = "#ABB2BF",
    subtext0  = "#ABB2BF",
    overlay2  = "#ABB2BF",
    overlay1  = "#ABB2BF",
    overlay0  = "#ABB2BF",
    surface2  = "#4B5263",
    surface1  = "#2C313C",
    surface0  = "#282C34",
    base      = "#1F2329",
    mantle    = "#181B20",
    crust     = "#14161A",
}

-- ----------------------------------------------------------------------------
-- Color utilities — verbatim (subset) from catppuccin/nvim utils/colors.lua
-- ----------------------------------------------------------------------------
local U = {}

local function hex_to_rgb(hex_str)
	local hex = "[abcdef0-9][abcdef0-9]"
	local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
	hex_str = string.lower(hex_str)
	assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))
	local red, green, blue = string.match(hex_str, pat)
	return { tonumber(red, 16), tonumber(green, 16), tonumber(blue, 16) }
end

function U.blend(fg, bg, alpha)
	bg = hex_to_rgb(bg)
	fg = hex_to_rgb(fg)
	local function blendChannel(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end
	return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

function U.darken(hex, amount, bg)
	return U.blend(hex, bg or "#000000", math.abs(amount))
end

function U.lighten(hex, amount, fg)
	return U.blend(hex, fg or "#ffffff", math.abs(amount))
end

-- Our flavour is permanently "mocha", so vary_color always resolves to the
-- provided default (the same result upstream produces for the mocha flavour
-- whenever a per-flavour override map doesn't contain a "mocha" key, which
-- is the case for every group table vendored below).
function U.vary_color(_palettes, default)
	return default
end

-- ----------------------------------------------------------------------------
-- Options — verbatim default_options from catppuccin/nvim init.lua
-- (only the fields actually consumed by the vendored group tables below)
-- ----------------------------------------------------------------------------
local O = {
	transparent_background = false,
	term_colors = false,
	no_italic = false,
	no_bold = false,
	no_underline = false,
	dim_inactive = {
		enabled = false,
		shade = "dark",
		percentage = 0.15,
	},
	float = {
		transparent = false,
		solid = false,
	},
	styles = {
		comments = {},
		conditionals = {},
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
	},
	lsp_styles = {
		virtual_text = {
			errors = { "italic" },
			hints = { "italic" },
			warnings = { "italic" },
			information = { "italic" },
			ok = { "italic" },
		},
		underlines = {
			errors = { "underline" },
			hints = { "underline" },
			warnings = { "underline" },
			information = { "underline" },
			ok = { "underline" },
		},
		inlay_hints = {
			background = true,
		},
	},
	integrations = {
		blink_cmp = { style = "bordered" },
		dropbar = { color_mode = false },
		mini = { indentscope_color = "overlay2" },
		illuminate = { lsp = false },
		indent_blankline = { colored_indent_levels = false },
		gitsigns = {},
	},
}

-- C.none / C.dim are injected by catppuccin's mapper.lua at load time;
-- reproduced here identically (dim_inactive is disabled by default so C.dim
-- is inert, but we compute it the same way for 100% fidelity).
C.none = "NONE"
C.dim = U.darken(C.base, O.dim_inactive.percentage, C.mantle)

-- ----------------------------------------------------------------------------
-- Highlight-group tables (vendored verbatim from catppuccin/nvim)
-- ----------------------------------------------------------------------------
-- ==== source: groups/editor.lua ====
local function get_editor()
	local pumsolid = O.float.solid
	if vim.fn.has "nvim-0.12" == 1 then pumsolid = vim.o.pumborder == "solid" end

	return {
		ColorColumn = { bg = C.surface0 }, -- used for the columns set with 'colorcolumn'
		Conceal = { fg = C.overlay1 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor = { fg = C.base, bg = C.rosewater }, -- character under the cursor
		lCursor = { fg = C.base, bg = C.rosewater }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		CursorIM = { fg = C.base, bg = C.rosewater }, -- like Cursor, but used when in IME mode |CursorIM|
		CursorColumn = { bg = C.mantle }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine = {
			bg = U.vary_color({ latte = U.lighten(C.mantle, 0.70, C.base) }, U.darken(C.surface0, 0.64, C.base)),
		}, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if forecrust (ctermfg OR guifg) is not set.
		Dimmed = { fg = C.overlay1 },
		Directory = { fg = C.blue }, -- directory names (and other special names in listings)
		EndOfBuffer = { fg = C.surface1 }, -- filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
		ErrorMsg = { fg = C.red, style = {} }, -- error messages on the command line, default style > (bold, italic)
		VertSplit = { fg = O.transparent_background and C.surface1 or C.crust }, -- the column separating vertically split windows
		Folded = { fg = C.blue, bg = O.transparent_background and C.none or C.surface1 }, -- line used for closed folds
		FoldColumn = { fg = C.overlay0 }, -- 'foldcolumn'
		SignColumn = { fg = C.surface1 }, -- column where |signs| are displayed
		SignColumnSB = { bg = C.crust, fg = C.surface1 }, -- column where |signs| are displayed
		Substitute = { bg = C.surface1, fg = U.vary_color({ latte = C.red }, C.pink) }, -- |:substitute| replacement text highlighting
		LineNr = { fg = C.overlay1 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr = { fg = C.lavender }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line. highlights the number in numberline.
		MatchParen = { fg = C.peach, bg = U.darken(C.surface1, 0.70, C.base), style = { "bold" } }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
		ModeMsg = { fg = C.text, style = {} }, -- 'showmode' message (e.g., "-- INSERT -- ") default style > (bold)
		-- MsgArea = { fg = C.text }, -- Area for messages and cmdline, don't set this highlight because of https://github.com/neovim/neovim/issues/17832
		MsgSeparator = { link = "WinSeparator" }, -- Separator for scrolled messages, `msgsep` flag of 'display'
		MoreMsg = { fg = C.blue }, -- |more-prompt|
		NonText = { fg = C.overlay0 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		Normal = { fg = C.text, bg = O.transparent_background and C.none or C.base }, -- normal text
		NormalNC = {
			fg = C.text,
			bg = (O.transparent_background and O.dim_inactive.enabled and C.dim)
				or (O.dim_inactive.enabled and C.dim)
				or (O.transparent_background and C.none)
				or C.base,
		}, -- normal text in non-current windows
		NormalSB = { fg = C.text, bg = C.crust }, -- normal text in non-current windows
		NormalFloat = { fg = C.text, bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.mantle }, -- Normal text in floating windows.
		FloatBorder = O.float.solid
				and ((O.float.transparent and vim.o.winblend == 0) and { fg = C.surface2, bg = C.none } or {
					fg = C.mantle,
					bg = C.mantle,
				})
			or { fg = C.blue, bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.mantle },
		FloatTitle = O.float.solid and {
			fg = C.crust,
			bg = C.lavender,
		} or { fg = C.subtext0, bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.mantle }, -- Title of floating windows
		FloatShadow = { bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.overlay0, blend = 80 },
		FloatShadowThrough = {
			bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.overlay0,
			blend = 100,
		},
		OkMsg = { fg = C.green }, -- success messages on the command line
		Pmenu = {
			bg = (O.transparent_background and vim.o.pumblend == 0) and C.none or C.mantle,
			fg = C.overlay2,
		}, -- Popup menu: normal item.
		PmenuBorder = {
			bg = (O.transparent_background and vim.o.pumblend == 0) and C.none or C.mantle,
			fg = pumsolid and ((O.transparent_background and vim.o.pumblend == 0) and C.none or C.mantle) or C.blue,
		}, -- Popup menu: border
		PmenuSel = { bg = C.surface0, style = { "bold" } }, -- Popup menu: selected item.
		PmenuMatch = { fg = C.text, style = { "bold" } }, -- Popup menu: matching text.
		PmenuMatchSel = { style = { "bold" } }, -- Popup menu: matching text in selected item; is combined with |hl-PmenuMatch| and |hl-PmenuSel|.
		PmenuSbar = { bg = C.surface0 }, -- Popup menu: scrollbar.
		PmenuThumb = { bg = C.overlay0 }, -- Popup menu: Thumb of the scrollbar.
		PmenuExtra = { fg = C.overlay0 }, -- Popup menu: normal item extra text.
		PmenuExtraSel = {
			bg = C.surface0,
			fg = C.overlay0,
			style = { "bold" },
		}, -- Popup menu: selected item extra text.
		ComplMatchIns = { link = "PreInsert" }, -- Matched text of the currently inserted completion.
		PreInsert = { fg = C.overlay2 }, -- Text inserted when "preinsert" is in 'completeopt'.
		ComplHint = { fg = C.subtext0 }, -- Virtual text of the currently selected completion.
		ComplHintMore = { link = "Question" }, -- The additional information of the virtual text.
		Question = { fg = C.blue }, -- |hit-enter| prompt and yes/no questions
		QuickFixLine = { bg = U.darken(C.surface1, 0.70, C.base), style = { "bold" } }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search = { bg = U.darken(C.sky, 0.30, C.base), fg = C.text }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
		IncSearch = { bg = U.darken(C.sky, 0.90, C.base), fg = C.mantle }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		CurSearch = { bg = C.red, fg = C.mantle }, -- 'cursearch' highlighting: highlights the current search you're on differently
		SpecialKey = { link = "NonText" }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' textspace. |hl-Whitespace|
		SpellBad = { sp = C.red, style = { "undercurl" } }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		SpellCap = { sp = C.yellow, style = { "undercurl" } }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		SpellLocal = { sp = C.blue, style = { "undercurl" } }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		SpellRare = { sp = C.green, style = { "undercurl" } }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine = { fg = C.text, bg = O.transparent_background and C.none or C.mantle }, -- status line of current window
		StatusLineNC = { fg = C.surface1, bg = O.transparent_background and C.none or C.mantle }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
		TabLine = { bg = C.crust, fg = C.overlay0 }, -- tab pages line, not active tab page label
		TabLineFill = { bg = O.transparent_background and C.none or C.mantle }, -- tab pages line, where there are no labels
		TabLineSel = { link = "Normal" }, -- tab pages line, active tab page label
		TermCursor = { fg = C.base, bg = C.rosewater }, -- cursor in a focused terminal
		TermCursorNC = { fg = C.base, bg = C.overlay2 }, -- cursor in unfocused terminals
		Title = { fg = C.blue, style = { "bold" } }, -- titles for output from ":set all", ":autocmd" etc.
		Visual = { bg = C.surface1, style = { "bold" } }, -- Visual mode selection
		VisualNOS = { bg = C.surface1, style = { "bold" } }, -- Visual mode selection when vim is "Not Owning the Selection".
		WarningMsg = { fg = C.yellow }, -- warning messages
		Whitespace = { fg = C.surface1 }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
		WildMenu = { bg = C.overlay0 }, -- current match in 'wildmenu' completion
		WinBar = { fg = C.rosewater },
		WinBarNC = { link = "WinBar" },
		WinSeparator = { fg = O.transparent_background and C.surface1 or C.crust },
	}
end

-- ==== source: groups/lsp.lua ====
local function get_lsp()
	local virtual_text = O.lsp_styles.virtual_text
	local underlines = O.lsp_styles.underlines
	local inlay_hints = O.lsp_styles.inlay_hints

	local error = C.red
	local warning = C.yellow
	local info = C.sky
	local hint = C.teal
	local ok = C.green
	local darkening_percentage = 0.095

	return {
		-- These groups are for the native LSP client. Some other LSP clients may
		-- use these groups, or use their own. Consult your LSP client's
		-- documentation.
		LspReferenceText = { bg = C.surface1 }, -- used for highlighting "text" references
		LspReferenceRead = { bg = C.surface1 }, -- used for highlighting "read" references
		LspReferenceWrite = { bg = C.surface1 }, -- used for highlighting "write" references
		-- highlight diagnostics in numberline

		DiagnosticVirtualTextError = {
			bg = O.transparent_background and C.none or U.darken(error, darkening_percentage, C.base),
			fg = error,
			style = virtual_text.errors,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextWarn = {
			bg = O.transparent_background and C.none or U.darken(warning, darkening_percentage, C.base),
			fg = warning,
			style = virtual_text.warnings,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextInfo = {
			bg = O.transparent_background and C.none or U.darken(info, darkening_percentage, C.base),
			fg = info,
			style = virtual_text.information,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextHint = {
			bg = O.transparent_background and C.none or U.darken(hint, darkening_percentage, C.base),
			fg = hint,
			style = virtual_text.hints,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticVirtualTextOk = {
			bg = O.transparent_background and C.none or U.darken(hint, darkening_percentage, C.base),
			fg = ok,
			style = virtual_text.ok,
		}, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

		DiagnosticError = { bg = C.none, fg = error, style = virtual_text.errors }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticWarn = { bg = C.none, fg = warning, style = virtual_text.warnings }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticInfo = { bg = C.none, fg = info, style = virtual_text.information }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticHint = { bg = C.none, fg = hint, style = virtual_text.hints }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default
		DiagnosticOk = { bg = C.none, fg = ok, style = virtual_text.ok }, -- Used as the mantle highlight group. Other Diagnostic highlights link to this by default

		DiagnosticUnderlineError = { style = underlines.errors, sp = error }, -- Used to underline "Error" diagnostics
		DiagnosticUnderlineWarn = { style = underlines.warnings, sp = warning }, -- Used to underline "Warn" diagnostics
		DiagnosticUnderlineInfo = { style = underlines.information, sp = info }, -- Used to underline "Info" diagnostics
		DiagnosticUnderlineHint = { style = underlines.hints, sp = hint }, -- Used to underline "Hint" diagnostics
		DiagnosticUnderlineOk = { style = underlines.ok, sp = ok }, -- Used to underline "Ok" diagnostics

		DiagnosticFloatingError = { fg = error }, -- Used to color "Error" diagnostic messages in diagnostics float
		DiagnosticFloatingWarn = { fg = warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
		DiagnosticFloatingInfo = { fg = info }, -- Used to color "Info" diagnostic messages in diagnostics float
		DiagnosticFloatingHint = { fg = hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
		DiagnosticFloatingOk = { fg = ok }, -- Used to color "Ok" diagnostic messages in diagnostics float

		DiagnosticSignError = { fg = error }, -- Used for "Error" signs in sign column
		DiagnosticSignWarn = { fg = warning }, -- Used for "Warn" signs in sign column
		DiagnosticSignInfo = { fg = info }, -- Used for "Info" signs in sign column
		DiagnosticSignHint = { fg = hint }, -- Used for "Hint" signs in sign column
		DiagnosticSignOk = { fg = ok }, -- Used for "Ok" signs in sign column

		LspDiagnosticsDefaultError = { fg = error }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultWarning = { fg = warning }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultInformation = { fg = info }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspDiagnosticsDefaultHint = { fg = hint }, -- Used as the mantle highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		LspSignatureActiveParameter = { bg = C.surface0, style = { "bold" } },
		-- LspDiagnosticsFloatingError         = { }, -- Used to color "Error" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingWarning       = { }, -- Used to color "Warning" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingInformation   = { }, -- Used to color "Information" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingHint          = { }, -- Used to color "Hint" diagnostic messages in diagnostics float

		LspDiagnosticsError = { fg = error },
		LspDiagnosticsWarning = { fg = warning },
		LspDiagnosticsInformation = { fg = info },
		LspDiagnosticsHint = { fg = hint },
		LspDiagnosticsVirtualTextError = { fg = error, style = virtual_text.errors }, -- Used for "Error" diagnostic virtual text
		LspDiagnosticsVirtualTextWarning = { fg = warning, style = virtual_text.warnings }, -- Used for "Warning" diagnostic virtual text
		LspDiagnosticsVirtualTextInformation = { fg = info, style = virtual_text.warnings }, -- Used for "Information" diagnostic virtual text
		LspDiagnosticsVirtualTextHint = { fg = hint, style = virtual_text.hints }, -- Used for "Hint" diagnostic virtual text
		LspDiagnosticsUnderlineError = { style = underlines.errors, sp = error }, -- Used to underline "Error" diagnostics
		LspDiagnosticsUnderlineWarning = { style = underlines.warnings, sp = warning }, -- Used to underline "Warning" diagnostics
		LspDiagnosticsUnderlineInformation = { style = underlines.information, sp = info }, -- Used to underline "Information" diagnostics
		LspDiagnosticsUnderlineHint = { style = underlines.hints, sp = hint }, -- Used to underline "Hint" diagnostics
		LspCodeLens = { fg = C.overlay0 }, -- virtual text of the codelens
		LspCodeLensSeparator = { link = "LspCodeLens" }, -- virtual text of the codelens separators
		LspInlayHint = {
			-- fg of `Comment`
			fg = C.overlay0,
			-- bg of `CursorLine`
			bg = (O.transparent_background or not inlay_hints.background) and C.none
				or U.vary_color({ latte = U.lighten(C.mantle, 0.70, C.base) }, U.darken(C.surface0, 0.64, C.base)),
		}, -- virtual text of the inlay hints
		LspInfoBorder = { link = "FloatBorder" }, -- LspInfo border
	}
end

-- ==== source: groups/syntax.lua ====
local function get_syntax()
	return {
		Comment = { fg = C.overlay2, style = O.styles.comments }, -- just comments
		SpecialComment = { link = "Special" }, -- special things inside a comment
		Constant = { fg = C.peach }, -- (preferred) any constant
		String = { fg = C.green, style = O.styles.strings or {} }, -- a string constant: "this is a string"
		Character = { fg = C.teal }, --  a character constant: 'c', '\n'
		Number = { fg = C.peach, style = O.styles.numbers or {} }, --   a number constant: 234, 0xff
		Float = { link = "Number" }, --    a floating point constant: 2.3e10
		Boolean = { fg = C.peach, style = O.styles.booleans or {} }, --  a boolean constant: TRUE, false
		Identifier = { fg = C.flamingo, style = O.styles.variables or {} }, -- (preferred) any variable name
		Function = { fg = C.blue, style = O.styles.functions or {} }, -- function name (also: methods for classes)
		Statement = { fg = C.mauve }, -- (preferred) any statement
		Conditional = { fg = C.mauve, style = O.styles.conditionals or {} }, --  if, then, else, endif, switch, etc.
		Repeat = { fg = C.mauve, style = O.styles.loops or {} }, --   for, do, while, etc.
		Label = { fg = C.sapphire }, --    case, default, etc.
		Operator = { fg = C.sky, style = O.styles.operators or {} }, -- "sizeof", "+", "*", etc.
		Keyword = { fg = C.mauve, style = O.styles.keywords or {} }, --  any other keyword
		Exception = { fg = C.mauve, style = O.styles.keywords or {} }, --  try, catch, throw

		PreProc = { fg = C.pink }, -- (preferred) generic Preprocessor
		Include = { fg = C.mauve, style = O.styles.keywords or {} }, --  preprocessor #include
		Define = { link = "PreProc" }, -- preprocessor #define
		Macro = { fg = C.mauve }, -- same as Define
		PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

		StorageClass = { fg = C.yellow }, -- static, register, volatile, etc.
		Structure = { fg = C.yellow }, --  struct, union, enum, etc.
		Special = { fg = C.pink }, -- (preferred) any special symbol
		Type = { fg = C.yellow, style = O.styles.types or {} }, -- (preferred) int, long, char, etc.
		Typedef = { link = "Type" }, --  A typedef
		SpecialChar = { link = "Special" }, -- special character in a constant
		Tag = { fg = C.lavender, style = { "bold" } }, -- you can use CTRL-] on this
		Delimiter = { fg = C.overlay2 }, -- character that needs attention
		Debug = { link = "Special" }, -- debugging statements

		Underlined = { style = { "underline" } }, -- (preferred) text that stands out, HTML links
		Bold = { style = { "bold" } },
		Italic = { style = { "italic" } },
		-- ("Ignore", below, may be invisible...)
		-- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|

		Error = { fg = C.red }, -- (preferred) any erroneous construct
		Todo = { bg = C.flamingo, fg = C.base, style = { "bold" } }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
		qfLineNr = { fg = C.yellow },
		qfFileName = { fg = C.blue },
		htmlH1 = { fg = C.pink, style = { "bold" } },
		htmlH2 = { fg = C.blue, style = { "bold" } },
		-- mkdHeading = { fg = C.peach, style = { "bold" } },
		-- mkdCode = { bg = C.terminal_black, fg = C.text },
		mkdCodeDelimiter = { bg = C.base, fg = C.text },
		mkdCodeStart = { fg = C.flamingo, style = { "bold" } },
		mkdCodeEnd = { fg = C.flamingo, style = { "bold" } },
		-- mkdLink = { fg = C.blue, style = { "underline" } },

		-- debugging
		debugPC = { bg = O.transparent_background and C.none or C.crust }, -- used for highlighting the current line in terminal-debug
		debugBreakpoint = { bg = C.base, fg = C.overlay0 }, -- used for breakpoint colors in terminal-debug
		-- illuminate
		illuminatedWord = { bg = C.surface1 },
		illuminatedCurWord = { bg = C.surface1 },
		-- diff
		Added = { fg = C.green },
		Changed = { fg = C.blue },
		diffAdded = { fg = C.green },
		diffRemoved = { fg = C.red },
		diffChanged = { fg = C.blue },
		diffOldFile = { fg = C.yellow },
		diffNewFile = { fg = C.peach },
		diffFile = { fg = C.blue },
		diffLine = { fg = C.overlay0 },
		diffIndexLine = { fg = C.teal },
		DiffAdd = { bg = U.darken(C.green, 0.18, C.base) }, -- diff mode: Added line |diff.txt|
		DiffChange = { bg = U.darken(C.blue, 0.07, C.base) }, -- diff mode: Changed line |diff.txt|
		DiffDelete = { bg = U.darken(C.red, 0.18, C.base) }, -- diff mode: Deleted line |diff.txt|
		DiffText = { bg = U.darken(C.blue, 0.30, C.base) }, -- diff mode: Changed text within a changed line |diff.txt|
		-- NeoVim
		healthError = { fg = C.red },
		healthSuccess = { fg = C.teal },
		healthWarning = { fg = C.yellow },
		-- misc

		-- glyphs
		GlyphPalette1 = { fg = C.red },
		GlyphPalette2 = { fg = C.teal },
		GlyphPalette3 = { fg = C.yellow },
		GlyphPalette4 = { fg = C.blue },
		GlyphPalette6 = { fg = C.teal },
		GlyphPalette7 = { fg = C.text },
		GlyphPalette9 = { fg = C.red },

		-- rainbow
		rainbow1 = { fg = C.red },
		rainbow2 = { fg = C.peach },
		rainbow3 = { fg = C.yellow },
		rainbow4 = { fg = C.green },
		rainbow5 = { fg = C.sapphire },
		rainbow6 = { fg = C.lavender },

		-- csv
		csvCol0 = { fg = C.red },
		csvCol1 = { fg = C.peach },
		csvCol2 = { fg = C.yellow },
		csvCol3 = { fg = C.green },
		csvCol4 = { fg = C.sky },
		csvCol5 = { fg = C.blue },
		csvCol6 = { fg = C.lavender },
		csvCol7 = { fg = C.mauve },
		csvCol8 = { fg = C.pink },

		-- markdown
		markdownHeadingDelimiter = { fg = C.peach, style = { "bold" } },
		markdownCode = { fg = C.flamingo },
		markdownCodeBlock = { fg = C.flamingo },
		markdownLinkText = { fg = C.blue, style = { "underline" } },
		markdownH1 = { link = "rainbow1" },
		markdownH2 = { link = "rainbow2" },
		markdownH3 = { link = "rainbow3" },
		markdownH4 = { link = "rainbow4" },
		markdownH5 = { link = "rainbow5" },
		markdownH6 = { link = "rainbow6" },
	}
end

-- ==== source: groups/semantic_tokens.lua ====
local function get_semantic_tokens()
	if vim.treesitter.highlighter.hl_map then
		vim.notify_once(
			[[Catppuccin (info):
semantic_tokens integration requires neovim 0.8
If you want to stay on nvim 0.7, pin catppuccin tag to v0.2.4 and nvim-treesitter commit to 4cccb6f494eb255b32a290d37c35ca12584c74d0.
]],
			vim.log.levels.INFO
		)
		return {}
	end
	return {
		-- https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight
		-- Most semantic tokens (@lsp.type.<...>) are no longer defined in this file, as Neovim links to already themed Tree-sitter captures by default.

		-- lsp's are able to detect enum members where treesitter often cannot
		["@lsp.type.enumMember"] = { fg = C.teal },
		-- we assume treesitter can already handle this
		-- - treesitter can detect variables in buffers
		-- - lsp does not need responsibility for this, in fact it can be less
		--   accurate in cases
		["@lsp.type.variable"] = {},

		-- in cases where the lsp can be more specific than treesitter, we should
		-- allow lsp to override treesitter
		["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.function.builtin"] = { link = "@function.builtin" },
	}
end

-- ==== source: groups/treesitter.lua ====
local function get_treesitter()
	if vim.treesitter.highlighter.hl_map then
		vim.notify_once(
			[[Catppuccin (info):
nvim-treesitter integration requires neovim 0.8
If you want to stay on nvim 0.7, pin catppuccin tag to v0.2.4 and nvim-treesitter commit to 4cccb6f494eb255b32a290d37c35ca12584c74d0.
]],
			vim.log.levels.INFO
		)
		return {}
	end

	local colors = { -- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
		-- Identifiers
		["@variable"] = { fg = C.text, style = O.styles.variables or {} }, -- Any variable name that does not have another highlight.
		["@variable.builtin"] = { fg = C.red, style = O.styles.properties or {} }, -- Variable names that are defined by the languages, like this or self.
		["@variable.parameter"] = { fg = C.maroon, style = O.styles.variables or {} }, -- For parameters of a function.
		["@variable.member"] = { fg = C.lavender }, -- For fields.

		["@constant"] = { link = "Constant" }, -- For constants
		["@constant.builtin"] = { fg = C.peach, style = O.styles.keywords or {} }, -- For constant that are built in the language: nil in Lua.
		["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

		["@module"] = { fg = C.yellow, style = O.styles.miscs or { "italic" } }, -- For identifiers referring to modules and namespaces.
		["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

		-- Literals
		["@string"] = { link = "String" }, -- For strings.
		["@string.documentation"] = { fg = C.teal, style = O.styles.strings or {} }, -- For strings documenting code (e.g. Python docstrings).
		["@string.regexp"] = { fg = C.pink, style = O.styles.strings or {} }, -- For regexes.
		["@string.escape"] = { fg = C.pink, style = O.styles.strings or {} }, -- For escape characters within a string.
		["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
		["@string.special.path"] = { link = "Special" }, -- filenames
		["@string.special.symbol"] = { fg = C.flamingo }, -- symbols or atoms
		["@string.special.url"] = { fg = C.blue, style = { "italic", "underline" } }, -- urls, links and emails
		["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

		["@character"] = { link = "Character" }, -- character literals
		["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

		["@boolean"] = { link = "Boolean" }, -- For booleans.
		["@number"] = { link = "Number" }, -- For all numbers
		["@number.float"] = { link = "Float" }, -- For floats.

		-- Types
		["@type"] = { link = "Type" }, -- For types.
		["@type.builtin"] = { fg = C.mauve, style = O.styles.types or {} }, -- For builtin types.
		["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)

		["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
		["@property"] = { fg = C.lavender, style = O.styles.properties or {} }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

		-- Functions
		["@function"] = { link = "Function" }, -- For function (calls and definitions).
		["@function.builtin"] = { fg = C.peach, style = O.styles.functions or {} }, -- For builtin functions: table.insert in Lua.
		["@function.call"] = { link = "Function" }, -- function calls
		["@function.macro"] = { fg = C.pink, style = O.styles.functions or {} }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.

		["@function.method"] = { link = "Function" }, -- For method definitions.
		["@function.method.call"] = { link = "Function" }, -- For method calls.

		["@constructor"] = { fg = C.yellow }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
		["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

		-- Keywords
		["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
		["@keyword.modifier"] = { link = "Keyword" }, -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
		["@keyword.type"] = { link = "Keyword" }, -- For keywords describing composite types (e.g. `struct`, `enum`)
		["@keyword.coroutine"] = { link = "Keyword" }, -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
		["@keyword.function"] = { fg = C.mauve, style = O.styles.keywords or {} }, -- For keywords used to define a function.
		["@keyword.operator"] = { fg = C.mauve, style = O.styles.keywords or {} }, -- For new keyword operator
		["@keyword.import"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
		["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loops.
		["@keyword.return"] = { fg = C.mauve, style = O.styles.keywords or {} },
		["@keyword.debug"] = { link = "Exception" }, -- For keywords related to debugging
		["@keyword.exception"] = { link = "Exception" }, -- For exception related keywords.

		["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
		["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

		["@keyword.directive"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
		["@keyword.directive.define"] = { link = "Define" }, -- preprocessor definition directives
		-- JS & derivative
		["@keyword.export"] = { fg = C.mauve, style = O.styles.keywords },

		-- Punctuation
		["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
		["@punctuation.bracket"] = { fg = C.overlay2 }, -- For brackets and parenthesis.
		["@punctuation.special"] = { link = "Special" }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

		-- Comment
		["@comment"] = { link = "Comment" },
		["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

		["@comment.error"] = { fg = C.base, bg = C.red },
		["@comment.warning"] = { fg = C.base, bg = C.yellow },
		["@comment.hint"] = { fg = C.base, bg = C.blue },
		["@comment.todo"] = { fg = C.base, bg = C.flamingo },
		["@comment.note"] = { fg = C.base, bg = C.rosewater },

		-- Markup
		["@markup"] = { fg = C.text }, -- For strings considerated text in a markup language.
		["@markup.strong"] = { fg = C.red, style = { "bold" } }, -- bold
		["@markup.italic"] = { fg = C.red, style = { "italic" } }, -- italic
		["@markup.strikethrough"] = { fg = C.text, style = { "strikethrough" } }, -- strikethrough text
		["@markup.underline"] = { link = "Underlined" }, -- underlined text

		["@markup.heading"] = { fg = C.blue }, -- titles like: # Example
		["@markup.heading.markdown"] = { style = { "bold" } }, -- bold headings in markdown, but not in HTML or other markup

		["@markup.math"] = { fg = C.blue }, -- math environments (e.g. `$ ... $` in LaTeX)
		["@markup.quote"] = { fg = C.pink }, -- block quotes
		["@markup.environment"] = { fg = C.pink }, -- text environments of markup languages
		["@markup.environment.name"] = { fg = C.blue }, -- text indicating the type of an environment

		["@markup.link"] = { fg = C.lavender }, -- text references, footnotes, citations, etc.
		["@markup.link.label"] = { fg = C.lavender }, -- link, reference descriptions
		["@markup.link.url"] = { fg = C.blue, style = { "italic", "underline" } }, -- urls, links and emails

		["@markup.raw"] = { fg = C.green }, -- used for inline code in markdown and for doc in python (""")

		["@markup.list"] = { fg = C.teal },
		["@markup.list.checked"] = { fg = C.green }, -- todo notes
		["@markup.list.unchecked"] = { fg = C.overlay1 }, -- todo notes

		-- Diff
		["@diff.plus"] = { link = "diffAdded" }, -- added text (for diff files)
		["@diff.minus"] = { link = "diffRemoved" }, -- deleted text (for diff files)
		["@diff.delta"] = { link = "diffChanged" }, -- deleted text (for diff files)

		-- Tags
		["@tag"] = { fg = C.blue }, -- Tags like HTML tag names.
		["@tag.builtin"] = { fg = C.blue }, -- JSX tag names.
		["@tag.attribute"] = { fg = C.yellow, style = O.styles.miscs or { "italic" } }, -- XML/HTML attributes (foo in foo="bar").
		["@tag.delimiter"] = { fg = C.teal }, -- Tag delimiter like < > /

		-- Misc
		["@error"] = { link = "Error" },

		-- Language specific:

		-- Bash
		["@function.builtin.bash"] = { fg = C.red, style = O.styles.miscs or { "italic" } },
		["@variable.parameter.bash"] = { fg = C.green },

		-- markdown
		["@markup.heading.1.markdown"] = { link = "rainbow1" },
		["@markup.heading.2.markdown"] = { link = "rainbow2" },
		["@markup.heading.3.markdown"] = { link = "rainbow3" },
		["@markup.heading.4.markdown"] = { link = "rainbow4" },
		["@markup.heading.5.markdown"] = { link = "rainbow5" },
		["@markup.heading.6.markdown"] = { link = "rainbow6" },

		-- html
		["@markup.heading.html"] = { link = "@markup" },
		["@markup.heading.1.html"] = { link = "@markup" },
		["@markup.heading.2.html"] = { link = "@markup" },
		["@markup.heading.3.html"] = { link = "@markup" },
		["@markup.heading.4.html"] = { link = "@markup" },
		["@markup.heading.5.html"] = { link = "@markup" },
		["@markup.heading.6.html"] = { link = "@markup" },

		-- Java
		["@constant.java"] = { fg = C.teal },

		-- CSS
		["@property.css"] = { fg = C.blue },
		["@property.scss"] = { fg = C.blue },
		["@property.id.css"] = { fg = C.yellow },
		["@property.class.css"] = { fg = C.yellow },
		["@type.css"] = { fg = C.lavender },
		["@type.tag.css"] = { fg = C.blue },
		["@string.plain.css"] = { fg = C.text },
		["@number.css"] = { fg = C.peach },
		["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

		-- HTML
		["@string.special.url.html"] = { fg = C.green }, -- Links in href, src attributes.
		["@markup.link.label.html"] = { fg = C.text }, -- Text between <a></a> tags.
		["@character.special.html"] = { fg = C.red }, -- Symbols such as &nbsp;.

		-- Lua
		["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

		-- Python
		["@constructor.python"] = { fg = C.sky }, -- __init__(), __new__().

		-- YAML
		["@label.yaml"] = { fg = C.yellow }, -- Anchor and alias names.

		-- Ruby
		["@string.special.symbol.ruby"] = { fg = C.flamingo },

		-- PHP
		["@function.method.php"] = { link = "Function" },
		["@function.method.call.php"] = { link = "Function" },

		-- C/CPP
		["@keyword.import.c"] = { fg = C.yellow },
		["@keyword.import.cpp"] = { fg = C.yellow },

		-- C#
		["@attribute.c_sharp"] = { fg = C.yellow },

		-- gitcommit
		["@comment.warning.gitcommit"] = { fg = C.yellow },

		-- gitignore
		["@string.special.path.gitignore"] = { fg = C.text },

		-- Misc
		gitcommitSummary = { fg = C.rosewater, style = O.styles.miscs or { "italic" } },
		zshKSHFunction = { link = "Function" },
	}

	-- Legacy highlights
	colors["@parameter"] = colors["@variable.parameter"]
	colors["@field"] = colors["@variable.member"]
	colors["@namespace"] = colors["@module"]
	colors["@float"] = colors["@number.float"]
	colors["@symbol"] = colors["@string.special.symbol"]
	colors["@string.regex"] = colors["@string.regexp"]

	colors["@text"] = colors["@markup"]
	colors["@text.strong"] = colors["@markup.strong"]
	colors["@text.emphasis"] = colors["@markup.italic"]
	colors["@text.underline"] = colors["@markup.underline"]
	colors["@text.strike"] = colors["@markup.strikethrough"]
	colors["@text.uri"] = colors["@markup.link.url"]
	colors["@text.math"] = colors["@markup.math"]
	colors["@text.environment"] = colors["@markup.environment"]
	colors["@text.environment.name"] = colors["@markup.environment.name"]

	colors["@text.title"] = colors["@markup.heading"]
	colors["@text.literal"] = colors["@markup.raw"]
	colors["@text.reference"] = colors["@markup.link"]

	colors["@text.todo.checked"] = colors["@markup.list.checked"]
	colors["@text.todo.unchecked"] = colors["@markup.list.unchecked"]

	colors["@comment.note"] = colors["@comment.hint"]

	-- @text.todo is now for todo comments, not todo notes like in markdown
	colors["@text.todo"] = colors["@comment.todo"]
	colors["@text.warning"] = colors["@comment.warning"]
	colors["@text.note"] = colors["@comment.note"]
	colors["@text.danger"] = colors["@comment.error"]

	-- @text.uri is now
	-- > @markup.link.url in markup links
	-- > @string.special.url outside of markup
	colors["@text.uri"] = colors["@markup.link.uri"]

	colors["@method"] = colors["@function.method"]
	colors["@method.call"] = colors["@function.method.call"]

	colors["@text.diff.add"] = colors["@diff.plus"]
	colors["@text.diff.delete"] = colors["@diff.minus"]

	colors["@type.qualifier"] = colors["@keyword.modifier"]
	colors["@keyword.storage"] = colors["@keyword.modifier"]
	colors["@define"] = colors["@keyword.directive.define"]
	colors["@preproc"] = colors["@keyword.directive"]
	colors["@storageclass"] = colors["@keyword.storage"]
	colors["@conditional"] = colors["@keyword.conditional"]
	colors["@exception"] = colors["@keyword.exception"]
	colors["@include"] = colors["@keyword.import"]
	colors["@repeat"] = colors["@keyword.repeat"]

	colors["@symbol.ruby"] = colors["@string.special.symbol.ruby"]

	colors["@variable.member.yaml"] = colors["@field.yaml"]

	colors["@text.title.1.markdown"] = colors["@markup.heading.1.markdown"]
	colors["@text.title.2.markdown"] = colors["@markup.heading.2.markdown"]
	colors["@text.title.3.markdown"] = colors["@markup.heading.3.markdown"]
	colors["@text.title.4.markdown"] = colors["@markup.heading.4.markdown"]
	colors["@text.title.5.markdown"] = colors["@markup.heading.5.markdown"]
	colors["@text.title.6.markdown"] = colors["@markup.heading.6.markdown"]

	colors["@method.php"] = colors["@function.method.php"]
	colors["@method.call.php"] = colors["@function.method.call.php"]

	return colors
end

-- ==== source: groups/terminal.lua ====
local function get_terminal()
	return {
		terminal_color_0 = C.overlay0,
		terminal_color_8 = C.overlay1,

		terminal_color_1 = C.red,
		terminal_color_9 = C.red,

		terminal_color_2 = C.green,
		terminal_color_10 = C.green,

		terminal_color_3 = C.yellow,
		terminal_color_11 = C.yellow,

		terminal_color_4 = C.blue,
		terminal_color_12 = C.blue,

		terminal_color_5 = C.pink,
		terminal_color_13 = C.pink,

		terminal_color_6 = C.sky,
		terminal_color_14 = C.sky,

		terminal_color_7 = C.text,
		terminal_color_15 = C.text,
	}
end

-- ==== source: groups/integrations/alpha.lua ====
local function get_alpha()
	return {
		AlphaShortcut = { fg = C.green },
		AlphaHeader = { fg = C.blue },
		AlphaHeaderLabel = { fg = C.peach },
		AlphaButtons = { fg = C.lavender },
		AlphaFooter = { fg = C.yellow, style = { "italic" } },
	}
end

-- ==== source: groups/integrations/blink_cmp.lua ====
local function get_blink_cmp()
	local style = O.integrations.blink_cmp.style

	local highlights = {
		BlinkCmpLabel = { fg = C.overlay2 },
		BlinkCmpLabelDeprecated = { fg = C.overlay0, style = { "strikethrough" } },
		BlinkCmpKind = { fg = C.blue },
		BlinkCmpMenu = { link = "Pmenu" },
		BlinkCmpDoc = { link = "NormalFloat" },
		BlinkCmpLabelMatch = { link = "PmenuMatch" },
		BlinkCmpMenuSelection = { bg = C.surface1, style = { "bold" } },
		BlinkCmpScrollBarGutter = { bg = C.surface1 },
		BlinkCmpScrollBarThumb = { bg = C.overlay0 },
		BlinkCmpLabelDescription = { link = "PmenuExtra" },
		BlinkCmpLabelDetail = { link = "PmenuExtra" },
		BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },

		BlinkCmpKindText = { fg = C.green },
		BlinkCmpKindMethod = { fg = C.blue },
		BlinkCmpKindFunction = { fg = C.blue },
		BlinkCmpKindConstructor = { fg = C.blue },
		BlinkCmpKindField = { fg = C.green },
		BlinkCmpKindVariable = { fg = C.flamingo },
		BlinkCmpKindClass = { fg = C.yellow },
		BlinkCmpKindInterface = { fg = C.yellow },
		BlinkCmpKindModule = { fg = C.blue },
		BlinkCmpKindProperty = { fg = C.blue },
		BlinkCmpKindUnit = { fg = C.green },
		BlinkCmpKindValue = { fg = C.peach },
		BlinkCmpKindEnum = { fg = C.yellow },
		BlinkCmpKindKeyword = { fg = C.mauve },
		BlinkCmpKindSnippet = { fg = C.flamingo },
		BlinkCmpKindColor = { fg = C.red },
		BlinkCmpKindFile = { fg = C.blue },
		BlinkCmpKindReference = { fg = C.red },
		BlinkCmpKindFolder = { fg = C.blue },
		BlinkCmpKindEnumMember = { fg = C.teal },
		BlinkCmpKindConstant = { fg = C.peach },
		BlinkCmpKindStruct = { fg = C.blue },
		BlinkCmpKindEvent = { fg = C.blue },
		BlinkCmpKindOperator = { fg = C.sky },
		BlinkCmpKindTypeParameter = { fg = C.maroon },
		BlinkCmpKindCopilot = { fg = C.teal },
	}

	if style == "bordered" then
		-- uses FloatBorder.fg and Pmenu.bg
		highlights["BlinkCmpMenuBorder"] = {
			fg = C.blue,
			bg = (O.transparent_background and vim.o.pumblend == 0) and C.none or C.mantle,
		}
		highlights["BlinkCmpDocBorder"] = { link = "FloatBorder" }
	end

	return highlights
end

-- ==== source: groups/integrations/blink_indent.lua ====
local function get_blink_indent()
	return {
		BlinkIndent = { fg = C.surface0 },
		BlinkIndentScope = { fg = C.overlay2 },

		BlinkIndentRed = { fg = C.red },
		BlinkIndentOrange = { fg = C.peach },
		BlinkIndentYellow = { fg = C.yellow },
		BlinkIndentGreen = { fg = C.green },
		BlinkIndentCyan = { fg = C.sky },
		BlinkIndentBlue = { fg = C.blue },
		BlinkIndentViolet = { fg = C.mauve },

		BlinkIndentRedUnderline = { sp = C.red, style = { "underline" } },
		BlinkIndentOrangeUnderline = { sp = C.peach, style = { "underline" } },
		BlinkIndentYellowUnderline = { sp = C.yellow, style = { "underline" } },
		BlinkIndentGreenUnderline = { sp = C.green, style = { "underline" } },
		BlinkIndentCyanUnderline = { sp = C.sky, style = { "underline" } },
		BlinkIndentBlueUnderline = { sp = C.blue, style = { "underline" } },
		BlinkIndentVioletUnderline = { sp = C.mauve, style = { "underline" } },
	}
end

-- ==== source: groups/integrations/cmp.lua ====
local function get_cmp()
	return {
		CmpItemAbbr = { fg = C.overlay2 },
		CmpItemAbbrDeprecated = { fg = C.overlay0, style = { "strikethrough" } },
		CmpItemKind = { fg = C.blue },
		CmpItemMenu = { fg = C.text },
		CmpItemAbbrMatch = { fg = C.text, style = { "bold" } },
		CmpItemAbbrMatchFuzzy = { fg = C.text, style = { "bold" } },

		-- kind support
		CmpItemKindSnippet = { fg = C.mauve },
		CmpItemKindKeyword = { fg = C.red },
		CmpItemKindText = { fg = C.teal },
		CmpItemKindMethod = { fg = C.blue },
		CmpItemKindConstructor = { fg = C.blue },
		CmpItemKindFunction = { fg = C.blue },
		CmpItemKindFolder = { fg = C.blue },
		CmpItemKindModule = { fg = C.blue },
		CmpItemKindConstant = { fg = C.peach },
		CmpItemKindField = { fg = C.green },
		CmpItemKindProperty = { fg = C.green },
		CmpItemKindEnum = { fg = C.green },
		CmpItemKindUnit = { fg = C.green },
		CmpItemKindClass = { fg = C.yellow },
		CmpItemKindVariable = { fg = C.flamingo },
		CmpItemKindFile = { fg = C.blue },
		CmpItemKindInterface = { fg = C.yellow },
		CmpItemKindColor = { fg = C.red },
		CmpItemKindReference = { fg = C.red },
		CmpItemKindEnumMember = { fg = C.red },
		CmpItemKindStruct = { fg = C.blue },
		CmpItemKindValue = { fg = C.peach },
		CmpItemKindEvent = { fg = C.blue },
		CmpItemKindOperator = { fg = C.blue },
		CmpItemKindTypeParameter = { fg = C.blue },
		CmpItemKindCopilot = { fg = C.teal },
	}
end

-- ==== source: groups/integrations/dap.lua ====
local function get_dap()
	return {
		DapBreakpoint = { fg = C.red },
		DapBreakpointCondition = { fg = C.yellow },
		DapBreakpointRejected = { fg = C.mauve },
		DapLogPoint = { fg = C.sky },
		DapStopped = { fg = C.maroon },
	}
end

-- ==== source: groups/integrations/dap_ui.lua ====
local function get_dap_ui()
	return {
		DapUIScope = { fg = C.sky },
		DapUIType = { fg = C.mauve },
		DapUIValue = { fg = C.sky },
		DapUIVariable = { fg = C.text },
		DapUIModifiedValue = { fg = C.peach },
		DapUIDecoration = { fg = C.sky },
		DapUIThread = { fg = C.green },
		DapUIStoppedThread = { fg = C.sky },
		DapUISource = { fg = C.lavender },
		DapUILineNumber = { fg = C.sky },
		DapUIFloatBorder = { link = "FloatBorder" },

		DapUIWatchesEmpty = { fg = C.maroon },
		DapUIWatchesValue = { fg = C.green },
		DapUIWatchesError = { fg = C.maroon },

		DapUIBreakpointsPath = { fg = C.sky },
		DapUIBreakpointsInfo = { fg = C.green },
		DapUIBreakpointsCurrentLine = { fg = C.green, style = { "bold" } },
		DapUIBreakpointsDisabledLine = { fg = C.surface2 },

		DapUIStepOver = { fg = C.blue },
		DapUIStepOverNC = { link = "DapUIStepOver" },
		DapUIStepInto = { fg = C.blue },
		DapUIStepIntoNC = { link = "DapUIStepInto" },
		DapUIStepBack = { fg = C.blue },
		DapUIStepBackNC = { link = "DapUIStepBack" },
		DapUIStepOut = { fg = C.blue },
		DapUIStepOutNC = { link = "DapUIStepOut" },
		DapUIStop = { fg = C.red },
		DapUIStopNC = { link = "DapUIStop" },
		DapUIPlayPause = { fg = C.green },
		DapUIPlayPauseNC = { link = "DapUIPlayPause" },
		DapUIRestart = { fg = C.green },
		DapUIRestartNC = { link = "DapUIRestart" },
		DapUIUnavailable = { fg = C.surface1 },
		DapUIUnavailableNC = { link = "DapUIUnavailable" },

		DapUIWinSelect = { fg = C.peach },
	}
end

-- ==== source: groups/integrations/dashboard.lua ====
local function get_dashboard()
	return {
		DashboardShortCut = { fg = C.pink },
		DashboardHeader = { fg = C.blue },
		DashboardCenter = { fg = C.green },
		DashboardFooter = { fg = C.yellow, style = { "italic" } },
		DashboardMruTitle = { fg = C.sky },
		DashboardProjectTitle = { fg = C.sky },
		DashboardFiles = { fg = C.lavender },
		DashboardKey = { fg = C.peach },
		DashboardDesc = { fg = C.blue },
		DashboardIcon = { fg = C.pink, bold = true },
	}
end

-- ==== source: groups/integrations/dropbar.lua ====
local function get_dropbar()
	local color = O.integrations.dropbar.color_mode
	return {
		DropBarMenuHoverEntry = { link = "Visual" },
		DropBarMenuHoverIcon = { reverse = true },
		DropBarMenuHoverSymbol = { bold = true },
		DropBarIconUISeparator = { fg = C.overlay1 },
		DropBarKindArray = color and { link = "DropBarIconKindArray" } or { fg = C.text },
		DropBarKindBoolean = color and { link = "DropBarIconKindBoolean" } or { fg = C.text },
		DropBarKindBreakStatement = color and { link = "DropBarIconKindBreakStatement" } or { fg = C.text },
		DropBarKindCall = color and { link = "DropBarIconKindCall" } or { fg = C.text },
		DropBarKindCaseStatement = color and { link = "DropBarIconKindCaseStatement" } or { fg = C.text },
		DropBarKindClass = color and { link = "DropBarIconKindClass" } or { fg = C.text },
		DropBarKindConstant = color and { link = "DropBarIconKindConstant" } or { fg = C.text },
		DropBarKindConstructor = color and { link = "DropBarIconKindConstructor" } or { fg = C.text },
		DropBarKindContinueStatement = color and { link = "DropBarIconKindContinueStatement" } or { fg = C.text },
		DropBarKindDeclaration = color and { link = "DropBarIconKindDeclaration" } or { fg = C.text },
		DropBarKindDelete = color and { link = "DropBarIconKindDelete" } or { fg = C.text },
		DropBarKindDoStatement = color and { link = "DropBarIconKindDoStatement" } or { fg = C.text },
		DropBarKindElseStatement = color and { link = "DropBarIconKindElseStatement" } or { fg = C.text },
		DropBarKindEnum = color and { link = "DropBarIconKindEnum" } or { fg = C.text },
		DropBarKindEnumMember = color and { link = "DropBarIconKindEnumMember" } or { fg = C.text },
		DropBarKindEvent = color and { link = "DropBarIconKindEvent" } or { fg = C.text },
		DropBarKindField = color and { link = "DropBarIconKindField" } or { fg = C.text },
		DropBarKindFile = color and { link = "DropBarIconKindFile" } or { fg = C.text },
		DropBarKindFolder = color and { link = "DropBarIconKindFolder" } or { fg = C.text },
		DropBarKindForStatement = color and { link = "DropBarIconKindForStatement" } or { fg = C.text },
		DropBarKindFunction = color and { link = "DropBarIconKindFunction" } or { fg = C.text },
		DropBarKindIdentifier = color and { link = "DropBarIconKindIdentifier" } or { fg = C.text },
		DropBarKindIfStatement = color and { link = "DropBarIconKindIfStatement" } or { fg = C.text },
		DropBarKindInterface = color and { link = "DropBarIconKindInterface" } or { fg = C.text },
		DropBarKindKeyword = color and { link = "DropBarIconKindKeyword" } or { fg = C.text },
		DropBarKindList = color and { link = "DropBarIconKindList" } or { fg = C.text },
		DropBarKindMacro = color and { link = "DropBarIconKindMacro" } or { fg = C.text },
		DropBarKindMarkdownH1 = color and { link = "DropBarIconKindMarkdownH1" } or { fg = C.text },
		DropBarKindMarkdownH2 = color and { link = "DropBarIconKindMarkdownH2" } or { fg = C.text },
		DropBarKindMarkdownH3 = color and { link = "DropBarIconKindMarkdownH3" } or { fg = C.text },
		DropBarKindMarkdownH4 = color and { link = "DropBarIconKindMarkdownH4" } or { fg = C.text },
		DropBarKindMarkdownH5 = color and { link = "DropBarIconKindMarkdownH5" } or { fg = C.text },
		DropBarKindMarkdownH6 = color and { link = "DropBarIconKindMarkdownH6" } or { fg = C.text },
		DropBarKindMethod = color and { link = "DropBarIconKindMethod" } or { fg = C.text },
		DropBarKindModule = color and { link = "DropBarIconKindModule" } or { fg = C.text },
		DropBarKindNamespace = color and { link = "DropBarIconKindNamespace" } or { fg = C.text },
		DropBarKindNull = color and { link = "DropBarIconKindNull" } or { fg = C.text },
		DropBarKindNumber = color and { link = "DropBarIconKindNumber" } or { fg = C.text },
		DropBarKindObject = color and { link = "DropBarIconKindObject" } or { fg = C.text },
		DropBarKindOperator = color and { link = "DropBarIconKindOperator" } or { fg = C.text },
		DropBarKindPackage = color and { link = "DropBarIconKindPackage" } or { fg = C.text },
		DropBarKindProperty = color and { link = "DropBarIconKindProperty" } or { fg = C.text },
		DropBarKindReference = color and { link = "DropBarIconKindReference" } or { fg = C.text },
		DropBarKindRepeat = color and { link = "DropBarIconKindRepeat" } or { fg = C.text },
		DropBarKindScope = color and { link = "DropBarIconKindScope" } or { fg = C.text },
		DropBarKindSpecifier = color and { link = "DropBarIconKindSpecifier" } or { fg = C.text },
		DropBarKindStatement = color and { link = "DropBarIconKindStatement" } or { fg = C.text },
		DropBarKindString = color and { link = "DropBarIconKindString" } or { fg = C.text },
		DropBarKindStruct = color and { link = "DropBarIconKindStruct" } or { fg = C.text },
		DropBarKindSwitchStatement = color and { link = "DropBarIconKindSwitchStatement" } or { fg = C.text },
		DropBarKindType = color and { link = "DropBarIconKindType" } or { fg = C.text },
		DropBarKindTypeParameter = color and { link = "DropBarIconKindTypeParameter" } or { fg = C.text },
		DropBarKindUnit = color and { link = "DropBarIconKindUnit" } or { fg = C.text },
		DropBarKindValue = color and { link = "DropBarIconKindValue" } or { fg = C.text },
		DropBarKindVariable = color and { link = "DropBarIconKindVariable" } or { fg = C.text },
		DropBarKindWhileStatement = color and { link = "DropBarIconKindWhileStatement" } or { fg = C.text },
	}
end

-- ==== source: groups/integrations/flash.lua ====
local function get_flash()
	local bg = O.transparent_background and C.none or C.base
	return {
		FlashBackdrop = { fg = C.overlay0 },
		FlashLabel = { fg = C.green, bg = bg, style = { "bold" } },
		FlashMatch = { fg = C.lavender, bg = bg },
		FlashCurrent = { fg = C.peach, bg = bg },
		FlashPrompt = { link = "NormalFloat" },
	}
end

-- ==== source: groups/integrations/fzf.lua ====
local function get_fzf()
	return {
		FzfLuaNormal = { link = "NormalFloat" },
		FzfLuaBorder = { link = "FloatBorder" },
		FzfLuaTitle = { link = "FloatTitle" },
		FzfLuaHeaderBind = { fg = C.yellow },
		FzfLuaHeaderText = { fg = C.peach },
		FzfLuaDirPart = { link = "NonText" },
		FzfLuaFzfMatch = { fg = C.blue },
		FzfLuaFzfPrompt = { fg = C.blue },
		FzfLuaPathColNr = { fg = C.blue },
		FzfLuaPathLineNr = { fg = C.green },
		FzfLuaBufName = { fg = C.mauve },
		FzfLuaBufNr = { fg = C.yellow },
		FzfLuaBufFlagCur = { fg = C.peach },
		FzfLuaBufFlagAlt = { fg = C.blue },
		FzfLuaTabTitle = { fg = C.sky },
		FzfLuaTabMarker = { fg = C.yellow },
		FzfLuaLiveSym = { fg = C.peach },
	}
end

-- ==== source: groups/integrations/gitsigns.lua ====
local function get_gitsigns()
	-- (a ~= nil) and a or b: Potential false-negative handling
	local transparent = O.transparent_background
	if type(O.integrations.gitsigns.transparent) == "boolean" then transparent = O.integrations.gitsigns.transparent end

	if transparent then
		return {
			GitSignsAdd = { fg = C.green }, -- diff mode: Added line |diff.txt|
			GitSignsChange = { fg = C.yellow }, -- diff mode: Changed line |diff.txt|
			GitSignsDelete = { fg = C.red }, -- diff mode: Deleted line |diff.txt|

			GitSignsCurrentLineBlame = { fg = C.surface1 },

			GitSignsAddPreview = { fg = C.green, bg = C.none },
			GitSignsDeletePreview = { fg = C.red, bg = C.none },

			-- for word diff in previews
			GitSignsAddInline = { fg = C.base, bg = C.green, style = { "bold" } },
			GitSignsDeleteInline = { fg = C.base, bg = C.red, style = { "bold" } },
			GitSignsChangeInline = { fg = C.base, bg = C.blue, style = { "bold" } },

			GitSignsDeleteVirtLn = { bg = C.none, fg = C.red },
		}
	else
		return {
			GitSignsAdd = { fg = C.green }, -- diff mode: Added line |diff.txt|
			GitSignsChange = { fg = C.yellow }, -- diff mode: Changed line |diff.txt|
			GitSignsDelete = { fg = C.red }, -- diff mode: Deleted line |diff.txt|

			GitSignsCurrentLineBlame = { fg = C.surface1 },

			GitSignsAddPreview = { link = "DiffAdd" },
			GitSignsDeletePreview = { link = "DiffDelete" },

			GitSignsAddInline = { bg = U.darken(C.green, 0.36, C.base) },
			GitSignsChangeInline = { bg = U.darken(C.blue, 0.14, C.base) },
			GitSignsDeleteInline = { bg = U.darken(C.red, 0.36, C.base) },
		}
	end
end

-- ==== source: groups/integrations/illuminate.lua ====
local function get_illuminate()
	return {
		IlluminatedWordText = { bg = U.darken(C.surface1, 0.7, C.base) },
		IlluminatedWordRead = { bg = U.darken(C.surface1, 0.7, C.base) },
		IlluminatedWordWrite = {
			bg = U.darken(C.surface1, 0.7, C.base),
			style = O.integrations.illuminate.lsp and { "standout" } or {},
		},
	}
end

-- ==== source: groups/integrations/indent_blankline.lua ====
local function get_indent_blankline()
	local scope_color = O.integrations.indent_blankline.scope_color

	local hi = {
		IblIndent = { fg = C.surface0 },
		IblScope = { fg = C[scope_color] or C.text },
	}

	if O.integrations.indent_blankline.colored_indent_levels then
		hi["RainbowRed"] = { blend = 0, fg = C.red }
		hi["RainbowYellow"] = { blend = 0, fg = C.yellow }
		hi["RainbowBlue"] = { blend = 0, fg = C.blue }
		hi["RainbowOrange"] = { blend = 0, fg = C.peach }
		hi["RainbowGreen"] = { blend = 0, fg = C.green }
		hi["RainbowViolet"] = { blend = 0, fg = C.mauve }
		hi["RainbowCyan"] = { blend = 0, fg = C.teal }
	end

	return hi
end

-- ==== source: groups/integrations/mini.lua ====
local function get_mini()
	local transparent_background = O.transparent_background
	local bg_highlight = transparent_background and "NONE" or C.base

	local inactive_bg = transparent_background and "NONE" or C.mantle

	local indentscope_color = O.integrations.mini.indentscope_color
	return {
		MiniAnimateCursor = { style = { "reverse", "nocombine" } },
		MiniAnimateNormalFloat = { link = "NormalFloat" },

		MiniClueBorder = { link = "FloatBorder" },
		MiniClueDescGroup = { link = "DiagnosticFloatingWarn" },
		MiniClueDescSingle = { link = "NormalFloat" },
		MiniClueNextKey = { link = "DiagnosticFloatingHint" },
		MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
		MiniClueSeparator = { link = "DiagnosticFloatingInfo" },
		MiniClueTitle = { link = "FloatTitle" },

		MiniCompletionActiveParameter = { style = { "underline" } },

		MiniCursorword = { style = { "underline" } },
		MiniCursorwordCurrent = { style = { "underline" } },

		MiniDepsChangeAdded = { link = "diffAdded" },
		MiniDepsChangeRemoved = { link = "diffRemoved" },
		MiniDepsHint = { link = "DiagnosticHint" },
		MiniDepsInfo = { link = "DiagnosticInfo" },
		MiniDepsMsgBreaking = { link = "DiagnosticWarn" },
		MiniDepsPlaceholder = { link = "Comment" },
		MiniDepsTitle = { link = "Title" },
		MiniDepsTitleError = { bg = C.red, fg = C.base },
		MiniDepsTitleSame = { link = "DiffText" },
		MiniDepsTitleUpdate = { bg = C.green, fg = C.base },

		MiniDiffSignAdd = { fg = C.green },
		MiniDiffSignChange = { fg = C.yellow },
		MiniDiffSignDelete = { fg = C.red },
		MiniDiffOverAdd = { link = "DiffAdd" },
		MiniDiffOverChange = { link = "DiffText" },
		MiniDiffOverContext = { link = "DiffChange" },
		MiniDiffOverDelete = { link = "DiffDelete" },

		MiniFilesBorder = { link = "FloatBorder" },
		MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
		MiniFilesCursorLine = { link = "CursorLine" },
		MiniFilesDirectory = { link = "Directory" },
		MiniFilesFile = { fg = C.text },
		MiniFilesNormal = { link = "NormalFloat" },
		MiniFilesTitle = { link = "FloatTitle" },
		MiniFilesTitleFocused = O.float.solid and {
			fg = C.crust,
			bg = C.mauve,
		} or {
			fg = C.subtext0,
			bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.mantle,
			style = { "bold" },
		},

		MiniHipatternsFixme = { fg = C.base, bg = C.red, style = { "bold" } },
		MiniHipatternsHack = { fg = C.base, bg = C.yellow, style = { "bold" } },
		MiniHipatternsNote = { fg = C.base, bg = C.sky, style = { "bold" } },
		MiniHipatternsTodo = { fg = C.base, bg = C.teal, style = { "bold" } },

		MiniIconsAzure = { fg = C.sapphire },
		MiniIconsBlue = { fg = C.blue },
		MiniIconsCyan = { fg = C.teal },
		MiniIconsGreen = { fg = C.green },
		MiniIconsGrey = { fg = C.text },
		MiniIconsOrange = { fg = C.peach },
		MiniIconsPurple = { fg = C.mauve },
		MiniIconsRed = { fg = C.red },
		MiniIconsYellow = { fg = C.yellow },

		MiniIndentscopeSymbol = { fg = C[indentscope_color] or C.overlay2 },

		MiniJump = { fg = C.overlay2, bg = C.pink },

		MiniJump2dDim = { fg = C.overlay0 },
		MiniJump2dSpot = { bg = C.base, fg = C.peach, style = { "bold", "underline" } },
		MiniJump2dSpotAhead = { bg = C.dim, fg = C.teal },
		MiniJump2dSpotUnique = { bg = C.base, fg = C.sky, style = { "bold" } },

		MiniMapNormal = { link = "NormalFloat" },
		MiniMapSymbolCount = { link = "Special" },
		MiniMapSymbolLine = { link = "Title" },
		MiniMapSymbolView = { link = "Delimiter" },

		MiniNotifyBorder = { link = "FloatBorder" },
		MiniNotifyNormal = { link = "NormalFloat" },
		MiniNotifyTitle = { link = "FloatTitle" },

		MiniOperatorsExchangeFrom = { link = "IncSearch" },

		MiniPickBorder = { link = "FloatBorder" },
		MiniPickBorderBusy = { link = "DiagnosticFloatingWarn" },
		MiniPickBorderText = O.float.solid and {
			fg = C.crust,
			bg = C.mauve,
		} or { fg = C.mauve, bg = (O.float.transparent and vim.o.winblend == 0) and C.none or C.mantle },
		MiniPickIconDirectory = { link = "Directory" },
		MiniPickIconFile = { link = "MiniPickNormal" },
		MiniPickHeader = { link = "DiagnosticFloatingHint" },
		MiniPickMatchCurrent = {
			fg = C.flamingo,
			bg = C.surface0,
			style = { "bold" },
		},
		MiniPickMatchMarked = { link = "Visual" },
		MiniPickMatchRanges = { link = "DiagnosticFloatingHint" },
		MiniPickNormal = { link = "NormalFloat" },
		MiniPickPreviewLine = { link = "CursorLine" },
		MiniPickPreviewRegion = { link = "IncSearch" },
		MiniPickPrompt = { fg = C.text, bg = O.float.transparent and C.none or C.mantle },
		MiniPickPromptCaret = {
			fg = C.flamingo,
			bg = O.float.transparent and C.none or C.mantle,
		},
		MiniPickPromptPrefix = {
			fg = C.flamingo,
			bg = O.float.transparent and C.none or C.mantle,
		},

		MiniStarterCurrent = {},
		MiniStarterFooter = { fg = C.yellow, style = { "italic" } },
		MiniStarterHeader = { fg = C.blue },
		MiniStarterInactive = { fg = C.surface2, style = O.styles.comments },
		MiniStarterItem = { fg = C.text },
		MiniStarterItemBullet = { fg = C.blue },
		MiniStarterItemPrefix = { fg = C.pink },
		MiniStarterSection = { fg = C.flamingo },
		MiniStarterQuery = { fg = C.green },

		MiniStatuslineDevinfo = { fg = C.subtext1, bg = C.surface1 },
		MiniStatuslineFileinfo = { fg = C.subtext1, bg = C.surface1 },
		MiniStatuslineFilename = { fg = C.text, bg = C.mantle },
		MiniStatuslineInactive = { fg = C.blue, bg = C.mantle },
		MiniStatuslineModeCommand = { fg = C.base, bg = C.peach, style = { "bold" } },
		MiniStatuslineModeInsert = { fg = C.base, bg = C.green, style = { "bold" } },
		MiniStatuslineModeNormal = { fg = C.mantle, bg = C.blue, style = { "bold" } },
		MiniStatuslineModeOther = { fg = C.base, bg = C.teal, style = { "bold" } },
		MiniStatuslineModeReplace = { fg = C.base, bg = C.red, style = { "bold" } },
		MiniStatuslineModeVisual = { fg = C.base, bg = C.mauve, style = { "bold" } },

		MiniSurround = { bg = C.pink, fg = C.surface1 },

		MiniTablineCurrent = { fg = C.text, bg = C.base, sp = C.red, style = { "bold", "italic", "underline" } },
		MiniTablineFill = { bg = bg_highlight },
		MiniTablineHidden = { fg = C.text, bg = inactive_bg },
		MiniTablineModifiedCurrent = { fg = C.red, bg = C.none, style = { "bold", "italic" } },
		MiniTablineModifiedHidden = { fg = C.red, bg = C.none },
		MiniTablineModifiedVisible = { fg = C.red, bg = C.none },
		MiniTablineTabpagesection = { fg = C.surface1, bg = C.base },
		MiniTablineVisible = { bg = C.none },

		MiniTestEmphasis = { style = { "bold" } },
		MiniTestFail = { fg = C.red, style = { "bold" } },
		MiniTestPass = { fg = C.green, style = { "bold" } },

		MiniTrailspace = { bg = C.red },
	}
end

-- ==== source: groups/integrations/neogit.lua ====
local function get_neogit()
	return {
		NeogitBranch = {
			fg = C.peach,
			style = { "bold" },
		},
		NeogitRemote = {
			fg = C.green,
			style = { "bold" },
		},
		NeogitUnmergedInto = {
			link = "Function",
		},
		NeogitUnpulledFrom = {
			link = "Function",
		},
		NeogitObjectId = {
			link = "Comment",
		},
		NeogitStash = {
			link = "Comment",
		},
		NeogitRebaseDone = {
			link = "Comment",
		},
		NeogitHunkHeader = {
			bg = U.darken(C.blue, 0.095, C.base),
			fg = U.darken(C.blue, 0.5, C.base),
		},
		NeogitHunkHeaderHighlight = {
			bg = U.darken(C.blue, 0.215, C.base),
			fg = C.blue,
		},
		NeogitDiffContextHighlight = {
			bg = C.surface0,
		},
		NeogitDiffDeleteHighlight = {
			bg = U.darken(C.red, 0.345, C.base),
			fg = U.lighten(C.red, 0.850, C.text),
		},
		NeogitDiffAddHighlight = {
			bg = U.darken(C.green, 0.345, C.base),
			fg = U.lighten(C.green, 0.850, C.text),
		},
		NeogitDiffDelete = {
			bg = U.darken(C.red, 0.095, C.base),
			fg = U.darken(C.red, 0.800, C.base),
		},
		NeogitDiffDeleteInline = {
			bg = U.darken(C.red, 0.500, C.base),
			style = { "bold" },
		},
		NeogitDiffAdd = {
			bg = U.darken(C.green, 0.095, C.base),
			fg = U.darken(C.green, 0.800, C.base),
		},
		NeogitDiffAddInline = {
			bg = U.darken(C.green, 0.500, C.base),
			style = { "bold" },
		},
		NeogitCommitViewHeader = {
			bg = U.darken(C.blue, 0.300, C.base),
			fg = U.lighten(C.blue, 0.800, C.text),
		},
		NeogitChangeModified = {
			fg = C.blue,
			style = { "bold" },
		},
		NeogitChangeDeleted = {
			fg = C.red,
			style = { "bold" },
		},
		NeogitChangeAdded = {
			fg = C.green,
			style = { "bold" },
		},
		NeogitChangeRenamed = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitChangeUpdated = {
			fg = C.peach,
			style = { "bold" },
		},
		NeogitChangeCopied = {
			fg = C.pink,
			style = { "bold" },
		},
		NeogitChangeBothModified = {
			fg = C.yellow,
			style = { "bold" },
		},
		NeogitChangeNewFile = {
			fg = C.green,
			style = { "bold" },
		},
		NeogitUntrackedfiles = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitUnstagedchanges = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitUnmergedchanges = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitUnpulledchanges = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitRecentcommits = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitStagedchanges = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitStashes = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitRebasing = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitNotificationInfo = {
			fg = C.blue,
		},
		NeogitNotificationWarning = {
			fg = C.yellow,
		},
		NeogitNotificationError = {
			fg = C.red,
		},
		NeogitGraphRed = {
			fg = C.red,
		},
		NeogitGraphWhite = {
			fg = C.base,
		},
		NeogitGraphYellow = {
			fg = C.yellow,
		},
		NeogitGraphGreen = {
			fg = C.green,
		},
		NeogitGraphCyan = {
			fg = C.blue,
		},
		NeogitGraphBlue = {
			fg = C.blue,
		},
		NeogitGraphPurple = {
			fg = C.lavender,
		},
		NeogitGraphGray = {
			fg = C.subtext1,
		},
		NeogitGraphOrange = {
			fg = C.peach,
		},
		NeogitGraphBoldRed = {
			fg = C.red,
			style = { "bold" },
		},
		NeogitGraphBoldWhite = {
			fg = C.white,
			style = { "bold" },
		},
		NeogitGraphBoldYellow = {
			fg = C.yellow,
			style = { "bold" },
		},
		NeogitGraphBoldGreen = {
			fg = C.green,
			style = { "bold" },
		},
		NeogitGraphBoldCyan = {
			fg = C.blue,
			style = { "bold" },
		},
		NeogitGraphBoldBlue = {
			fg = C.blue,
			style = { "bold" },
		},
		NeogitGraphBoldPurple = {
			fg = C.lavender,
			style = { "bold" },
		},
		NeogitGraphBoldGray = {
			fg = C.subtext1,
			style = { "bold" },
		},
		NeogitDiffContext = {
			bg = C.base,
		},
		NeogitPopupBold = {
			style = { "bold" },
		},
		NeogitPopupSwitchKey = {
			fg = C.lavender,
		},
		NeogitPopupOptionKey = {
			fg = C.lavender,
		},
		NeogitPopupConfigKey = {
			fg = C.lavender,
		},
		NeogitPopupActionKey = {
			fg = C.lavender,
		},
		NeogitFilePath = {
			fg = C.blue,
			style = { "italic" },
		},
		NeogitDiffHeader = {
			bg = C.base,
			fg = C.blue,
			style = { "bold" },
		},
		NeogitDiffHeaderHighlight = {
			bg = C.base,
			fg = C.peach,
			style = { "bold" },
		},
		NeogitUnpushedTo = {
			fg = C.lavender,
			style = { "bold" },
		},
		NeogitFold = {
			fg = C.none,
			bg = C.none,
		},
		NeogitSectionHeader = {
			fg = C.mauve,
			style = { "bold" },
		},
		NeogitTagName = {
			fg = C.yellow,
		},
		NeogitTagDistance = {
			fg = C.blue,
		},
		NeogitWinSeparator = {
			link = "WinSeparator",
		},
	}
end

-- ==== source: groups/integrations/neotree.lua ====
local function get_neotree()
	local active_bg = O.transparent_background and C.none or C.mantle
	local inactive_bg = O.transparent_background and C.none or C.base
	return {
		NeoTreeDirectoryName = { fg = C.blue },
		NeoTreeDirectoryIcon = { fg = C.blue },
		NeoTreeNormal = { fg = C.text, bg = active_bg },
		NeoTreeNormalNC = { fg = C.text, bg = active_bg },
		NeoTreeExpander = { fg = C.overlay0 },
		NeoTreeIndentMarker = { fg = C.overlay0 },
		NeoTreeRootName = { fg = C.blue, style = { "bold" } },
		NeoTreeSymbolicLinkTarget = { fg = C.pink },
		NeoTreeModified = { fg = C.peach },

		NeoTreeGitAdded = { fg = C.green },
		NeoTreeGitConflict = { fg = C.red },
		NeoTreeGitDeleted = { fg = C.red },
		NeoTreeGitIgnored = { fg = C.overlay0 },
		NeoTreeGitModified = { fg = C.yellow },
		NeoTreeGitUnstaged = { fg = C.red },
		NeoTreeGitUntracked = { fg = C.mauve },
		NeoTreeGitStaged = { fg = C.green },

		NeoTreeFloatBorder = { link = "FloatBorder" },
		NeoTreeFloatTitle = { link = "FloatTitle" },
		NeoTreeTitleBar = { fg = C.mantle, bg = C.blue },

		NeoTreeFileNameOpened = { fg = C.pink },
		NeoTreeDimText = { fg = C.overlay1 },
		NeoTreeFilterTerm = { fg = C.green, style = { "bold" } },
		NeoTreeTabActive = { bg = active_bg, fg = C.lavender, style = { "bold" } },
		NeoTreeTabInactive = { bg = inactive_bg, fg = C.overlay0 },
		NeoTreeTabSeparatorActive = { fg = active_bg, bg = active_bg },
		NeoTreeTabSeparatorInactive = { fg = inactive_bg, bg = inactive_bg },
		NeoTreeVertSplit = { fg = C.base, bg = inactive_bg },
		NeoTreeWinSeparator = {
			fg = O.transparent_background and C.surface1 or C.base,
			bg = O.transparent_background and C.none or C.base,
		},
		NeoTreeStatusLineNC = { fg = C.mantle, bg = C.mantle },
	}
end

-- ==== source: groups/integrations/nvimtree.lua ====
local function get_nvimtree()
	return {
		NvimTreeFolderName = { fg = C.blue },
		NvimTreeFolderIcon = { fg = C.blue },
		NvimTreeNormal = { fg = C.text, bg = O.transparent_background and C.none or C.mantle },
		NvimTreeOpenedFolderName = { fg = C.blue },
		NvimTreeEmptyFolderName = { fg = C.blue },
		NvimTreeIndentMarker = { fg = C.overlay0 },
		NvimTreeWinSeparator = {
			fg = O.transparent_background and C.surface1 or C.base,
			bg = O.transparent_background and C.none or C.base,
		},
		NvimTreeRootFolder = { fg = C.lavender, style = { "bold" } },
		NvimTreeSymlink = { fg = C.pink },
		NvimTreeStatuslineNc = { fg = C.mantle, bg = C.mantle },
		NvimTreeGitDirty = { fg = C.yellow },
		NvimTreeGitNew = { fg = C.blue },
		NvimTreeGitDeleted = { fg = C.red },
		NvimTreeSpecialFile = { fg = C.flamingo },
		NvimTreeImageFile = { fg = C.text },
		NvimTreeOpenedFile = { fg = C.pink },
	}
end

-- ==== source: groups/integrations/rainbow_delimiters.lua ====
local function get_rainbow_delimiters()
	return {
		RainbowDelimiterRed = { fg = C.red },
		RainbowDelimiterYellow = { fg = C.yellow },
		RainbowDelimiterBlue = { fg = C.blue },
		RainbowDelimiterOrange = { fg = C.peach },
		RainbowDelimiterGreen = { fg = C.green },
		RainbowDelimiterViolet = { fg = C.mauve },
		RainbowDelimiterCyan = { fg = C.teal },
	}
end

-- ==== source: groups/integrations/telescope.lua ====
local function get_telescope()
	local hlgroups = {
		TelescopeBorder = { link = "FloatBorder" },
		TelescopeNormal = { link = "NormalFloat" },
		TelescopePreviewNormal = { link = "TelescopeNormal" },
		TelescopePromptNormal = { link = "TelescopeNormal" },
		TelescopeResultsNormal = { link = "TelescopeNormal" },
		TelescopeTitle = { link = "FloatTitle" },
		TelescopeSelectionCaret = { fg = C.flamingo, bg = C.surface0 },
		TelescopeSelection = {
			fg = C.flamingo,
			bg = C.surface0,
			style = { "bold" },
		},
		TelescopeMatching = { fg = C.blue },
		TelescopePromptPrefix = { fg = C.flamingo },
	}

	if O.float.solid then
		hlgroups["TelescopePreviewTitle"] = {
			fg = C.crust,
			bg = C.green,
		}
		hlgroups["TelescopePromptTitle"] = {
			fg = C.crust,
			bg = C.red,
		}
		hlgroups["TelescopeResultsTitle"] = {
			fg = C.crust,
			bg = C.lavender,
		}
	end

	return hlgroups
end

-- ==== source: groups/integrations/treesitter_context.lua ====
local function get_treesitter_context()
	return {
		TreesitterContext = {
			fg = C.text,
			bg = O.transparent_background and C.none or C.mantle,
		},
		TreesitterContextBottom = {
			sp = O.transparent_background and C.dim or C.surface0,
			style = { "underline" },
		},
		TreesitterContextLineNumber = O.transparent_background and {
			fg = C.rosewater,
		} or {
			fg = C.surface1,
			bg = C.mantle,
		},
	}
end

-- ==== source: groups/integrations/ufo.lua ====
local function get_ufo()
	return {
		UfoFoldedFg = { fg = C.lavender },
		UfoFoldedEllipsis = { fg = C.crust, bg = C.blue },
	}
end

-- ----------------------------------------------------------------------------
-- Assemble theme (mirrors catppuccin/nvim lib/mapper.lua merge order exactly)
-- ----------------------------------------------------------------------------

-- theme.editor = force_merge(editor.get(), lsp.get())
local theme_editor = vim.tbl_deep_extend("force", get_editor(), get_lsp())

-- theme.syntax = force_merge(syntax.get(), semantic_tokens.get(), treesitter.get())
local theme_syntax = {}
theme_syntax = vim.tbl_deep_extend("force", theme_syntax, get_syntax())
theme_syntax = vim.tbl_deep_extend("force", theme_syntax, get_semantic_tokens())
theme_syntax = vim.tbl_deep_extend("force", theme_syntax, get_treesitter())

-- theme.integrations = force_merge of every default-enabled integration
-- (alpha, blink_cmp, blink_indent, cmp, dap, dap_ui, dashboard, dropbar,
--  flash, fzf, gitsigns, illuminate, indent_blankline, mini, neogit,
--  neotree, nvimtree, rainbow_delimiters, telescope, treesitter_context, ufo)
local theme_integrations = {}
for _, fn in ipairs({
	get_alpha,
	get_blink_cmp,
	get_blink_indent,
	get_cmp,
	get_dap,
	get_dap_ui,
	get_dashboard,
	get_dropbar,
	get_flash,
	get_fzf,
	get_gitsigns,
	get_illuminate,
	get_indent_blankline,
	get_mini,
	get_neogit,
	get_neotree,
	get_nvimtree,
	get_rainbow_delimiters,
	get_telescope,
	get_treesitter_context,
	get_ufo,
}) do
	theme_integrations = vim.tbl_deep_extend("force", theme_integrations, fn())
end

local theme_terminal = get_terminal()

-- final table: mirrors compiler.lua ->
--   vim.tbl_deep_extend("keep", custom_highlights({}), integrations, syntax, editor)
local tbl = vim.tbl_deep_extend("keep", {}, theme_integrations, theme_syntax, theme_editor)

-- ----------------------------------------------------------------------------
-- Apply (mirrors compiler.lua's per-group style flattening + nvim_set_hl)
-- ----------------------------------------------------------------------------
for group, color in pairs(tbl) do
	if color.style then
		for _, style in pairs(color.style) do
			color[style] = true
			if O.no_italic and style == "italic" then color[style] = false end
			if O.no_bold and style == "bold" then color[style] = false end
			if O.no_underline and style == "underline" then color[style] = false end
		end
	end
	color.style = nil
	vim.api.nvim_set_hl(0, group, color)
end

-- Terminal ANSI colors: upstream only sets these when `term_colors = true`
-- (off by default). Flip the condition below to `true` if you want this
-- colorscheme to also drive :terminal's ANSI palette.
if O.term_colors then
	for name, hex in pairs(theme_terminal) do
		vim.g[name] = hex
	end
end


