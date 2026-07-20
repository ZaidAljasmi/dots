return {
	{
		"CRAG666/code_runner.nvim",
		config = function()
			require("code_runner").setup({
				filetype = {
					java = {
						"cd $dir &&",
						"javac $fileName &&",
						"java $fileNameWithoutExt",
					},
					python = "python3 -u",
					typescript = "deno run",
					rust = {
						"cd $dir &&",
						"rustc $fileName &&",
						"$dir/$fileNameWithoutExt",
					},
					c = "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
					cpp = "cd $dir && g++ $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
				},
			})

			local keymap = vim.keymap.set
			keymap("n", "<leader>rr", ":RunCode<CR>", { noremap = true, silent = false })
			keymap("n", "<leader>rf", ":RunFile<CR>", { noremap = true, silent = false })
			keymap("n", "<leader>rft", ":RunFile tab<CR>", { noremap = true, silent = false })
			keymap("n", "<leader>rp", ":RunProject<CR>", { noremap = true, silent = false })
			keymap("n", "<leader>rc", ":RunClose<CR>", { noremap = true, silent = false })
            keymap("n", "<Esc>", ":RunClose<CR>", { noremap = true, silent = true })
			keymap("n", "<leader>crf", ":CRFiletype<CR>", { noremap = true, silent = false })
			keymap("n", "<leader>crp", ":CRProjects<CR>", { noremap = true, silent = false })
		end,
	},
}
