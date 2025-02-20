return {
	"tpope/vim-abolish",
	"tpope/vim-fugitive",
	"SmiteshP/nvim-navic",
	"mbbill/undotree",
	{
		"tronikelis/ts-autotag.nvim",
		opts = {},
		-- ft = {}, optionally you can load it only in jsx/html
		event = "VeryLazy",
	},
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
	},
	{
		"yioneko/nvim-vtsls",
		config = function()
			require("lspconfig.configs").vtsls = require("vtsls").lspconfig
		end,
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
}
