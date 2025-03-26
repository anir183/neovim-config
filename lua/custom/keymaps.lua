--[[ keymaps built with core neovim functionality but does not directly use a command or existing keymaps ]]

-- toggle relative line number
NMAP("<leader>rl", function()
	-- vim.opt.relativenumber returns a table instead of the required value
	---@diagnostic disable-next-line: undefined-field
	vim.opt.relativenumber = not vim.opt.relativenumber._value;
end, { desc = "core/custom: toggle relative line numbers" });

-- toggle fold column
NMAP("zt", function()
	-- vim.opt.foldcolumn returns a table instead of the required value
	---@diagnostic disable-next-line: undefined-field
	vim.opt.foldcolumn = vim.opt.foldcolumn._value == "0" and "auto:9" or "0";
end, { desc = "core/custom: toggle fold column" });

-- edit options in a popup
NMAP("<leader>op", function()
	local ui = vim.api.nvim_list_uis()[1];
	local width = math.floor((ui.width * 0.7) + 0.5);
	local height = math.floor((ui.height * 0.7) + 0.5);

	vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
		relative = "editor",
		width = width,
		height = height,
		col = (ui.width - width) / 2,
		row = (ui.height - height) / 2,
		focusable = true,
		border = "rounded"
	});

	local options_file_path = vim.fn.stdpath("config") .. "/lua/custom/opts.lua";
	local options_file = io.open(options_file_path, "r");

	if options_file == nil then
		local default_options_file_path = vim.fn.stdpath("config") .. "/lua/base/default_opts.lua";
		local default_options_file = io.open(default_options_file_path, "r");

		-- wont be nil
		---@diagnostic disable-next-line: need-check-nil
		local default_quick_settings_content = default_options_file:read("*a");
		-- wont be nil
		---@diagnostic disable-next-line: need-check-nil
		default_options_file:close();

		options_file = io.open(options_file_path, "w");
		-- wont be nil
		---@diagnostic disable-next-line: need-check-nil
		options_file:write(default_quick_settings_content);
	end

	-- wont be nill
	---@diagnostic disable-next-line: need-check-nil
	options_file:close();
	vim.cmd("e " .. options_file_path);
	NMAP("q", vim.cmd.close, {
		buffer = true,
		desc = "core/custom: close the quick settings popup"
	});
end, { desc = "core/custom: edit quick options" });

-- change color column
NMAP("<leader>cl", function()
	vim.ui.input({ prompt = "Enter color column value: " }, function(input)
		if not input then return end

		vim.opt.colorcolumn = input;
	end);
end, { desc = "core/custom: change the color column position" });

-- change indentation style
NMAP("<leader>in", function()
	vim.ui.select(
		{ "tabs", "spaces" },
		{ prompt = "What style of indentation to be set: " },
		function(indentation_style)
			if not indentation_style then return end

			vim.ui.input({ prompt = "Enter tab length: " }, function(tab_len)
				if not tab_len or not tab_len:match("^%-?%d+$") then                                             -- match statement checks if tab_len is a numeric string
					return
				end

				-- first convert everything to tabs as it is easier to work with
				vim.opt.expandtab = false

				vim.opt.tabstop = tonumber(tab_len)

				-- now if the aim is to indent to spaces then convert tabs to spaces
				if indentation_style == "spaces" then
					vim.opt.expandtab = true

					-- vim.opt.tabstop returns a table instead of the required value
					---@diagnostic disable-next-line: undefined-field
					vim.opt.listchars:append({ leadmultispace = "▎" .. ("∙"):rep(vim.opt.tabstop._value - 1) });
				end
			end);
		end
	);
end, { desc = "core/custom: change indentation style" });
NMAP("<leader>IN", function()
	vim.ui.select(
		{ "tabs", "spaces" },
		{ prompt = "What style of indentation to be set: " },
		function(indentation_style)
			if not indentation_style then return end

			vim.ui.input({ prompt = "Enter tab length: " }, function(tab_len)
				if not tab_len or not tab_len:match("^%-?%d+$") then                                             -- match statement checks if tab_len is a numeric string
					return
				end

				-- first convert everything to tabs as it is easier to work with
				vim.opt.expandtab = false
				-- vim.opt.tabstop returns a table instead of the required value
				---@diagnostic disable-next-line: undefined-field
				vim.cmd("silent! %s/\\(^\\s*\\)\\@<=" .. (" "):rep(vim.opt.tabstop._value) .. "/	/g");        -- substitute instead of retab as the command also replaces inline spaces to tabs.  NOTE : regex from https://stackoverflow.com/a/35050756

				vim.opt.tabstop = tonumber(tab_len)

				-- now if the aim is to indent to spaces then convert tabs to spaces
				if indentation_style == "spaces" then
					vim.opt.expandtab = true

					-- vim.opt.tabstop returns a table instead of the required value
					---@diagnostic disable-next-line: undefined-field
					vim.cmd("silent! %s/\\(^\\s*\\)\\@<=	/" .. (" "):rep(vim.opt.tabstop._value) .. "/g");-- substitute instead of retab as the command also replaces inline tabs with spaces

					-- vim.opt.tabstop returns a table instead of the required value
					---@diagnostic disable-next-line: undefined-field
					vim.opt.listchars:append({ leadmultispace = "▎" .. ("∙"):rep(vim.opt.tabstop._value - 1) });
				end
			end);
		end
	);
end, { desc = "core/custom: change indentation style and re-indent" });

-- toggle cursor movement
NMAP(
	"<leader>lc",
	function() vim.opt.scrolloff = 999 - vim.opt.scrolloff._value end,
	{ desc = "core/custom: toggle between moving text and moving cursor" }
);

-- substitute
NMAP("<leader>SW", function()
	vim.ui.input({ prompt = "Enter the target: " }, function(target)
		if not target or target == "" then return end

		vim.ui.input({ prompt = "Enter the substitution: " }, function(substitution)
			if not substitution or substitution == "" then return end

			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes(
					":%s/\\<" .. target .. "\\>/" .. substitution .. "/gI",
					true, true, true
				),
				"n", false
			);
		end);
	end);
end, { desc = "core/custom: substitute standalone occurences of inputted word (not string)" });
NMAP("<leader>SS", function()
	vim.ui.input({ prompt = "Enter the target: " }, function(target)
		if not target or target == "" then return end

		vim.ui.input({ prompt = "Enter the substitution: " }, function(substitution)
			if not substitution or substitution == "" then return end

			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes(
					":%s/" .. target .. "/" .. substitution .. "/gI",
					true, true, true
				),
				"n", false
			);
		end);
	end);
end, { desc = "core/custom: substitute all occurences of inputted string (even as a substring)" });
