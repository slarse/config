local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local create_task_finder = function(opts)
	return finders.new_oneshot_job(
		vim.tbl_flatten({
			"rg",
			"--vimgrep",
			"\\- \\[ \\]",
			vim.fn.expand("%:p:h"),
		}),
		{
			entry_maker = make_entry.gen_from_vimgrep(opts),
		}
	)
end

local find_tasks = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Tasks",
			finder = create_task_finder(opts),
			previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				local function mark()
					local selection = action_state.get_selected_entry()
					local current_picker = action_state.get_current_picker(prompt_bufnr)

					local bufnr = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_call(bufnr, function()
						vim.cmd.edit(selection.filename)
						local line_index = selection.lnum - 1
						local x_column = selection.col + 2
						vim.api.nvim_buf_set_text(0, line_index, x_column, line_index, x_column + 1, { "x" })
						vim.cmd.write(selection.filename)

						vim.api.nvim_buf_set_text(
							current_picker.previewer.state.bufnr,
							line_index,
							x_column,
							line_index,
							x_column + 1,
							{ "x" }
						)
						local new_finder = create_task_finder(opts)
						current_picker:refresh(new_finder, opts)
					end)
				end

				map("i", "<c-x>", mark)

				return true
			end,
		})
		:find()
end

vim.api.nvim_create_user_command("Tasks", function()
	find_tasks(require("telescope.themes").get_dropdown({}))
end, {})
