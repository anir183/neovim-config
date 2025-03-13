--[[ setting up language server protocol ]]

return {
	-- bridge between lspconfig and mason
	{
		"williamboman/mason-lspconfig.nvim",
		name = "mason_lspconfig",
		dependencies = { "mason" },
		config = function()
			local ensure_installed_lsps = {};

			for lsp_name, _ in pairs(OPTS.lsps) do
				table.insert(ensure_installed_lsps, lsp_name);
			end

			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed_lsps,
				automatic_installation = true,
			});
		end
	},

	-- some premade configurations for different lsps
	{
		"neovim/nvim-lspconfig",
		name = "lspconfig",
		dependencies = {
			"mason_lspconfig",
			{ "hrsh7th/cmp-nvim-lsp", name = "cmp_lsp" },
		},
		config = function()
			local lspconfig = require("lspconfig");

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			);

			for lsp_name, opts in pairs(OPTS.lsps) do
				if(opts) then
					opts.capabilities = vim.tbl_deep_extend(
						"force",
						capabilities,
						opts.capabilities and opts.capabilities or {}
					);
					lspconfig[lsp_name].setup(opts);
				end
			end
		end
	},

	-- configuration for lua-ls, especially for neovim config dev
	{
		"folke/lazydev.nvim",
		name = "lazydev",
		dependencies = { "lspconfig" },
		config = function() require("lazydev").setup(); end,
	}
};
