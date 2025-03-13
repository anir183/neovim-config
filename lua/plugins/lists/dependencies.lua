--[[ plugins used only as dependencies of other plugins ]]

return {
	-- utility neovim functions
	{
		"nvim-lua/plenary.nvim",
		name = "plenary",
		priority = 1000
	},

	-- icons used by other plugins
	{
		"nvim-tree/nvim-web-devicons",
		name = "devicons",
		priority = 500,
		config = function() require("nvim-web-devicons").setup() end
	},

	-- async io
	{
		"nvim-neotest/nvim-nio",
		name = "nio",
		priority = 500,
	}
}
