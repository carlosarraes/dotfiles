require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-s>",
		clear_suggestion = "<C-]>",
		accept_word = "<C-w>",
	},
	color = {
		suggestion_color = "#ffffff",
		cterm = 244,
	},
	log_level = "info",
	disable_inline_completion = false,
	disable_keymaps = false,
	condition = function()
		return false
	end,
})
