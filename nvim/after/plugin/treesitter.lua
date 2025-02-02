local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.bruno = {
	install_info = {
		url = "https://github.com/slarse/tree-sitter-bruno",
		files = { "src/parser.c", "src/scanner.c" },
		branch = "add-auth-oauth2",
	},
	filetype = "bruno", -- if filetype does not match the parser name
}

vim.filetype.add({
	extension = {
		bru = "bruno",
	},
})

require("nvim-treesitter.configs").setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "c", "rust", "python", "lua", "vim", "vimdoc", "query", "go", "sql", "bruno", "javascript" },
	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,

		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		additional_vim_regex_highlighting = false,
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<C-space>",
			node_incremental = "<C-space>",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
})
