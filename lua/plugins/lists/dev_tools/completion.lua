--[[ code completion ]]

return {
	-- snippets
	{
		"L3MON4D3/LuaSnip",
		name = "luasnip",
		dependencies = { "lspconfig" },
		config = function() end
	},


	-- code completion engine
	{
		"hrsh7th/nvim-cmp",
		name = "cmp",
		dependencies = {
			-- sources
			"lazydev", "cmp_lsp", "luasnip",
			{ "saadparwaiz1/cmp_luasnip",                       name = "cmp_luasnip" },
			{ "hrsh7th/cmp-buffer",                             name = "cmp_buffer" },
			{ "https://codeberg.org/FelipeLema/cmp-async-path", name = "cmp_async_path" },
			-- { "hrsh7th/cmp-path", name = "cmp_path" },
			{ "hrsh7th/cmp-cmdline",                            name = "cmp_cmdline" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help",            name = "cmp_lsp_signature" },
			{ "hrsh7th/cmp-calc",                               name = "cmp_calc" },
			{ "JMarkin/cmp-diag-codes",                         name = "cmp_diag_codes" },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol",           name = "cmp_document_symbol" },

			-- customisation
			"devicons",
			{ "onsails/lspkind.nvim", name = "lspkind" },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered({
						border = "single",
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						border = "single",
						winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
					}),
				},
				-- these fields are not necessary for the config
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
						},
					}),
				},
				view = { docs = { auto_open = false } },
				snippet = {
					expand = function(args) require("luasnip").lsp_expand(args.body) end,
				},
				sources = cmp.config.sources({
					{ name = "lazydev" },
				}, {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "nvim_lsp_signature_help" },
					{ name = "calc" },
					{ name = "diag-codes",             option = { in_comment = true } },
					{ name = "async_path" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "nvim_lsp_document_symbol" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{
						name = "cmdline",
						options = { ignore_cmds = { "Man", "!" } },
					},
				}, {
					{ name = "async_path" },
				}),
				-- don't need all the fields for this config
				---@diagnostic disable-next-line: missing-fields
				matching = { disallow_symbol_nonprefix_matching = false },
			})


			local feedkeys = function(keys)
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes(vim.keycode(keys), true, true, true),
					"ni",
					false
				)
			end

			MAP({ "i", "s" }, "<C-x>", function()
				if cmp.visible() then
					cmp.close()
				else
					feedkeys("<C-x>")
				end
			end, { desc = "plugins/cmp: close the cmp menu or just do <C-x>" })

			MAP({ "i", "s" }, "<TAB>", function()
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					feedkeys("<TAB>")
				end
			end, {
				desc = "plugins/cmp: select next completion suggestion or snippet or just do TAB",
			})
			MAP({ "i", "s" }, "<S-TAB>", function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					feedkeys("<S-TAB>")
				end
			end, {
				desc = "plugins/cmp: select previous completion suggestion or snippet or just do S-TAB",
			})
			MAP({ "i", "s" }, "<CR>", function()
				if not cmp.visible() and not cmp.get_active_entry() then
					feedkeys("<CR>")
					return
				end

				if not cmp.confirm({ select = false }) then feedkeys("<CR>") end
			end, { desc = "plugins/cmp: pick selected completion suggestion or just do ENTER" })

			MAP({ "i", "s" }, "<C-k>", function()
				if cmp.visible_docs() then
					cmp.close_docs()
				elseif cmp.visible() then
					cmp.open_docs()
				end
			end, { desc = "plugins/cmp: togglw completion doc window" })
			MAP({ "i", "s", "n" }, "<C-f>", function()
				if not cmp.scroll_docs(1) then feedkeys("<C-f>") end
			end, { desc = "plugins/cmp: scroll down completion element docs or just do <C-F>" })
			MAP({ "i", "s", "n" }, "<C-b>", function() if not cmp.scroll_docs(-1) then feedkeys("<C-b>") end end,
				{ desc = "plugins/cmp: scroll up completion element docs or just do <C-B>" })
		end
	} }
