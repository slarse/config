local lsp = require('lsp-zero')
local cmp = require('cmp')

lsp.preset({
    name='minimal',
    set_lsp_keymaps = {omit = {'<F2>'}},
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr}
    local bind = vim.keymap.set

    bind('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
end)

lsp.ensure_installed({
	'tsserver',
	'eslint',
	'lua_ls',
	'rust_analyzer',
	'pyright',
})

require('lspconfig').rust_analyzer.setup({procMacros = {enable = true}})

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("i", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
keymap("s", "<c-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
keymap("i", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
keymap("s", "<c-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

lsp.setup()
