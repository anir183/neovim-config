--[[ keymaps that remap or map base neovim keymaps, functions or commands ]]

vim.g.mapleader = " ";
vim.g.maplocalleader = "//";

NMAP("<leader>ms", vim.cmd.messages, { desc = "core/base: open messages window" });

-- moving text
-- WARNING : using "<cmd>" instead of ":" breaks these commands
NMAP("<C-j>", "v:m '>+1<CR>gv=<ESC>", { desc = "core/base: move the current line up" });
NMAP("<C-k>", "v:m '<-2<CR>gv=<ESC>", { desc = "core/base: move the current line down" });
MAP("v", "<C-j>", ":m '>+1<CR>gv=<ESC>gv", { desc = "core/base: move current selection up" });
MAP("v", "<C-k>", ":m '<-2<CR>gv=<ESC>gv", { desc = "core/base: move current selection down" });

-- stationary cursor
NMAP("J", "mzJ`z", { desc = "core/base: don't move the cursor when joining the next line" });
NMAP("<C-d>", "<C-d>zz", { desc = "core/base: keep cursor centered when scrolling down" });
NMAP("<C-u>", "<C-u>zz", { desc = "core/base: keep the cursor at the center when scrolling up" });
NMAP("n", "nzzzv", { desc = "core/base: keep cursor centered while navigating search results" });
NMAP("N", "Nzzv", { desc = "core/base: keep cursor centered while navigating search results" });

-- modification/extensions of existing keymaps
MAP({ "n", "v" }, "x", "\"_x", { desc = "core/base: remove without copying" });
MAP("x", "<leader>p", "\"_dP", { desc = "core/base: paste over selection without copying" });
MAP({ "n", "v" }, "<leader>y", "\"+y", { desc = "core/base: yank to system clipboard" });
NMAP("<leader>Y", "\"+Y", { desc = "core/base: yank till end of line to system clipboard" });
MAP({ "n", "v" }, "<leader>d", "\"_d", { desc = "core/base: delete without copying" });
NMAP("<leader>D", "\"_D", { desc = "core/base: delete till end of line without copying" });
MAP({ "n", "v" }, "<leader>c", "\"_c", { desc = "core/base: delete and edit without copying" });
NMAP("<leader>C", "\"_C", { desc = "core/base: delete till eol and edit without copying" });

-- split resizing
NMAP("-", function() vim.cmd.wincmd("<") end, { desc = "core/base: increase window width" });
NMAP("+", function() vim.cmd.wincmd(">") end, { desc = "core/base: decrease window width" });
NMAP("<leader>+", function() vim.cmd.wincmd("+") end, { desc = "core/base: increase window height" });
NMAP("<leader>-", function() vim.cmd.wincmd("-") end, { desc = "core/base: decrease window height" });

-- quick fix list
NMAP("<leader>q", vim.cmd.copen, { desc = "core/base: open the quick fix list" });
NMAP("<leader>Q", vim.cmd.ccl, { desc = "core/base: close the quick fix list" });
NMAP("]q", vim.cmd.cnext, { desc = "core/base: walk forward in the quick fix list" });
NMAP("[q", vim.cmd.cprev, { desc = "core/base: walk backward the quick fix list" });

vim.api.nvim_create_autocmd('LspAttach', {
	group = AUGRP,
	callback = function()
		-- Rename the variable under your cursor.
		--  Most Language Servers support renaming across files, etc.
		NMAP("<leader>rn", vim.lsp.buf.rename, { desc = "core/base: rename" });

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		MAP({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "core/base: code actions" });

		-- WARN : This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		NMAP("gD", vim.lsp.buf.declaration, { desc = "core/base: goto declarations" });
	end
});
