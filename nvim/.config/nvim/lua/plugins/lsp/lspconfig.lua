-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local status, util = pcall(require, "lspconfig/util")
if not status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local bind = vim.keymap.set -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	bind("n", "gd", vim.lsp.buf.definition, opts) -- show definition
	bind("n", "gD", vim.lsp.buf.declaration, opts) -- show declaration
	bind("n", "gr", vim.lsp.buf.references, opts) -- show references
	bind("n", "gi", vim.lsp.buf.implementation, opts) -- go to implementation
	bind("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
	bind("n", "<space>ca", vim.lsp.buf.code_action, opts)
	bind("n", "<space>rn", vim.lsp.buf.rename, opts)
	bind("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	bind("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")

	-- LspSaga
	bind({ "n", "v" }, "<leader>sca", "<cmd>Lspsaga code_action<CR>")
	bind("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	bind("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	bind("n", "<leader>grn", "<cmd>Lspsaga rename ++project<CR>", opts) -- smart rename
	bind({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>") -- term

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		bind("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		bind("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports
		bind("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "gohtml" },
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["gopls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			gofumpt = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			linksInHover = true,
			codelenses = {
				generate = true,
				gc_details = true,
				regenerate_cgo = true,
				tidy = true,
				upgrade_depdendency = true,
				vendor = true,
			},
			usePlaceholders = true,
		},
	},
})

lspconfig["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		"rustup",
		"run",
		"stable",
		"rust-analyzer",
	},
})

lspconfig["volar"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["csharp_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["crystalline"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["elixirls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
