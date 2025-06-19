return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			adapters = {
				deepseek = function()
					return require("codecompanion.adapters").extend("deepseek", {
						env = {
							api_key = "sk-a10f7bff6757489dbc4b2245a88c46d4",
						},
						schema = {
							model = {
								default = "deepseek-chat",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "deepseek",
				},
				inline = {
					adapter = "deepseek",
				},
				cmd = {
					adapter = "deepseek",
				},
			},
			display = {
				inline = {
					layout = "buffer",
				},
			},
			diff = {
				enabled = true,
				provider = "mini_diff",
			},
		})
	end,
}
