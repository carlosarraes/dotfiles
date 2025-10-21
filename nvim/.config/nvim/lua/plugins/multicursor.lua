local mc = require("multicursor-nvim")
mc.setup({})

local bind = vim.keymap.set
bind({ "n", "v" }, "<up>", function()
	mc.lineAddCursor(-1)
end)
bind({ "n", "v" }, "<down>", function()
	mc.lineAddCursor(1)
end)
bind({ "n", "v" }, ";k", function()
	mc.lineSkipCursor(-1)
end)
bind({ "n", "v" }, ";j", function()
	mc.lineSkipCursor(1)
end)

bind("v", "<leader>n", function()
	mc.matchAddCursor(1)
end)
bind({ "n", "v" }, "<leader>s", function()
	mc.matchSkipCursor(1)
end)
bind({ "n", "v" }, "<leader>N", function()
	mc.matchAddCursor(-1)
end)
bind({ "n", "v" }, "<leader>S", function()
	mc.matchSkipCursor(-1)
end)

bind("v", "<c-n>", function()
	mc.addCursor("*")
end)

bind("v", "<c-s>", function()
	mc.skipCursor("*")
end)

bind({ "n", "v" }, "<left>", mc.nextCursor)
bind({ "n", "v" }, "<right>", mc.prevCursor)

bind("v", "<leader>x", mc.deleteCursor)

bind("n", "<c-leftmouse>", mc.handleMouse)

bind({ "n", "v" }, "<c-q>", function()
	if mc.cursorsEnabled() then
		mc.disableCursors()
	else
		mc.addCursor()
	end
end)

bind({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

bind("n", "<esc>", function()
	if not mc.cursorsEnabled() then
		mc.enableCursors()
	elseif mc.hasCursors() then
		mc.clearCursors()
	else
	end
end)

bind("v", "<leader>a", mc.alignCursors)

bind("v", "S", mc.splitCursors)

bind("v", "I", mc.insertVisual)
bind("v", "A", mc.appendVisual)

bind("v", "M", mc.matchCursors)

bind("v", "<leader>t", function()
	mc.transposeCursors(1)
end)
bind("v", "<leader>T", function()
	mc.transposeCursors(-1)
end)

vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
