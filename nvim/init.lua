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
		"smoka7/hop.nvim",
		version = "v2.*",
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
	},
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

	{
		"slarse/teletasks.nvim",
		dranch = "main",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("teletasks")
		end,
	},

	{
		"ray-x/go.nvim",
		dependencies = { "ray-x/guihua.lua" },
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},

	{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text" } },

	{ "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = "nvim-lua/plenary.nvim" },

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
		},
		event = { "BufReadPre", "BufNewFile" },
		run = ":TSUpdate",
	},

	"theprimeagen/harpoon",
	"tpope/vim-fugitive",

	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			{ "L3MON4D3/LuaSnip" },
			"rafamadriz/friendly-snippets",
		},
	},

	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			floating_window = false,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	"mhartington/formatter.nvim",
	"tpope/vim-surround",
	"mbbill/undotree",

	{ "nvim-lualine/lualine.nvim", dependencies = { "kyazdani42/nvim-web-devicons", opt = true } },

	"joshdick/onedark.vim",
	"mhartington/oceanic-next",
	{ "rose-pine/neovim", as = "rose-pine" },

	{
		"nomnivore/ollama.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

		keys = {
			{
				"<leader>oo",
				":<c-u>lua require('ollama').prompt()<cr>",
				desc = "ollama prompt",
				mode = { "n", "v" },
			},

			{
				"<leader>oG",
				":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
				desc = "ollama Generate Code",
				mode = { "n", "v" },
			},

			{
				"<leader>oM",
				":<c-u>lua require('ollama').prompt('Modify_Code')<cr>",
				desc = "ollama Modify Code",
				mode = { "n", "v" },
			},
		},

		---@type Ollama.Config
		opts = {
			model = "phi3",
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = false,
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

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
