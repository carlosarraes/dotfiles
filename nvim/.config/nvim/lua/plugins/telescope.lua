-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

local setup, yanky = pcall(require, "yanky")
if not setup then
	return
end

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- move to prev result
				["<C-j>"] = actions.move_selection_next, -- move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("yank_history")

local utils = require("yanky.utils")
local mapping = require("yanky.telescope.mapping")

yanky.setup({
	picker = {
		telescope = {
			mappings = {
				default = mapping.put("p"),
				i = {
					["<c-p>"] = mapping.put("p"),
					["<c-k>"] = mapping.put("P"),
					["<c-x>"] = mapping.delete(),
					["<c-r>"] = mapping.set_register(utils.get_default_register()),
				},
				n = {
					p = mapping.put("p"),
					P = mapping.put("P"),
					d = mapping.delete(),
					r = mapping.set_register(utils.get_default_register()),
				},
			},
		},
	},
})
