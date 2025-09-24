return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false,
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			enable = {
				terminal = true,
				legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
				migrations = true, -- Handle deprecated options automatically
			}
		})
		vim.cmd("colorscheme rose-pine-moon")
	end,
}
