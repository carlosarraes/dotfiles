return {
	"tpope/vim-surround",
	"tpope/vim-abolish",
	"tpope/vim-fugitive",
	"SmiteshP/nvim-navic",
	"mbbill/undotree",
	"voldikss/vim-floaterm",
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{ "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
}
