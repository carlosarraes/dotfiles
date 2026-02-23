---@type vim.lsp.Config
return {
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		"--clang-tidy",
		"--suggest-missing-includes",
	},
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_markers = { ".git" },
}
