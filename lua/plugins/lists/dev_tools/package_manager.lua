--[[ package manager for different dev tools like lsps, linters, formatters, etc ]]

return {
	-- package manager
	{
		"williamboman/mason.nvim",
		name = "mason",
		config = function()
			require("mason").setup()

			NMAP("<leader>mn", vim.cmd.Mason, { desc = "plugins/mason: open mason" })
		end,
	},

	-- tools installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		name = "mason_tool_installer",
		dependencies = { "mason" },
		config = function()
			local ensure_installed_tools = {}

			if OPTS.formatters.mason then
				for _, formatter_name in pairs(OPTS.formatters.mason) do
					table.insert(ensure_installed_tools, formatter_name)
				end
			end

			if OPTS.linters.mason then
				for _, linter_name in ipairs(OPTS.linters.mason) do
					table.insert(ensure_installed_tools, linter_name)
				end
			end

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed_tools,
				integrations = {
					["mason-lspconfig"] = false,
					["mason-null-ls"] = false,
					["mason-nvim-dap"] = false,
				},
			})
		end
	},
}
