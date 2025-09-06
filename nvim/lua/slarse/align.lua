-- Naive implementation of aligning lines. It functions under the premise that the delimiter is a single byte that
-- cannot appear as part of a multi-byte character. It's a safe enough assumption that mostly works out.
local function align(opts)
	local start_row = math.min(opts.line1, opts.line2)
	local end_row = math.max(opts.line1, opts.line2)
	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)

	local word_sizes = {}
	local delimiter = " "

	for _, line in pairs(lines) do
		local idx = 1
		local width = 0

		for i = 1, #line do
			local char = line:sub(i, i)
			if char ~= delimiter then
				width = width + 1
			else
				if width > 0 then
					word_sizes[idx] = math.max(word_sizes[idx] or 0, width)
					idx = idx + 1
					width = 0
				end
			end
		end

		if width > 0 then
			word_sizes[idx] = math.max(word_sizes[idx] or 0, width)
		end
	end

	local aligned_lines = {}
	for i, line in pairs(lines) do
		local col = 1
		local aligned_line = ""
		for word in string.gmatch(line, "[^%s]+") do
			local col_width = word_sizes[col] + 1
			local aligned_word = string.rep(delimiter, col_width - #word) .. word
			aligned_line = aligned_line .. aligned_word

			col = col + 1
		end

		aligned_lines[i] = aligned_line
	end

	vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, true, aligned_lines)
end

vim.api.nvim_create_user_command("Align", align, { range = true })

vim.keymap.set("v", "<leader>ta", ":Align<CR>")
