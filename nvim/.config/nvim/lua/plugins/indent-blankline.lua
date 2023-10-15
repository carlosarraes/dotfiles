local setup, indent_blankline = pcall(require, "ibl")
if not setup then
	return
end

indent_blankline.setup()
