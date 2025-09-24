local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Open lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
map("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

-- Move line down with Ctrl+Alt+j
map("n", "<C-A-j>", ":m+<CR>==", { noremap = true, silent = true })
map("i", "<C-A-j>", "<Esc>:m+<CR>==gi", { noremap = true, silent = true })
map("v", "<C-A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Move line up with Ctrl+Alt+k
map("n", "<C-A-k>", ":m-2<CR>==", { noremap = true, silent = true })
map("i", "<C-A-k>", "<Esc>:m-2<CR>==gi", { noremap = true, silent = true })
map("v", "<C-A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- NeoTree
map("n", "<C-b>", "<Cmd>Neotree toggle<CR>", { desc = "Open NeoTree" })

-- Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- LSP
map("n", "K", vim.lsp.buf.hover, { desc = "Hover info" })
-- map('n', 'H', vim.diagnostic.open_float(), { desc = 'Float info' })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Null
map("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format" })

return {
	setup = function() end,
}
