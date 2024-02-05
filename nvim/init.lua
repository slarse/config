require("slarse")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

lazy.setup({
	{
		"slarse/nvim-dbee",
		branch = "remove-duplicate-tag",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup(--[[optional config]])
		end,
	},

	{ "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = "nvim-lua/plenary.nvim" },

	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

	"theprimeagen/harpoon",
	"tpope/vim-fugitive",

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
					{
						"MattiasMTS/cmp-dbee",
						ft = "sql",
					},
				},
			},
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			{ "L3MON4D3/LuaSnip" },
			"rafamadriz/friendly-snippets",
		},
	},

	"mhartington/formatter.nvim",
	"tpope/vim-surround",
	"mbbill/undotree",

	{ "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons", opt = true } },

	"joshdick/onedark.vim",
	"mhartington/oceanic-next",
	{ "rose-pine/neovim", as = "rose-pine" },

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<leader>a",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},
})

vim.api.nvim_create_user_command("CheckBox", "s /\\[.*\\]/[x]/", {})
