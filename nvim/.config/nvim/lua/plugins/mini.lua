require("mini.ai").setup()
require("mini.diff").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.jump").setup({
	mappings = {
		repeat_jump = ",",
	},
})
local miniFiles = require("mini.files")
miniFiles.setup()
vim.keymap.set("n", "-", function()
	miniFiles.open(vim.api.nvim_buf_get_name(0), false)
	miniFiles.reveal_cwd()
end, { noremap = true, silent = true })
