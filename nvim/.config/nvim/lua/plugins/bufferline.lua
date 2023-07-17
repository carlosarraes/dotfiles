local ok, bufferline = pcall(require, "bufferline")
if not ok then
	return
end

bufferline.setup({}, {
	hightlights = {
		fill = {
			fg = { attribute = "fg", highlight = "TabLine" },
			bg = { attribute = "bg", highlight = "TabLine" },
		},
	},
})
