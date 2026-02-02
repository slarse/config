vim.g.mapleader = ";"
vim.keymap.set("n", "<leader>ee", vim.cmd.Ex)

-- moving text blocks around in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- search term in middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- clear search by pressing escape in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- brackets
vim.keymap.set("i", "<leader>u", "()<Left>")
vim.keymap.set("i", "<leader><leader>u", "()")
vim.keymap.set("i", "<leader>e", "[]<Left>")
vim.keymap.set("i", "<leader><leader>e", "[]")
vim.keymap.set("i", "<leader>,", "{}<Left>")
vim.keymap.set("i", "<leader><leader>,", "{}")
vim.keymap.set("i", "<leader><", "<><Left>")
vim.keymap.set("i", "<leader><leader><", "<>")

-- strings
vim.keymap.set("i", "<leader>'", "''<Left>")
vim.keymap.set("i", "<leader><leader>'", "''")
vim.keymap.set("i", '<leader>"', '""<Left>')
vim.keymap.set("i", '<leader><leader>"', '""')
vim.keymap.set("i", "<leader>`", "``<Left>")
vim.keymap.set("i", "<leader><leader>`", "``")

-- diagnostics
vim.keymap.set("n", "<leader>nd", "<cmd>lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "<leader>pd", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
