return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"folke/snacks.nvim", -- optional
		"sindrets/diffview.nvim",
	},
	config = function()
		require("diffview").setup({
			keymaps = {
				disable_defaults = false,
				view = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
				file_panel = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
				file_history_panel = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
			},
		})

		require("neogit").setup({
			integrations = {
				snacks = true,
				diffview = true,
			},
		})
	end,
}
