require("slarse")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()`, required for `toggle()` — otherwise optional
			{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
		},
		config = function()
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`
			}

			-- Required for `vim.g.opencode_opts.auto_reload`
			vim.opt.autoread = true

			-- Recommended/example keymaps
			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask about this" })
			vim.keymap.set({ "n", "x" }, "<leader>o+", function()
				require("opencode").prompt("@this")
			end, { desc = "Add this" })

			vim.keymap.set({ "n", "x" }, "<leader>oe", function()
				require("opencode").prompt("Explain @this and its context", { submit = true })
			end, { desc = "Explain this" })
			vim.keymap.set({ "n", "x" }, "<leader>os", function()
				require("opencode").select()
			end, { desc = "Select prompt" })
			vim.keymap.set("n", "<leader>ot", function()
				require("opencode").toggle()
			end, { desc = "Toggle embedded" })
			vim.keymap.set("n", "<leader>on", function()
				require("opencode").command("session_new")
			end, { desc = "New session" })
			vim.keymap.set("n", "<leader>oi", function()
				require("opencode").command("session_interrupt")
			end, { desc = "Interrupt session" })
			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("messages_half_page_up")
			end, { desc = "Messages half page up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("messages_half_page_down")
			end, { desc = "Messages half page down" })
		end,
	},

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
			require("go").setup({
				dap_debug_keymap = false,
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},

	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text", "nvim-neotest/nvim-nio" },
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
	},

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
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				"nvim-dap-ui",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			{ "j-hui/fidget.nvim", opts = {} },
		},
	},

	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {
			bind = true,
			floating_window = true,
			toggle_key = "<M-x>",
			toggle_key_flip_floatwin_setting = true,
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
})

vim.api.nvim_create_user_command("CheckBox", "s /\\[.*\\]/[x]/", {})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
