--[[ linting ]]

return {
	-- linting engine
	"mfussenegger/nvim-lint",
	name = "lint",
	dependencies = { "mason_tool_installer" },
	config = function()
		local lint = require("lint")

		OPTS.linters.mason = nil
		lint.linters_by_ft = OPTS.linters
		lint.linters = OPTS.custom_linters

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = AUGRP,
			callback = function() lint.try_lint() end,
		})

		NMAP(
			"<leader>ln",
			function() lint.try_list() end,
			{ desc = "plugins/nvim-lint: perform linting in the current file" }
		)
	end
}
