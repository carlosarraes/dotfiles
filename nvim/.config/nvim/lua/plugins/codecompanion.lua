return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		if vim.g.vscode then
			return
		end

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
					return require("codecompanion.adapters").extend("anthropic", {
						env = {
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "anthropic" },
				inline = { adapter = "anthropic" },
				agent = { adapter = "anthropic" },
			},
		})
	end,
}
