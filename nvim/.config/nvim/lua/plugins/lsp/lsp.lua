return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"saghen/blink.cmp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		if vim.g.vscode then
			return
		end

		local lspconfig = require("lspconfig")
		local util = require("lspconfig/util")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local on_attach = function(client, bufnr)
			local on_list = require("plugins.lsp.utils.ignore_modules")
			local def_split = require("plugins.lsp.utils.def_split")
			local navic = require("nvim-navic")
			local opts = { noremap = true, silent = true, buffer = bufnr }
			local bind = vim.keymap.set

			bind("n", "gV", def_split, opts)
			bind("n", "gd", function()
				vim.lsp.buf.definition({ on_list = on_list })
			end, opts) -- go to definition
			bind("n", "gD", ":lua Snacks.picker.lsp_declarations()<cr>", opts) -- go to declaration
			bind("n", "gr", ":lua Snacks.picker.lsp_references()<cr>", opts) -- show references
			bind("n", "gi", ":lua Snacks.picker.lsp_implementations()()<cr>", opts) -- show references
			bind("n", "gt", ":lua Snacks.picker.lsp_type_definitions()<cr>", opts) -- show references
			bind("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
			bind({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
			bind("n", "<space>rn", vim.lsp.buf.rename, opts)
			bind("n", "<C-p>", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
			bind("n", "<C-n>", "<cmd>lua vim.diagnostic.goto_next()<CR>")
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
		end

		vim.diagnostic.config({
			signs = {
				active = {
					{ name = "DiagnosticSignError", text = " " },
					{ name = "DiagnosticSignWarn", text = " " },
					{ name = "DiagnosticSignHint", text = "󰠠 " },
					{ name = "DiagnosticSignInfo", text = " " },
				},
			},
			-- other options you might already be using, e.g.:
			virtual_text = false,
			severity_sort = true,
		})

		lspconfig["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["marksman"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["emmet_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "css", "sass", "scss", "less", "svelte" },
		})

		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		lspconfig["pyright"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["rust_analyzer"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})

		lspconfig["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = util.root_pattern("go.mod", ".git"),
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
				},
			},
		})

		lspconfig["bashls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "bash-language-server", "start" },
			filetypes = { "sh", "bash", "zsh" },
		})

		lspconfig["clangd"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lspconfig["zls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = { "zls" },
			filetypes = { "zig" },
			root_dir = util.root_pattern("build.zig", "build.zig.lock", "build.zig.json", ".git"),
		})
	end,
}
