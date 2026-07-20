return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
            -- color_overrides = {
            --     mocha = {
            --         base = "#1e1e2e",
            --         mantle = "#181825",
            --     },
            -- },
            -- custom_highlights = function(colors)
            --     return {
            --         Normal = { bg = colors.mantle },
            --         NormalNC = { bg = colors.mantle },
            --         NormalFloat = { bg = colors.mantle },
            --         FloatBorder = { bg = colors.mantle },
            --         StatusLine = { bg = colors.base },
            --     }
            -- end,
            flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
            transparent_background = false , -- disables setting the background color.
            float = {
                transparent = false, -- enable transparent floating windows
                solid = false, -- use solid styling for floating windows, see |winborder|
            },
			show_end_of_buffer = false,
			term_colors = true,
			styles = {
				comments = {},-- or italic
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
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				telescope = true,
				notify = true,
				treesitter = true,
				lsp_trouble = true,
				mason = true,
				nvim_cmp = true,
				dashboard = true,
			},
		})
		-- vim.cmd("colorscheme catppuccin")
	end,
}
