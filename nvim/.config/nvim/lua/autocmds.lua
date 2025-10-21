local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 170 })
	end,
	group = highlight_group,
})

local function organize_imports()
	local ft = vim.bo.filetype:gsub("react$", "")
	if not vim.tbl_contains({ "javascript", "typescript" }, ft) then
		return
	end
	local ok = vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
		command = (ft .. ".organizeImports"),
		arguments = { vim.api.nvim_buf_get_name(0) },
	}, 3000)
	if not ok then
		print("Command timeout or failed to complete.")
	end
end

autocmd("BufWritePre", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = function()
		organize_imports()
	end,
})
