--[[ bootstrap and initialize lazy.nvim package manager ]]

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim";                                                           -- path where lazy is installed

-- download lazy if not already and all to nvim runtime path
-- definitely not a undefined field
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
	local git_clone_output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazy_path
	});

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ git_clone_output,               "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {});
		vim.fn.getchar();
		os.exit(1);
	end
end
vim.opt.rtp:prepend(lazy_path);

-- setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins.lists" },
		{ import = "plugins.lists.dev_tools" },
		OPTS.plugins,
	},
	rocks = { enabled = false },                                                                                       -- disable lua rocks support as we dont use it
	checker = { enabled = true, notify = false },                                                                      -- check for updates but dont notify
	change_detection = { enabled = true, notify = false },                                                             -- check for changes but dont notify
});

NMAP("<leader>lz", vim.cmd.Lazy, { desc = "plugins/lazy: open the lazy window" });
