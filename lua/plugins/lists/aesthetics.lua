--[[ plugins relating to improving the aesthetics of the editor without providing functionality ]]

return {
	-- theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true, -- disables setting the background color.
				show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
				term_colors = true -- sets terminal colors (e.g. `g:terminal_color_0`)
			})

			vim.cmd.colorscheme("catppuccin")
		end
	},

	-- icons for netrw
	{
		"prichrd/netrw.nvim",
		name = "netrw_plus",
		dependencies = { "devicons" },
		config = function()
			-- the fields are not necessary
			---@diagnostic disable-next-line: missing-fields
			require("netrw").setup({ use_devicons = true })
		end
	}
}
