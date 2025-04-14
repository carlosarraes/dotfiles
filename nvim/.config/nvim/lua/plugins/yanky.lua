return {
	"gbprod/yanky.nvim",
	config = function()
		if vim.g.vscode then
			return
		end

		require("yanky").setup({})
	end,
}
