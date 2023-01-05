-- local status, _ = pcall(vim.cmd, "colorscheme catppuccin")
-- if not status then
-- 	print("Colorscheme not found!")
-- 	return
-- end
--
local status, catppuccin = pcall(require, "catppuccin")
if not status then
	print("Catppuccin not found")
	return
end

catppuccin.setup({
	transparent_background = true,
	term_colors = true,
	integrations = {
		cmp = true,
		gitsigns = true,
		nvimtree = true,
		telescope = true,
		-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
