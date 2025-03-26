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

			---@diagnostic disable-next-line: missing-fields
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

	-- set of cool features
	{
		"folke/snacks.nvim",
		name = "snacks",
		priority = 1000, -- some plugins may depend on snacks
		config = function()
			require("snacks").setup({
				bigfile = { enabled = true },
				input = { enabled = true },
				indent = { enabled = true, scope = { enabled = false }  },
				lazygit = { enabled = true },
				picker = { enabled = true },
				notifier = { enabled = true },
				dim = { enabled = true },
				notify = { enabled = true },
				rename = { enabled = true },
				quickfile = { enabled = true },
				scope = { enabled = true },
				words = { enabled = true },
				zen = { enabled = true }
			});

			vim.api.nvim_create_autocmd("User", {
				group = AUGRP,
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})

			NMAP("<leader><space>", function() Snacks.picker.smart() end, { desc = "plugins/snacks: smart find files" });
			NMAP("<leader>,", function() Snacks.picker.buffers() end, { desc = "plugins/snacks: buffers" });
			NMAP("<leader>/", function() Snacks.picker.grep() end, { desc = "plugins/snacks: grep" });
			NMAP("<leader>:", function() Snacks.picker.command_history() end, { desc = "plugins/snacks: command history" });
			NMAP("<leader>n", function() Snacks.picker.notifications() end, { desc = "plugins/snacks: notification history" });
			NMAP("<leader>e", function() Snacks.explorer() end, { desc = "plugins/snacks: file explorer" });

			-- Find
			---@diagnostic disable-next-line: assign-type-mismatch
			NMAP("<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "plugins/snacks: find config file" });
			NMAP("<leader>ff", function() Snacks.picker.files() end, { desc = "plugins/snacks: find files" });
			NMAP("<leader>fg", function() Snacks.picker.git_files() end, { desc = "plugins/snacks: find git files" });
			NMAP("<leader>fp", function() Snacks.picker.projects() end, { desc = "plugins/snacks: projects" });
			NMAP("<leader>fr", function() Snacks.picker.recent() end, { desc = "plugins/snacks: recent" });

			-- Git
			NMAP("<leader>gb", function() Snacks.picker.git_branches() end, { desc = "plugins/snacks: git branches" });
			NMAP("<leader>gl", function() Snacks.picker.git_log() end, { desc = "plugins/snacks: git log" });
			NMAP("<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "plugins/snacks: git log line" });
			NMAP("<leader>gs", function() Snacks.picker.git_status() end, { desc = "plugins/snacks: git status" });
			NMAP("<leader>gS", function() Snacks.picker.git_stash() end, { desc = "plugins/snacks: git stash" });
			NMAP("<leader>gd", function() Snacks.picker.git_diff() end, { desc = "plugins/snacks: git diff (hunks)" });
			NMAP("<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "plugins/snacks: git log file" });

			-- Grep
			NMAP("<leader>sb", function() Snacks.picker.lines() end, { desc = "plugins/snacks: buffer lines" });
			NMAP("<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "plugins/snacks: grep open buffers" });
			NMAP("<leader>sg", function() Snacks.picker.grep() end, { desc = "plugins/snacks: grep" });
			MAP({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "plugins/snacks: visual selection or word" });

			-- Search
			NMAP('<leader>s"', function() Snacks.picker.registers() end, { desc = "plugins/snacks: registers" });
			NMAP('<leader>s/', function() Snacks.picker.search_history() end, { desc = "plugins/snacks: search history" });
			NMAP("<leader>sb", function() Snacks.picker.lines() end, { desc = "plugins/snacks: buffer lines" });
			NMAP("<leader>sC", function() Snacks.picker.commands() end, { desc = "plugins/snacks: commands" });
			NMAP("<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "plugins/snacks: diagnostics" });
			NMAP("<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "plugins/snacks: buffer diagnostics" });
			NMAP("<leader>sh", function() Snacks.picker.help() end, { desc = "plugins/snacks: help pages" });
			NMAP("<leader>sH", function() Snacks.picker.highlights() end, { desc = "plugins/snacks: highlights" });
			NMAP("<leader>sj", function() Snacks.picker.jumps() end, { desc = "plugins/snacks: jumps" });
			NMAP("<leader>sk", function() Snacks.picker.keymaps() end, { desc = "plugins/snacks: keymaps" });
			NMAP("<leader>sl", function() Snacks.picker.loclist() end, { desc = "plugins/snacks: location list" });
			NMAP("<leader>sm", function() Snacks.picker.marks() end, { desc = "plugins/snacks: marks" });
			NMAP("<leader>sq", function() Snacks.picker.qflist() end, { desc = "plugins/snacks: quickfix list" });

			-- -- LSP
			NMAP("gd", function() Snacks.picker.lsp_definitions() end, { desc = "plugins/snacks: goto definition" });
			NMAP("gD", function() Snacks.picker.lsp_declarations() end, { desc = "plugins/snacks: goto declaration" });
			NMAP("gr", function() Snacks.picker.lsp_references() end, { desc = "plugins/snacks: references", nowait = true });
			NMAP("gI", function() Snacks.picker.lsp_implementations() end, { desc = "plugins/snacks: goto implementation" });
			NMAP("gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "plugins/snacks: goto t[y]pe definition" });
			NMAP("<leader>ls", function() Snacks.picker.lsp_symbols() end, { desc = "plugins/snacks: lsp symbols" });
			NMAP("<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "plugins/snacks: lsp workspace symbols" });

			-- -- Other
			NMAP("<leader>z",  function() Snacks.zen() end, { desc = "plugins/snacks: toggle zen mode" });
			NMAP("<leader>Z",  function() Snacks.zen.zoom() end, { desc = "plugins/snacks: toggle zoom" });
			NMAP("<leader>.",  function() Snacks.scratch() end, { desc = "plugins/snacks: toggle scratch buffer" });
			NMAP("<leader>S",  function() Snacks.scratch.select() end, { desc = "plugins/snacks: select scratch buffer" });
			NMAP("<leader>n",  function() Snacks.notifier.show_history() end, { desc = "plugins/snacks: notification history" });
			NMAP("<leader>bd", function() Snacks.bufdelete() end, { desc = "plugins/snacks: delete buffer" });
			NMAP("<leader>cR", function() Snacks.rename.rename_file() end, { desc = "plugins/snacks: rename file" });
			MAP({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "plugins/snacks: git browse" });
			NMAP("<leader>gg", function() Snacks.lazygit() end, { desc = "plugins/snacks: lazygit" });
			NMAP("<leader>un", function() Snacks.notifier.hide() end, { desc = "plugins/snacks: dismiss all notifications" });
			NMAP("<c-/>",      function() Snacks.terminal() end, { desc = "plugins/snacks: toggle terminal" });
			MAP({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "plugins/snacks: next reference" });
			MAP({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "plugins/snacks: prev reference" });
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

			local parsers_config = require("nvim-treesitter.parsers").get_parser_configs();
			for parser_name, parser_body in pairs(OPTS.ts_parsers) do
				parsers_config[parser_name] = parser_body;
			end
		end,
	}
}
