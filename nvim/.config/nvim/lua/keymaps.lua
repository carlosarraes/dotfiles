local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
bind("n", "<C-s>", ":w<CR>", opts)
bind("n", "<leader>nh", ":nohl<CR>", opts)

-- Window management
bind("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
bind("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
bind("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
bind("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Buffer management
bind("n", "<tab>", ":bnext<CR>", opts) -- next buffer
bind("n", "<s-tab>", ":bprev<CR>", opts) -- previous buffer

-- Tabs
bind("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
bind("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab

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

-- Clipboard/Yanks
bind("v", "<leader>y", '"+y', opts) -- Needs xclip (Arch)
bind("n", "<leader>y", '"+y', opts)
bind("v", "<leader>d", '"_d', opts)
bind("n", "<leader>d", '"_d', opts)
bind("n", "x", '"_x', opts)

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

----------------------
-- Plugin Keybinds
----------------------

-- Lazy
bind("n", "<leader>l", ":Lazy<CR>", opts)

-- Dadbod
bind("n", "<leader>du", "<cmd>DBUIToggle<cr>", opts) -- open dadbod ui
bind("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", opts)
bind("n", "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", opts)

-- CCompanion
bind({ "n", "v" }, ";cc", "<cmd>CodeCompanionChat Toggle<cr>", opts)
bind({ "n", "v" }, ";ca", "<cmd>CodeCompanionActions<cr>", opts)
vim.cmd([[cab cc CodeCompanion]])

-- Yanky
bind({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts)
bind({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts)
bind({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts)
bind({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts)
bind("n", "<c-n>", "<Plug>(YankyCycleForward)", opts)
bind("n", "<c-p>", "<Plug>(YankyCycleBackward)", opts)
bind("n", ";yw", ":YankyRingHistory<CR>", opts)

-- MiniFiles
bind("n", "<leader>e", ":lua MiniFiles.open()<cr>", opts)

local termtoggle = require("local.term")
bind("n", "<C-t>", termtoggle.toggleterm, { desc = "toggle terminal" })
bind("t", "<C-t>", termtoggle.toggleterm, { buffer = termtoggle.buf, desc = "toggle terminal" })
