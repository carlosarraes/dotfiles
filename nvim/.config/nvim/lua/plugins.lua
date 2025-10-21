vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/jake-stewart/multicursor.nvim" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
}, { load = true })

-- Mason
require("mason").setup({})

-- Blink
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = { enabled = true },
	fuzzy = { implementation = "prefer_rust_with_warning" },
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
})

-- FzfLua
require("fzf-lua").setup({})

-- Bufferline
require("bufferline").setup({}, {
	hightlights = {
		fill = {
			fg = { attribute = "fg", highlight = "TabLine" },
			bg = { attribute = "bg", highlight = "TabLine" },
		},
	},
})

-- lualine

require("lualine").setup({
	options = {
		theme = "tokyonight",
		icons_enabled = true,
		component_separators = "|",
		section_separators = "",
	},
})

-- Theme
require("tokyonight").setup({
	transparent = true,
	style = "night",
})
vim.cmd([[colorscheme tokyonight]])

-- Noice
require("noice").setup({
	sp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = false, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

-- Supermaven
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<C-s>",
		clear_suggestion = "<C-]>",
		accept_word = "<C-w>",
	},
	color = {
		suggestion_color = "#ffffff",
		cterm = 244,
	},
	log_level = "info", -- set to "off" to disable logging completely
	disable_inline_completion = false, -- disables inline completion for use with cmp
	disable_keymaps = false, -- disables built in keymaps for more manual control
	condition = function()
		return false
	end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})

-- Gitsigns
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end
		-- Actions
		map("n", ";w", gs.toggle_current_line_blame)
		map("n", ";q", gs.toggle_deleted)
	end,
})

-- Multicursor
local mc = require("multicursor-nvim")
mc.setup({})

local bind = vim.keymap.set
-- Add or skip cursor above/below the main cursor.
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

-- Add or skip adding a new cursor by matching the current word/selection
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

-- Add a cursor and jump to the next word under cursor.
bind("v", "<c-n>", function()
	mc.addCursor("*")
end)

-- Jump to the next word under cursor but do not add a cursor.
bind("v", "<c-s>", function()
	mc.skipCursor("*")
end)

-- Rotate the main cursor.
bind({ "n", "v" }, "<left>", mc.nextCursor)
bind({ "n", "v" }, "<right>", mc.prevCursor)

-- Delete the main cursor.
bind("v", "<leader>x", mc.deleteCursor)

-- Add and remove cursors with control + left click.
bind("n", "<c-leftmouse>", mc.handleMouse)

bind({ "n", "v" }, "<c-q>", function()
	if mc.cursorsEnabled() then
		-- Stop other cursors from moving.
		-- This allows you to reposition the main cursor.
		mc.disableCursors()
	else
		mc.addCursor()
	end
end)

-- clone every cursor and disable the originals
bind({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

bind("n", "<esc>", function()
	if not mc.cursorsEnabled() then
		mc.enableCursors()
	elseif mc.hasCursors() then
		mc.clearCursors()
	else
		-- Default <esc> handler.
	end
end)

-- Align cursor columns.
bind("v", "<leader>a", mc.alignCursors)

-- Split visual selections by regex.
bind("v", "S", mc.splitCursors)

-- Append/insert for each line of visual selections.
bind("v", "I", mc.insertVisual)
bind("v", "A", mc.appendVisual)

-- match new cursors within visual selections by regex.
bind("v", "M", mc.matchCursors)

-- Rotate visual selection contents.
bind("v", "<leader>t", function()
	mc.transposeCursors(1)
end)
bind("v", "<leader>T", function()
	mc.transposeCursors(-1)
end)

-- Customize how cursors look.
vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

-- Mini
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

-- Conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff" },
		javascript = { "prettierd", "prettier", "biome", stop_after_first = true },
		typescript = { "prettierd", "prettier", "biome", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", "biome", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", "biome", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- Lint
local lint = require("lint")
local eslint = lint.linters.eslint_d

lint.linters_by_ft = {
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	python = { "mypy" },
}
eslint.args = {
	"--no-warn-ignored",
	"--format",
	"json",
	"--stdin",
	"--stdin-filename",
	function()
		return vim.api.nvim_buf_get_name(0)
	end,
}
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufWritePost",
	"InsertLeave",
}, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader>l", function()
	lint.try_lint()
end, { desc = "Trigger linting" })

-- Treesitter

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"bash",
		"python",
		"rust",
		"javascript",
		"typescript",
		"json",
		"yaml",
		"toml",
		"html",
		"css",
		"scss",
		"go",
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- Autotag
require("nvim-ts-autotag").setup({})
