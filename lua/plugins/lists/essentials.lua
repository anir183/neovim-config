--[[ tools which really increase coding efficiency and I personally cant code without at this point ]]

return {
	-- quick buffer switcher as a substitute for tab bar
	{
		"ThePrimeagen/Harpoon",
		name = "harpoon",
		branch = "harpoon2",
		dependencies = { "plenary" },
		config = function()
			local harpoon = require("harpoon")

			harpoon.setup({
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			})

			NMAP(
				"<leader>ht", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
				{ desc = "plugins/harpoon: open harpoon file list" }
			)
			NMAP(
				"<leader>ha", function() harpoon:list():add() end,
				{ desc = "plugins/harpoon: add open file to harpoon list" }
			)

			NMAP(
				"<leader>1", function() harpoon:list():select(1) end,
				{ desc = "plugins/harpoon: go to the first file in harpoon list" }
			)
			NMAP(
				"<leader>2", function() harpoon:list():select(2) end,
				{ desc = "plugins/harpoon: go to the second file in harpoon list" }
			)
			NMAP(
				"<leader>3", function() harpoon:list():select(3) end,
				{ desc = "plugins/harpoon: go to the third file in harpoon list" }
			)
			NMAP(
				"<leader>4", function() harpoon:list():select(4) end,
				{ desc = "plugins/harpoon: go to the fourth file in harpoon list" }
			)
			NMAP(
				"<leader>5", function() harpoon:list():select(5) end,
				{ desc = "plugins/harpoon: go to the fifth file in harpoon list" }
			)

			NMAP(
				"]h", function() harpoon:list():next() end,
				{ desc = "plugins/harpoon: go to the next file in harpoon list" }
			)
			NMAP(
				"[h", function() harpoon:list():prev() end,
				{ desc = "plugins/harpoon: go to the previous file in harpoon list" }
			)
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		name = "telescope",
		branch = "0.1.x",
		dependencies = { "plenary", "devicons" },
		config = function()
			require("telescope").setup({
				picker = { buffers = { initial_mode = "normal" } }
			})

			local telescope_builtin = require("telescope.builtin")

			NMAP(
				"<leader>/", telescope_builtin.current_buffer_fuzzy_find,
				{ desc = "plugins/telescope: fuzzy find through current buffer" }
			)
			NMAP(
				"<leader>ff", telescope_builtin.find_files,
				{ desc = "plugins/telescope: fuzzy find through project files" }
			)
			NMAP(
				"<leader>FF", function() telescope_builtin.find_files({ hidden = true }) end,
				{ desc = "plugins/telescope: fuzzy find through project files" }
			)
			NMAP(
				"<leader>fF", function() telescope_builtin.find_files({ hidden = true, no_ignore = true }) end,
				{ desc = "plugins/telescope: fuzzy find through project files" }
			)
			NMAP(
				"<leader>fh", telescope_builtin.help_tags,
				{ desc = "plugins/telescope: fuzzy find through neovim help tags" }
			)
			NMAP(
				"<leader>fn",
				function() telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
				{ desc = "plugins/telescope: fuzzy find through neovim config files" }
			)
			NMAP(
				"<leader>fo", telescope_builtin.oldfiles,
				{ desc = "plugins/telescope: fuzzy find through recent files" }
			)
			NMAP(
				"<leader>fk", telescope_builtin.keymaps,
				{ desc = "plugins/telescope: fuzzy find through all keymaps" }
			)
			NMAP(
				"<leader>fg", telescope_builtin.live_grep,
				{ desc = "plugins/telescope: fuzzy find through grep results live" }
			)
			NMAP(
				"<leader>fr", telescope_builtin.registers,
				{ desc = "plugins/telescope: fuzzy find through vim registers" }
			)
			NMAP(
				"<leader>fb", telescope_builtin.buffers,
				{ desc = "plugins/telescope: fuzzy find through all open buffers" }
			)
			NMAP(
				"<leader>fc", telescope_builtin.commands,
				{ desc = "plugins/telescope: fuzzy find through all commands" }
			)
			NMAP(
				"gr", telescope_builtin.lsp_references,
				{ desc = "plugins/telescope: fuzzy find through the references of the word under cursor" }
			)
			NMAP(
				"gI", telescope_builtin.lsp_implementations,
				{ desc = "plugins/telescope: fuzzy find throught the implemtations of word under cursor" }
			)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = AUGRP,
				callback = function()
					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					NMAP("gd", telescope_builtin.lsp_definitions,
						{ desc = "plugins/telescope: goto definition" })

					-- Find references for the word under your cursor.
					NMAP("gr", telescope_builtin.lsp_references,
						{ desc = "plugins/telescope: goto references" })

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					NMAP("gI", telescope_builtin.lsp_implementations,
						{ desc = "plugins/telescope: goto implementation" })

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					NMAP("<leader>td", telescope_builtin.lsp_type_definitions,
						{ desc = "plugins/telescope: lsp type definitions" })

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					NMAP("<leader>ds", telescope_builtin.lsp_document_symbols,
						{ desc = "plugins/telescope: lsp document symbols" })

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					NMAP("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols,
						{ desc = "plugins/telescope: lsp dynamic workspace symbols" })
				end
			})
		end
	},

	{
		"nvim-treesitter/nvim-treesitter",
		name = "treesitter",
		build = ":TSUpdate",
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin) -- some plugins use treesitter stuff but do not explicitly load treesitter so we add it to rtp so that it is avialble to anything that needs it
			require("nvim-treesitter.query_predicates") -- avoids any loading issues by already loading the predicates
			require("nvim-treesitter.install").prefer_git = true -- prefer parser installations via git
		end,
		config = function()
			-- missing fields not necessary for this config
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "vimdoc", "comment", "markdown", "markdown_inline" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	}
}
