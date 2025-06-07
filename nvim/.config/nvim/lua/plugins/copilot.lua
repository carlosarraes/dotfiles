return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		if vim.g.vscode then
			return
		end

		local copilot = require("copilot")

		copilot.setup({
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-4>",
				},
				layout = {
					position = "bottom",
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<C-s>",
					accept_word = false,
					accept_line = false,
					next = "<C-e>",
					prev = "<C-q>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				markdown = true,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node",
			server_opts_overrides = {},
		})
	end,
}
