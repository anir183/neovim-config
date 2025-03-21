-- add some filetypes
vim.filetype.add(vim.tbl_extend("force", {
	extension = {
		env = "dotenv",
	},
	filename = {
		[".env"] = "dotenv",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
	}
}, OPTS.additional_iletypes));
