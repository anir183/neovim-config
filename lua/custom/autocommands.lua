--[[ custom autocommands ]]

local new_aucmd = vim.api.nvim_create_autocmd;

-- disable color column in netrw, undotree and help pages
new_aucmd("FileType", {
	group = AUGRP,
	pattern = { "netrw", "help", "undotree" },
	callback= function()
		vim.opt_local.colorcolumn = "0";
		vim.opt_local.statuscolumn = "%s";
		vim.opt_local.statusline = nil;
	end
});

-- highlight yanked text
new_aucmd("TextYankPost", {
	group = AUGRP,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 50 });
	end
});

-- disable number column when in netrw and undotree
-- NOTE : The winleave and focuslost autocommands are used to counteract the autocommand below this one
new_aucmd({ "winEnter", "WinLeave", "FocusLost", "FocusGained", "BufReadPre", "FileReadPre" }, {
	group = AUGRP,
	pattern = { "netrw", "undotree" },
	callback = function()
		vim.opt_local.number = false;
		vim.opt_local.relativenumber = false;
	end
});

-- show only line numbers and disable relative numbers when focus is lost
new_aucmd({ "WinEnter", "FocusGained" }, {
	group = AUGRP,
	callback = function()
		vim.opt_local.number = true;
		vim.opt_local.relativenumber = true;
	end
});
new_aucmd({ "WinLeave", "FocusLost" }, {
	group = AUGRP,
	callback = function()
		vim.opt_local.number = true;
		vim.opt_local.relativenumber = false;
	end
});

-- set the leadmultispace value correctly on file load or focus
new_aucmd({ "WinEnter", "BufEnter" }, {
	group = AUGRP,
	callback = function()
		vim.opt.listchars:append({ leadmultispace = "▎" .. ("∙"):rep(vim.opt_local.tabstop._value - 1) });
	end
});

-- anything the user wants to execute when the config is ready
new_aucmd("VimEnter", {
	group = AUGRP,
	callback = function() OPTS.after() end
});
