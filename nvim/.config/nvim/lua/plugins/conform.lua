require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofumpt" },
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
