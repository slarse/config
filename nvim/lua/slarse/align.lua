local utf8 = require("slarse.utf8")

-- Naive implementation of aligning lines. It functions under the premise that the delimiter is a single byte that
-- cannot appear as part of a multi-byte character. It's a safe enough assumption that mostly works out.
local function align(opts)
	local start_row = math.min(opts.line1, opts.line2)
	local end_row = math.max(opts.line1, opts.line2)
	local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, true)

	local word_sizes = {}
  local words_by_line = {}
	local delimiter = " "

	for _, line in pairs(lines) do
		local idx = 1
		local width = 0
    local words = {}
    local word = ""

		for _, char in utf8.codes(line) do
			if char ~= delimiter then
				width = width + 1
        word = word .. char
			else
				if width > 0 then
					word_sizes[idx] = math.max(word_sizes[idx] or 0, width)
          words[idx] = word
					idx = idx + 1
					width = 0
          word = ""
				end
			end
		end

		if width > 0 then
			word_sizes[idx] = math.max(word_sizes[idx] or 0, width)
      words[idx] = word
		end

    table.insert(words_by_line, words)
	end

	local aligned_lines = {}
	for i, words in pairs(words_by_line) do
    local aligned_line = ""
    for col, word in pairs(words) do
      local col_width = word_sizes[col] + 1
      local aligned_word = string.rep(delimiter, col_width - utf8.len(word)) .. word
      aligned_line = aligned_line .. aligned_word
    end

		aligned_lines[i] = aligned_line
	end

	vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, true, aligned_lines)
end

vim.api.nvim_create_user_command("Align", align, { range = true })

vim.keymap.set("v", "<leader>ta", ":Align<CR>")
