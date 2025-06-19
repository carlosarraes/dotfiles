return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"folke/snacks.nvim", -- optional
	},
	config = function()
		require("neogit").setup({
			integrations = {
				snacks = true,
			},
		})
	end,
}
