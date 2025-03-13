--[[ debug adpater protocol ]]

return {
	-- bridge with mason to install daps
	{
		"jay-babu/mason-nvim-dap.nvim",
		name = "mason_dap",
		dependencies = { "dap" },
		config = function()
			local ensure_installed_daps = {}
			local handlers = {
				function(config) require("mason-nvim-dap").default_setup(config) end,
			}

			for dap_name, handler in pairs(OPTS.daps) do
				table.insert(ensure_installed_daps, dap_name)

				if handler then handlers[dap_name] = handler end
			end

			require("mason-nvim-dap").setup({
				ensure_installed = ensure_installed_daps,
				automatic_installation = true,
				handlers = handlers,
			})

			-- just to make sure that mason's setup finished first
			vim.defer_fn(function()
				local dap = require("dap")

				for _, dap_setup in ipairs(OPTS.dap_other) do
					local index = 1
					for name, opts in pairs(dap_setup) do
						if index == 1 then
							dap.adapters[name] = opts
						elseif index == 2 then
							dap.configurations[name] = opts
						end

						index = index + 1
					end
				end
			end, 10)
		end
	},

	-- debug adapter
	{
		"mfussenegger/nvim-dap",
		name = "dap",
		dependencies = { "mason" },
		config = function()
			local dap = require("dap")

			NMAP("<F1>", dap.toggle_breakpoint, { desc = "plugins/dap: toggle breakpoint" });
			NMAP(
				"<F2>",
				function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")); end,
				{ desc = "plugins/dap: set a conditional breakpoint" }
			);
			NMAP(
				"<F3>",
				function() dap.set_breakpoint(nil, nil, vim.fn.input("Log Point Message: ")); end,
				{ desc = "plugins/dap: set a breakpoint with a log message" }
			);
			NMAP(
				"<F4>",
				dap.run_to_cursor,
				{ desc = "plugins/dap: run till the line containing the cursor" }
			);

			NMAP(
				"<F5>",
				function() require("dap.ui").eval(nil, { enter = true }); end,
				{ desc = "plugins/dap: evaluate the variable under the cursor" }
			);

			NMAP("<leader>dr", dap.restart, { desc = "plugins/dap: restart" });
			NMAP("<F6>", dap.continue, { desc = "plugins/dap: continue" });
			NMAP("<F7>", dap.step_into, { desc = "plugins/dap: step into" });
			NMAP("<F8>", dap.step_over, { desc = "plugins/dap: step over" });
			NMAP("<F9>", dap.step_out, { desc = "plugins/dap: step out" });
			NMAP("<F10>", dap.step_back, { desc = "plugins/dap: step back" });
		end
	},

	-- ui for dap
	{
		"rcarriga/nvim-dap-ui",
		name = "dap_ui",
		dependencies = {
			"dap",
			"nio",
			{ "theHamsta/nvim-dap-virtual-text", name = "dap_virtual_text" },
			{
				"LiadOz/nvim-dap-repl-highlights",
				name = "dap_repl_highlights",
				dependencies = { "treesitter" },
			},
		},
		config = function()
			local dap = require("dap");
			local dapui = require("dapui");

			dapui.setup()

			-- not "really" required fields
			---@diagnostic disable-next-line: missing-fields
			require("nvim-dap-virtual-text").setup({
				-- hides and sensitive tokens... just in case
				display_callback = function(variable)
					print('wtf');
					local name = string.lower(variable.name);
					local value = string.lower(variable.value);

					if (
						name:match("secret")
						or name:match("api")
						or value:match("secret")
						or value:match("api")
					) then
						return " ******"
					end

					if (#variable.value > 15) then
						return " " .. string.sub(variable.value, 1, 15) .. "... ";
					end

					return " " .. variable.value;
				end,
			})

			dap.listeners.before.attach.dapui_config = function() dapui.open(); end
			dap.listeners.before.launch.dapui_config = function() dapui.open(); end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.open(); end
			dap.listeners.before.event_exited.dapui_config = function() dapui.open(); end

			NMAP("<leader>dt", dapui.toggle, { desc = "plugins/dapui: toggle the dap ui" });
			NMAP(
				"<leader>dr",
				function() dapui.open({ reset = true }); end,
				{ desc = "plugins/dapui: reset the dap ui" }
			);
		end
	}
}
