--[[ set up options available in core neovim generally using vim.opt ]]

local opt = vim.opt;

-- status column
opt.number = true;
opt.relativenumber = true;
opt.signcolumn = "number";                                                                                               -- show signs in the number column instead of creating a seperate sign column

-- code folding
opt.foldmethod = "manual";
opt.foldcolumn = "0";
opt.foldtext = "";
opt.foldlevelstart = 1;                                                                                                  -- the fold level above which all folds will be closed when opening a buffer for the first time
opt.foldnestmax = 9;
opt.foldcolumn = "auto:9";

-- text wrapping
opt.wrap = false;
opt.textwidth = 0;
opt.colorcolumn = "81";

-- cursor movement
opt.whichwrap:append("h");
opt.whichwrap:append("l");

-- indents
opt.expandtab = false;                                                                                                   -- use tabs instead of spaces
opt.tabstop = 6;                                                                                                         -- spaces contained in one tab (presumably in normal mode)
opt.shiftwidth = 0;                                                                                                      -- spaces in each level of indentation (0 sets it to tabstop)
opt.softtabstop = -1;                                                                                                    -- spaces contained in a tab (-1 sets it to shiftwidth, presumably in insert mode)
opt.autoindent = true;                                                                                                   -- auto indent new lines based on current line
opt.smartindent = true;                                                                                                  -- context based indentation

-- editor options
opt.updatetime = 250;
opt.termguicolors = true;
opt.cursorline = true;
opt.splitright = true;                                                                                                   -- create new vertical splits on the right side
opt.splitbelow = true;                                                                                                   -- create new horizontal splits below
opt.showmode = false;                                                                                                    -- dont show mode in command line
opt.scrolloff = 8;
opt.ruler = false;
opt.list = true;
local listchars = {
	{ lead = "∙" },
	-- vim.opt.tabstop returns a table instead of the required value
	---@diagnostic disable-next-line: undefined-field
	{ leadmultispace = "▎" .. ("∙"):rep(vim.opt.tabstop._value - 1) },
	{ tab = "▎ " },
	{ trail = "!" },
	{ extends = "‥" },
	{ precedes = "‥" },
};
for _, value in pairs(listchars) do opt.listchars:append(value); end

-- tools
opt.ignorecase = true;                                                                                                   -- ignore case while searching
opt.smartcase = true;                                                                                                    -- ignore case when search input is in lowercase
opt.completeopt = { "menu", "menuone", "noselect", "preview" };
opt.inccommand = "split";                                                                                                -- preview searches/substitutions live and show off screen ones in seperate popup
opt.wrapscan = true;
vim.opt.jumpoptions = "stack,view";                                                                                      -- makes jumping around more consistent https://www.reddit.com/r/neovim/comments/1cytkbq/comment/l7cqdmq

-- backup and undo history
opt.swapfile = false;
opt.backup = false;
opt.writebackup = false;
opt.undofile = true;
