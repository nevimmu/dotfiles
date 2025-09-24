return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			window = {
				position = 'right',
				mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
					["P"] = { "toggle_preview", config = { use_float = false } },
				}
			}
		}
	}
}
