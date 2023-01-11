vim.g.mapleader = " "
local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
bind("n", "<C-s>", ":w<CR>", opts)
bind("n", "<C-z>", "u", opts)
bind("n", "<leader>nh", ":nohl<CR>", opts)

-- Increment/decrement numbers
bind("n", "<leader>=", "<C-a>", opts) -- increment
bind("n", "<leader>-", "<C-x>", opts) -- decrement

-- Window management
bind("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
bind("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
bind("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
bind("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Tabs
bind("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
bind("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab

-- QoL
bind("n", "<leader>q", ":q<CR>", opts)
bind("n", "<leader>Q", ":qa!<CR>", opts)
bind("v", "J", ":m '>+1<CR>gv=gv", opts)
bind("v", "K", ":m '<-2<CR>gv=gv", opts)
bind("n", "J", "mzJ`z", opts)
bind("n", "<C-d>", "<C-d>zz", opts)
bind("n", "<C-u>", "<C-u>zz", opts)
bind("n", "n", "nzzzv", opts)
bind("n", "N", "Nzzzv", opts)
bind("i", "<C-q>", "<C-o>zz", opts)
bind("n", "<leader>p", "cw<C-r>0<ESC>", opts)
bind("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
bind("v", "<leader>/", "<esc>/\\%V", opts) -- search within selection

-- Clipboard/Yanks
bind("v", "<leader>y", '"+y', opts) -- Needs xclip (Arch)
bind("n", "<leader>y", '"+y', opts)
bind("v", "<leader>d", '"_d', opts)
bind("n", "<leader>d", '"_d', opts)
bind("n", "x", '"_x', opts)

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
bind("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- toggle split window maximization

-- nvim-tree
-- bind("n", "<leader>e", ":NvimTreeToggle<CR>", opts) -- toggle file explorer

-- vim-tests
bind("n", "<leader>tt", ":TestFile<CR>", opts) -- run all tests in current file
bind("n", "<leader>tn", ":TestNearest<CR>", opts) -- run nearest test
bind("n", "<leader>tl", ":TestLast<CR>", opts) -- run last test
bind("n", "<leader>tf", ":TestSuite<CR>", opts) -- run test suite

-- telescope
bind("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts) -- find files within current working directory, respects .gitignore
bind("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", opts) -- find string in current working directory as you type
bind("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts) -- find string under cursor in current working directory
bind("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- list open buffers in current neovim instance
bind("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- list available help tags

-- telescope git commands (not on youtube nvim video, opts)
bind("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
bind("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", opts) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
bind("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts) -- list git branches (use <cr> to checkout) ["gb" for git branch]
bind("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts) -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server (not on youtube nvim video, opts)
bind("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
