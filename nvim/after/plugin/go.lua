require("go").setup({
	goimports = "gopls", -- if set to 'gopls' will use golsp format
	gofmt = "golines", -- if set to gopls will use golsp format
	max_line_len = 120,
	tag_transform = false,
	test_dir = "",
	comment_placeholder = "   ",
	lsp_cfg = false,
	lsp_gofumpt = false,
	lsp_on_attach = false,
	dap_debug = true,
})
