local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

-- General
bind("n", "<C-s>", ":w<CR>", opts)
bind("n", "<leader>nh", ":nohl<CR>", opts)
bind("n", "<space>", "<Nop>")
bind("n", "x", '"_x', opts)
bind("n", ";a", ":lua vim.lsp.buf.format()<CR>", opts) -- Format the current buffer using LSP
bind("v", "<Leader>p", '"_dP') -- Paste without overwriting the default register
bind("x", "y", [["+y]], opts) -- Yank to the system clipboard in visual mode
bind("t", "<Esc>", "<C-\\><C-N>") -- Exit terminal mode

-- Window management
bind("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
bind("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
bind("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
bind("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Buffer management
bind("n", "<tab>", ":bnext<CR>", opts) -- next buffer
bind("n", "<s-tab>", ":bprev<CR>", opts) -- previous buffer
bind("n", "<leader>x", ":bd<CR>", opts) -- close current buffer

-- Tabs
bind("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
bind("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab

-- Copy paths
bind("n", ";yr", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Copied path to clipboard: " .. path)
end, opts)
bind("n", ";yd", function()
	local path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", path)
	print("Copied directory path to clipboard: " .. path)
end, opts)
bind("n", ";yf", function()
	local path = vim.fn.expand("%:t")
	vim.fn.setreg("+", path)
	print("Copied filename to clipboard: " .. path)
end, opts)
bind("n", ";yp", function()
	local path = vim.fn.expand("%:p")
	local cwd = vim.fn.getcwd()
	local rel_path = path:gsub("^" .. vim.pesc(cwd .. "/"), "")
	vim.fn.setreg("+", rel_path)
	print("Copied relative path to clipboard: " .. rel_path)
end, opts)

-- QoL
bind("n", "<leader>q", ":q<CR>", opts)
bind("n", "<leader>Q", ":qa!<CR>", opts)
bind("v", "J", ":m '>+1<CR>gv=gv", opts)
bind("v", "K", ":m '<-2<CR>gv=gv", opts)
bind("n", "J", "mzgJ`z", opts)
bind("n", "<C-d>", "<C-d>zz", opts)
bind("n", "<C-u>", "<C-u>zz", opts)
bind("n", "<C-Down>", "<C-d>zz", opts)
bind("n", "<C-Up>", "<C-u>zz", opts)
bind("n", "n", "nzzzv", opts)
bind("n", "N", "Nzzzv", opts)
bind("n", "<leader>p", "cw<C-r>0<ESC>b", opts)
bind("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts) -- replace word under cursor
bind("v", "<leader>/", "<esc>/\\%V", opts) -- search within selection
bind("n", "<Return>", "o<ESC>k", opts)
bind("n", "<leader>5", ":UndotreeToggle<CR>", opts)

-- Vim pack
bind("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>")

-- LSP
bind("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Hover to see details
bind("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- Hover to see details
bind("n", "gi", function()
	vim.lsp.buf.implementation({ border = "single" })
end, opts)
bind("n", "gr", "<cmd>lua require('fzf-lua').lsp_references()<cr>", opts)
bind("n", "<C-n>", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, opts)
bind("n", "<C-p>", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, opts)
bind("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition
bind("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition in a vertical split

-- FzfLua
bind("n", ";f", "<cmd>lua require('fzf-lua').files()<cr>", opts)
bind("n", ";r", "<cmd>lua require('fzf-lua').live_grep()<cr>", opts)
bind("n", ";d", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>", opts)
-- bind("n", ";r", "<cmd>lua require('fzf-lua').live_grep_glob({ filter = \"rg -v '*tests/'\" })<cr>", opts)
bind("n", ";;", "<cmd>lua require('fzf-lua').resume()<cr>", opts)
