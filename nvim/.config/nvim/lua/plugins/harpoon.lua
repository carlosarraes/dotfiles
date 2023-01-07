local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

bind("n", "<leader>a", mark.add_file, opts)
bind("n", "<leader>h", ui.toggle_quick_menu, opts)

bind("n", "<leader>1", function()
	ui.nav_file(1)
end, opts)
bind("n", "<leader>2", function()
	ui.nav_file(2)
end, opts)
bind("n", "<leader>3", function()
	ui.nav_file(3)
end, opts)
bind("n", "<leader>4", function()
	ui.nav_file(4)
end, opts)
