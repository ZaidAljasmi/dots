return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",

		dependencies = {
			"nvim-lua/plenary.nvim",

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},

		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
                    layout_config = {
                    	prompt_position = "top",
                    },

					color_devicons = true,
					border = true,

					borderchars = {
					                   prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }, --|
					                   results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },--|--- use this if you want a borders without curnors
					                   preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },--|
					},
                    -- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " }, 

                    preview = {
                        treesitter = false,
                        msg_bg_fillchar = " ",
                    },

					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,

							-- ["<C-h>"] = "which_key",
						},

						n = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
			})

			pcall(telescope.load_extension, "fzf")

			vim.keymap.set(
				"n",
				"<leader>fg",
				builtin.live_grep,
				{ desc = "Telescope live grep" }
			)

			vim.keymap.set(
				"n",
				"<leader>fh",
				builtin.help_tags,
				{ desc = "Telescope help tags" }
			)

			vim.keymap.set(
				"n",
				"<leader>fb",
				builtin.buffers,
				{ desc = "Buffers" }
			)

			vim.keymap.set(
				"n",
				"<leader>uC",
				builtin.colorscheme,
				{ desc = "Colorschemes" }
			)

			vim.keymap.set(
				"n",
				"<leader>ff",
				builtin.find_files,
				{ desc = "Find Files" }
			)

            vim.keymap.set("n", "<leader>fo", function()
            	builtin.oldfiles({
		            prompt_title = "Recent Files",
	            })
            end, {
	            desc = "Recent Files",
            })

			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({
					cwd = vim.fn.expand("~/.config/nvim"),
                    		prompt_title = "Neovim Config",
				})
			end, {
				desc = "Neovim Config",
			})
		end,
	},
}
