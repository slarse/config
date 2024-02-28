local non_c_line_comments_by_filetype = {
	lua = "--",
	python = "#",
	sql = "--",
}

local function comment_out(opts)
	local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
	local start = math.min(opts.line1, opts.line2)
	local finish = math.max(opts.line1, opts.line2)

	vim.api.nvim_command(start .. "," .. finish .. "s:^:" .. line_comment .. ":")
	vim.api.nvim_command("noh")
end

local function uncomment(opts)
	local line_comment = non_c_line_comments_by_filetype[vim.bo.filetype] or "//"
	local start = math.min(opts.line1, opts.line2)
	local finish = math.max(opts.line1, opts.line2)

	pcall(vim.api.nvim_command, start .. "," .. finish .. "s:^\\(\\s\\{-\\}\\)" .. line_comment .. ":\\1:")
	vim.api.nvim_command("noh")
end

vim.api.nvim_create_user_command("CommentOut", comment_out, { range = true })
vim.keymap.set("v", "<leader>co", ":CommentOut<CR>")
vim.keymap.set("n", "<leader>co", ":CommentOut<CR>")

vim.api.nvim_create_user_command("Uncomment", uncomment, { range = true })
vim.keymap.set("v", "<leader>uc", ":Uncomment<CR>")
vim.keymap.set("n", "<leader>uc", ":Uncomment<CR>")
