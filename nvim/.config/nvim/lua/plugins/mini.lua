return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.ai").setup()
		require("mini.comment").setup()
		local miniFiles = require("mini.files")
		miniFiles.setup()
		require("mini.surround").setup()

		-- Keybinds
		vim.keymap.set("n", "-", function()
			miniFiles.open(vim.api.nvim_buf_get_name(0), false)
			miniFiles.reveal_cwd()
		end, { noremap = true, silent = true })
	end,
}
