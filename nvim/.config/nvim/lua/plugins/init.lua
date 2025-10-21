local plugins = {
	{ name = "mason", src = "https://github.com/mason-org/mason.nvim" },
	{ name = "blink", src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ name = "fzf", src = "https://github.com/ibhagwan/fzf-lua" },
	{ name = "bufferline", src = "https://github.com/akinsho/bufferline.nvim" },
	{ name = "lualine", src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ name = "tokyonight", src = "https://github.com/folke/tokyonight.nvim" },
	{ name = "nui", src = "https://github.com/MunifTanjim/nui.nvim" },
	{ name = "noice", src = "https://github.com/folke/noice.nvim" },
	{ name = "supermaven", src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ name = "mini", src = "https://github.com/echasnovski/mini.nvim" },
	{ name = "conform", src = "https://github.com/stevearc/conform.nvim" },
	{ name = "lint", src = "https://github.com/mfussenegger/nvim-lint" },
	{ name = "gitsigns", src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ name = "multicursor", src = "https://github.com/jake-stewart/multicursor.nvim" },
	{ name = "vim-tmux-navigator", src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ name = "treesitter", src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ name = "autotag", src = "https://github.com/windwp/nvim-ts-autotag" },
}

local pack_specs = {}
for _, p in ipairs(plugins) do
	table.insert(pack_specs, { src = p.src, version = p.version })
end
vim.pack.add(pack_specs, { load = true })

for _, p in ipairs(plugins) do
	pcall(require, "plugins." .. p.name)
end
