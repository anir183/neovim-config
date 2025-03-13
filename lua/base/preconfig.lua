--[[ make initial preparations for the rest of the config ]]

-- globally available set of options which can be edited by user
OPTS = vim.tbl_deep_extend(
	"force", require("base.default_opts"),
	pcall(require, "custom.opts") and require("custom.opts") or {}
);

-- create augroup for custom autocommands
AUGRP = vim.api.nvim_create_augroup("anir183_s_augroup", { clear = true });

-- keymap functions
MAP = vim.keymap.set;
NMAP = function(...) MAP("n", ...) end

-- set default colorsheme in case plugin ones dont work
vim.cmd.colorscheme("habamax");
vim.api.nvim_set_hl(0, "Normal", { bg = "none" });
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#151515" });
vim.api.nvim_set_hl(0, "VertSplit", { fg="#585858", bg = "none" });
