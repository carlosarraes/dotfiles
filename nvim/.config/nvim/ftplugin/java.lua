-- import jdtls plugin safely
local jdtls_setup, jdtls = pcall(require, "jdtls")
if not jdtls_setup then
	return
end

local home = os.getenv("HOME")
if vim.fn.has("mac") == 1 then
	WORKSPACE_PATH = home .. "/workspace/"
	CONFIG = "mac"
elseif vim.fn.has("unix") == 1 then
	WORKSPACE_PATH = home .. "/workspace/"
	CONFIG = "linux"
else
	print("Unsupported system")
end

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = WORKSPACE_PATH .. project_name

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == "" then
	return
end

local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bind = vim.keymap.set -- for conciseness

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

	-- jdtls specific keymaps
	if client.name == "jdtls" then
		local _, _ = pcall(vim.lsp.codelens.refresh)
		local map = function(mode, lhs, rhs, desc)
			if desc then
				desc = desc
			end

			vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
		end
		map("n", "<leader>jo", jdtls.organize_imports, opts)
		map("n", "<leader>jv", jdtls.extract_variable, opts)
		map("n", "<leader>jc", jdtls.extract_constant, opts)
		map("n", "<leader>jm", jdtls.extract_method, opts)
		map("n", "<leader>jt", jdtls.test_nearest_method, opts)
		map("n", "<leader>jT", jdtls.test_class, opts)
		map("n", "<leader>ju", "<Cmd>JdtUpdateConfig<CR>", opts)
		map("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
		map("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
		map("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
	end
end

local jcapabilities = {
	workspace = {
		configuration = true,
	},
	textDocument = {
		completion = {
			completionItem = {
				snippetSupport = true,
			},
		},
	},
}

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_" .. CONFIG,
		"-data",
		workspace_dir,
	},
	root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew" }),
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-19",
						path = "/usr/lib/jvm/java-19-openjdk",
					},
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk",
					},
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk",
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = { preferred = "fernflower" },
		extendedClientCapabilities = extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},

	flags = {
		allow_incremental_sync = true,
	},
	capabilities = jcapabilities,
	on_attach = on_attach,
}

require("jdtls").start_or_attach(config)
