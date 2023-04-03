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
bind("n", "<leader>bb", "<C-^>", opts) -- flip buffer
bind("n", "<leader>k", ":bnext<CR>", opts) -- next buffer
bind("n", "<leader>l", ":bprev<CR>", opts) -- previous buffer
bind("n", "<leader>bd", ":bdelete<CR>", opts)

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

-- Yanky
bind({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
bind({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
bind({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
bind({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
bind("n", "<c-n>", "<Plug>(YankyCycleForward)")
bind("n", "<c-p>", "<Plug>(YankyCycleBackward)")

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
bind("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- toggle split window maximization

-- nvim-tree
bind("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts) -- toggle file explorer

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
bind("n", "<leader>fm", "<cmd>Telescope marks<cr>", opts) -- list all marks
bind("n", "<leader>ft", "<cmd>Telescope tags<cr>", opts) -- list all tags
bind("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts) -- list recently opened files
bind("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", opts) -- list all diagnostics
bind("n", "<leader>dc", "<cmd>Telescope command_history<cr>", opts) -- list all commands
bind("n", "<leader>dk", "<cmd>Telescope keymaps<cr>", opts) -- list all keymaps
bind("n", "<leader>dv", "<cmd>Telescope vim_options<cr>", opts) -- list all vim options
bind("n", "<leader>yw", "<cmd>Telescope yank_history<cr>", opts) -- list all yanks

-- ChatGPT
bind("n", "<leader>cg", "<cmd>ChatGPT<cr>", opts) -- open chatgpt window
bind("v", "<leader>cg", "<cmd>ChatGPTEditWithInstructions<cr>", opts) -- open chatgpt editwithinstructions window
bind("n", "<leader>cs", "<cmd>ChatGPTActAs<cr>", opts) -- send chatgpt message

-- Dadbod
bind("n", "<leader>du", "<cmd>DBUIToggle<cr>", opts) -- open dadbod ui
bind("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", opts)
bind("n", "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", opts)
bind("n", "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", opts)

-- telescope git commands (not on youtube nvim video, opts)
bind("n", "<leader>gf", "<cmd>Telescope git_files<cr>", opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
bind("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
bind("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", opts) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
bind("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts) -- list git branches (use <cr> to checkout) ["gb" for git branch]
bind("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts) -- list current changes per file with diff preview ["gs" for git status]

-- Git - dv in fugitive
bind("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", opts)
bind("n", "gu", "<cmd>diffget //2<cr>", opts) -- get the upper version of a diff
bind("n", "gh", "<cmd>diffget //3<cr>", opts) -- get the lower version of a diff

-- Diffview
bind("n", "D", ":DiffviewOpen<cr>", opts)

-- restart lsp server (not on youtube nvim video, opts)
bind("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

-- My Binds
bind("n", "<leader>gt", ":lua Go_to_test_file()<CR>", opts)
bind("n", "<leader>ct", ":lua Create_test_file()<CR>", opts)
bind("n", "<f9>", ":!./gradlew build<CR>", opts)
