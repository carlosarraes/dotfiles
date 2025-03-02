return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("codecompanion").setup({
			display = {
				action_palette = {
					provider = "default",
					opts = {
						show_default_actions = true,
						show_default_prompt_library = true,
					},
				},
			},
			adapters = {
				deepseek = function()
					return require("codecompanion.adapters").extend("deepseek", {
						env = {
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "deepseek" },
				inline = { adapter = "deepseek" },
				agent = { adapter = "deepseek" },
			},
		})
	end,
}
