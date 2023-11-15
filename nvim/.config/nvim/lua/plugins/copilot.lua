local copilot_setup, copilot = pcall(require, "copilot")
if not copilot_setup then
	return
end

local copilot_cmp_setup, cmp = pcall(require, "copilot_cmp")
if not copilot_cmp_setup then
	return
end

copilot.setup({
	panel = {
		enabled = false,
		auto_refresh = false,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>",
		},
		layout = {
			position = "bottom", -- | top | left | right
			ratio = 0.4,
		},
	},
	suggestion = {
		enabled = false,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<M-1>",
			accept_word = false,
			accept_line = false,
			next = "<M-2>",
			prev = "<M-3>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = "node", -- Node.js version must be > 16.x
	server_opts_overrides = {},
})

cmp.setup()
