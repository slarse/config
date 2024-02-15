local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function open_in_hidden_window(filename)
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winnr = vim.api.nvim_open_win(bufnr, false, { relative = "editor", width = 1, height = 1, col = 0, row = 0 })
	vim.cmd.edit(filename)
	return winnr
end

local find_tasks = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Tasks",
			finder = finders.new_oneshot_job(
				vim.tbl_flatten({
					"rg",
					"--vimgrep",
					"\\- \\[ \\]",
					vim.fn.expand("%:p:h"),
				}),
				{
					entry_maker = make_entry.gen_from_vimgrep(opts),
				}
			),
			previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(_, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()

					local winnr = open_in_hidden_window(selection.filename)

					local line_index = selection.lnum - 1
					local x_column = selection.col + 2
					vim.api.nvim_buf_set_text(0, line_index, x_column, line_index, x_column + 1, { "x" })
					vim.cmd.write(selection.pathname)

					vim.api.nvim_win_close(winnr, true)
					vim.cmd.stopinsert()
				end)
				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("Tasks", function()
	find_tasks(require("telescope.themes").get_dropdown({}))
end, {})
