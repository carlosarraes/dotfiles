-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) -- to setup format on save

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		formatting.gofumpt, -- go formatter
		formatting.goimports, -- go formatter
		formatting.stylua, -- lua formatter
		formatting.csharpier, -- c# formatter
		formatting.prettierd, -- js/ts formatter
		formatting.google_java_format, -- java formatter
		formatting.black, -- python formatter
		formatting.isort, -- python formatter
		formatting.mix, -- elixir formatter
		formatting.ocamlformat, -- ocaml formatter
		formatting.rustfmt, -- rust formatter
		formatting.rubocop.with({
			filetypes = { "ruby", "erb" },
		}), -- ruby formatter
		-- formatting.eslint_d, -- js/ts formatter - for projetcs that lint doesnt work well
		diagnostics.mypy, -- python linter
		diagnostics.golangci_lint, -- go linter
		-- diagnostics.eslint_d, -- js linter
		diagnostics.eslint_d.with({ -- js/ts linter
			-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
			condition = function(utils)
				return utils.root_has_file({ ".eslintrc.json", ".eslintrc.cjs" }) -- change file extension if you use something else
			end,
		}),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
