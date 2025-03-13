--[[ custom statusline formatting ]]

-- remove statusline background
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" });
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" });
vim.api.nvim_set_hl(0, "StatusLineTerm", { bg = "none" });
vim.api.nvim_set_hl(0, "StatusLineTermNC", { bg = "none" });

local mode_strings = {
	["n"] = " normal ", ["niI"] = " insert [normal] ", ["niR"] = " replace [normal] ",
	["nt"] = " terminal [normal] ", ["i"] = " insert ", ["R"] = " replace ",
	["v"] = " visual ", ["V"] = " visual [line] ", [""] = " visual [block] ",
	["c"] = " command ", ["!"] = " command [external] ", ["t"] = " terminal "
}

-- components used in the statusline
STSLN_COMP = {
	filename = function()
		return ("%%#%s#%s%%*"):format("Directory", " %t ");
	end,

	position = function()
		return ("%%#%s#%s%%*"):format("Substitute", " %l:%-c ~ %2p%% ");
	end,

	mode = function()
		local mode = mode_strings[vim.fn.mode()];
		return ("%%#%s#%s%%*"):format("IncSearch", mode);
	end,

	warnings = function()
		local count = vim.diagnostic.count()[vim.diagnostic.severity.WARN];
		count = count and " " .. count .. " " or "";
		return ("%%#%s#%s%%*"):format("DiagnosticWarn", count);
	end,

	errors = function()
		local warn_count = vim.diagnostic.count()[vim.diagnostic.severity.WARN];
		local error_count = vim.diagnostic.count()[vim.diagnostic.severity.ERROR];
		error_count = error_count and (warn_count and "" or " ") .. error_count .. " " or (warn_count and "" or " ");
		return ("%%#%s#%s%%*"):format("DiagnosticError", error_count);
	end
}

-- creating the statusline format
vim.opt.statusline = table.concat({
	"%{%v:lua.STSLN_COMP.mode()%}",
	"%{%v:lua.STSLN_COMP.warnings()%}",
	"%{%v:lua.STSLN_COMP.errors()%}",
	"%r", "%w", "%h", "%m", "%=",
	"%{%v:lua.STSLN_COMP.filename()%}",
	"%{%v:lua.STSLN_COMP.position()%}"
}, "");
