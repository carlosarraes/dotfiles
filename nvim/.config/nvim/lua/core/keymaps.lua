vim.g.mapleader = " "
local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
bind("n", "<C-s>", ":w<CR>", opts)
bind("n", "<C-z>", "u", opts)
bind("n", "<leader>nh", ":nohl<CR>", opts)

-- Increment/decrement numbers
bind("n", "=", "<C-a>", opts) -- increment
bind("n", "-", "<C-x>", opts) -- decrement

-- Window management
bind("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
bind("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
bind("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
bind("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Buffer management
bind("n", "<s-tab>", ":bprev<CR>", opts) -- previous buffer
bind("n", "<tab>", ":bnext<CR>", opts) -- next buffer
bind("n", "<leader>x", ":bdelete<CR>", opts)

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
bind("n", "<C-Down>", "<C-d>zz", opts)
bind("n", "<C-Up>", "<C-u>zz", opts)
bind("n", "n", "nzzzv", opts)
bind("n", "N", "Nzzzv", opts)
bind("i", "<C-q>", "<C-o>zz", opts)
bind("n", "<leader>p", "cw<C-r>0<ESC>", opts)
bind("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
bind("v", "<leader>/", "<esc>/\\%V", opts) -- search within selection
bind("i", "<A-l>", "<Right>", opts) -- move cursor right
bind("i", "<A-h>", "<Left>", opts) -- move cursor left
bind("i", "<A-k>", "<Up>", opts) -- move cursor up
bind("i", "<A-j>", "<Down>", opts) -- move cursor down
bind("n", "<C-a>", "ggVGo", opts) -- select all
bind("n", "<Return>", "o<ESC>k", opts)
bind("n", "<S-Return>", "O<ESC>j", opts)

-- Clipboard/Yanks
bind("v", "<leader>y", '"+y', opts) -- Needs xclip (Arch)
bind("n", "<leader>y", '"+y', opts)
bind("v", "<leader>d", '"_d', opts)
bind("n", "<leader>d", '"_d', opts)
bind("n", "x", '"_x', opts)

----------------------
-- Plugin Keybinds
----------------------

-- Lazy
bind("n", "<leader>l", ":Lazy<CR>", opts)

-- Yanky
bind({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
bind({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
bind({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
bind({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
bind("n", "<c-n>", "<Plug>(YankyCycleForward)")
bind("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- vim-maximizer
bind("n", "<leader>sm", ":MaximizerToggle<CR>", opts) -- toggle split window maximization

-- nvim-tree
-- bind("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", opts) -- toggle file explorer
bind("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts) -- toggle file explorer

-- vim-tests
bind("n", "<leader>tt", ":TestFile<CR>", opts) -- run all tests in current file
bind("n", "<leader>tn", ":TestNearest<CR>", opts) -- run nearest test
bind("n", "<leader>tl", ":TestLast<CR>", opts) -- run last test
bind("n", "<leader>tf", ":TestSuite<CR>", opts) -- run test suite

-- telescope
bind("n", ";f", "<cmd>Telescope find_files<cr>", opts) -- find files within current working directory, respects .gitignore
bind("n", "<leader>fzf", function()
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, opts) -- find string in current buffer
bind("n", ";r", "<cmd>Telescope live_grep<cr>", opts) -- find string in current working directory as you type
bind("n", ";;", "<cmd>Telescope resume<cr>", opts)
bind("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts) -- find string under cursor in current working directory
bind("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- list open buffers in current neovim instance
bind("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- list available help tags
bind("n", "<leader>fm", "<cmd>Telescope marks<cr>", opts) -- list all marks
bind("n", "<leader>ft", "<cmd>Telescope tags<cr>", opts) -- list all tags
bind("n", "<leader>fr", "<cmd>Telescope registers<cr>", opts) -- list recently opened files
bind("n", ";d", "<cmd>Telescope diagnostics<cr>", opts) -- list all diagnostics
bind("n", "<leader>dC", "<cmd>Telescope command_history<cr>", opts) -- list all commands
bind("n", "<leader>dk", "<cmd>Telescope keymaps<cr>", opts) -- list all keymaps
bind("n", "<leader>dv", "<cmd>Telescope vim_options<cr>", opts) -- list all vim options
bind("n", "<leader>yw", "<cmd>Telescope yank_history<cr>", opts) -- list all yanks

-- ChatGPT
bind("n", "<C-g>c", "<cmd>ChatGPT<cr>", opts) -- open chatgpt window
bind("n", "<C-g>a", "<cmd>ChatGPTActAs<cr>", opts) -- send chatgpt message
bind("v", "<C-g>v", "<cmd>ChatGPTEditWithInstructions<cr>", opts) -- open chatgpt editwithinstructions window
bind({ "n", "v" }, "<C-g>ro", "<cmd>ChatGPTRun optimize_code_4<cr>", opts) -- optimize code
bind({ "n", "v" }, "<C-g>re", "<cmd>ChatGPTRun explain_code_4<cr>", opts) -- optimize code
bind({ "n", "v" }, "<C-g>rc", "<cmd>ChatGPTRun code_readability_analysis_4<cr>", opts) -- optimize code
bind({ "n", "v" }, "<C-g>rt", "<cmd>ChatGPTRun add_tests_4<cr>", opts) -- optimize code

-- Dadbod
bind("n", "<leader>du", "<cmd>DBUIToggle<cr>", opts) -- open dadbod ui
bind("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", opts)
bind("n", "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", opts)

-- telescope git commands (not on youtube nvim video, opts)
bind("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", opts) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
bind("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", opts) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
bind("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts) -- list git branches (use <cr> to checkout) ["gb" for git branch]
bind("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts) -- list current changes per file with diff preview ["gs" for git status]

-- Git - dv in fugitive
bind("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", opts)
bind("n", "gu", "<cmd>diffget //2<cr>", opts) -- get the upper version of a diff
bind("n", "gh", "<cmd>diffget //3<cr>", opts) -- get the lower version of a diff

-- Debugger
bind("n", "<leader>dt", ":DapUiToggle<CR>", opts) -- toggle dap ui
bind("n", "<leader>dc", ":DapContinue<CR>", opts) -- continue
bind("n", "<leader>db", ":DapToggleBreakpoint<CR>", opts) -- stop
bind("n", "<leader>ds", ":DapStepOver<CR>", opts) -- step over
bind("n", "<leader>di", ":DapStepInto<CR>", opts) -- step into
bind("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", opts) -- restart

-- restart lsp server (not on youtube nvim video, opts)
bind("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

-- lazygit
bind("n", "<leader>gg", ":LazyGit<CR>", opts)
bind("n", "<leader>gf", ":LazyGitFilter<CR>", opts)

-- My Binds
bind("n", "<leader>gt", ":lua Go_to_test_file()<CR>", opts)
bind("n", "<leader>ct", ":lua Create_test_file()<CR>", opts)
bind("n", "<f9>", ":!./gradlew build<CR>", opts)
