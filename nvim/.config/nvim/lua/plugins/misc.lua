return {
	"tpope/vim-abolish",
	"tpope/vim-fugitive",
	"SmiteshP/nvim-navic",
	"mbbill/undotree",
	"nvim-tree/nvim-web-devicons",
	{
		"tronikelis/ts-autotag.nvim",
		opts = {},
		-- ft = {}, optionally you can load it only in jsx/html
		event = "VeryLazy",
	},
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
	},
	{
		"yioneko/nvim-vtsls",
		config = function()
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

				bind("n", "<leader>rf", ":VtsExec rename_file<CR>") -- rename file and update imports
				bind("n", "<leader>ri", ":VtsExec remove_unused_imports<CR>") -- remove unused variables
				bind("n", "<leader>ru", ":VtsExec organize_imports<CR>") -- organize imports
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				end
			end

			require("lspconfig").vtsls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
				},
			})
		end,
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
}
