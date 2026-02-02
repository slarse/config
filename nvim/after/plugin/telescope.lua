local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<c-f>"] = "to_fuzzy_refine",
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sff", builtin.find_files, {})
vim.keymap.set("n", "<leader>sgf", builtin.git_files, {})
vim.keymap.set("n", "<leader>sfg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>sfb", builtin.buffers, {})
vim.keymap.set("n", "<leader>sfh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>sds", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>sdd", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>sfo", builtin.oldfiles, {})
