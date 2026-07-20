local map = vim.keymap.set
local cmd = vim.cmd

map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<S-j>", "<cmd>bprevious<cr>")
map("n", "<S-k>", "<cmd>bnext<cr>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

map("n", "<leader>-", "<cmd>split<cr>")
map("n", "<leader>|", "<cmd>vsplit<cr>")

-- Open netrw file explorer
-- map("n", "<leader>e", "<cmd>Ex<cr>")
-- map("n", "<leader>fe", "<cmd>Ex ~<cr>")
map("n", "<leader>fe", function()
    if vim.bo.filetype == "netrw" then
        cmd("bd") 
    else
        cmd("Ex")
    end
end)

map("n", "<leader>e", function()
    if vim.bo.filetype == "netrw" then
        cmd("bd")
    else
        cmd("Ex ~")
    end
end)

map("n", "<leader>bk", "<cmd>bdelete<cr>")
map("t", "<Esc>", [[<C-\><C-n>]])

-- move lines
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Copy & Paste 
map({ "n", "v" }, "<leader>y", '"+y', {
	desc = "Copy to system clipboard",
})

map("n", "<leader>Y", '"+yy', {
	desc = "Copy line to system clipboard",
})

map({ "n", "v" }, "<leader>p", '"+p', {
	desc = "Paste from system clipboard",
})

map({ "n", "v" }, "<leader>P", '"+P', {
	desc = "Paste before from system clipboard",
})
-- Programming languages keymaps
map("n", "<leader>cf", function()
    cmd("%!clang-format")
end, { desc = "Format C file" })

-- Relod the settings
-- map('n', '<leader>r', ':source %<CR>', { desc = 'Reload current lua file' })
