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

vim.g.mapleader = " "

require("lazy").setup({
	"nvim-lua/plenary.nvim",
	-- Theme
	"bluz71/vim-nightfly-guicolors",
	"catppuccin/nvim",
	-- Tmux & window navigation
	-- "christoomey/vim-tmux-navigator",
	"szw/vim-maximizer",
	-- Essentials
	"tpope/vim-surround", -- Surrond like vs-code
	"vim-scripts/ReplaceWithRegister", -- Use register for replacement grw
	"numToStr/Comment.nvim", -- Comment line
	"kyazdani42/nvim-web-devicons", -- Icons
	-- "nvim-tree/nvim-tree.lua", -- Nvim Tree
	"norcalli/nvim-colorizer.lua", -- colors
	{ "shortcuts/no-neck-pain.nvim", version = "*" }, -- no neck pain
	"ThePrimeagen/harpoon", -- Harpoon
	-- Lualine
	"nvim-lualine/lualine.nvim",
	-- Tests
	"vim-test/vim-test",
	-- Telescope
	{ "nvim-telescope/telescope.nvim", branch = "0.1.x" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
	"nvim-telescope/telescope-file-browser.nvim",
	-- Autocomplete
	"hrsh7th/nvim-cmp", -- completion plugin
	"hrsh7th/cmp-buffer", -- source for text in buffer
	"hrsh7th/cmp-path", -- source for file system paths
	-- "github/copilot.vim", -- Copilot
	"zbirenbaum/copilot.lua", -- Copilot Lua
	-- Snippets
	"L3MON4D3/LuaSnip", -- snippet engine
	"saadparwaiz1/cmp_luasnip", -- for autocompletion
	"rafamadriz/friendly-snippets", -- useful snippets
	-- Managing & Installing Lsp servers, Linters & Formatters
	"williamboman/mason.nvim", -- in charge of managing lsp servers, linters & formatters
	"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
	-- Configuring Lsp Servers
	"neovim/nvim-lspconfig", -- easily configure language servers
	"hrsh7th/cmp-nvim-lsp", -- for autocompletion
	{ "glepnir/lspsaga.nvim", branch = "main" }, -- enhanced lsp uis
	"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion
	-- Formatting & Linting
	"jose-elias-alvarez/null-ls.nvim", -- configure formatters & linters
	"jayp0521/mason-null-ls.nvim", -- bridges gap b/w mason & null-ls
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
	},
	-- Auto Closing
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...
	-- git integration
	"lewis6991/gitsigns.nvim", -- show line modifications on left hand side
	"tpope/vim-fugitive", -- fugitive
	"gbprod/yanky.nvim", -- yanky
})
