local bind = vim.keymap.set
local opts = { noremap = true, silent = true }

-- General
bind("n", "<C-s>", ":w<CR>", opts)
bind("n", "<leader>nh", ":nohl<CR>", opts)

-- Window management
bind("n", "<leader>sv", "<C-w>v", opts)     -- split window vertically
bind("n", "<leader>sh", "<C-w>s", opts)     -- split window horizontally
bind("n", "<leader>se", "<C-w>=", opts)     -- make split windows equal width & height
bind("n", "<leader>sx", ":close<CR>", opts) -- close current split window

-- Buffer management
bind("n", "<tab>", ":bnext<CR>", opts)   -- next buffer
bind("n", "<s-tab>", ":bprev<CR>", opts) -- previous buffer

-- Tabs
bind("n", "<leader>to", ":tabnew<CR>", opts)   -- open new tab
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
bind("i", "<C-q>", "<C-o>zz", opts)
bind("n", "<leader>p", "cw<C-r>0<ESC>b", opts)
bind("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts) -- replace word under cursor
bind("v", "<leader>/", "<esc>/\\%V", opts)                                           -- search within selection
bind("n", "<Return>", "o<ESC>k", opts)
bind("n", "<leader>5", ":UndotreeToggle<CR>", opts)

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

-- Dadbod
bind("n", "<leader>du", "<cmd>DBUIToggle<cr>", opts) -- open dadbod ui
bind("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", opts)
bind("n", "<leader>dq", "<cmd>DBUILastQueryInfo<cr>", opts)

-- FzfLua
bind("n", ";f", "<cmd>lua require('fzf-lua').files()<cr>", opts)
bind("n", ";r", "<cmd>lua require('fzf-lua').live_grep_glob()<cr>", opts)
bind("n", ";d", "<cmd>lua require('fzf-lua').diagnostics_workspace()<cr>", opts)
-- bind("n", ";r", "<cmd>lua require('fzf-lua').live_grep_glob({ filter = \"rg -v '*tests/'\" })<cr>", opts)
bind("n", ";;", "<cmd>lua require('fzf-lua').resume()<cr>", opts)

-- CChat
bind("n", ";ct", ":CopilotChatToggle<cr>", opts)
bind({ "n", "v" }, ";cc", ":CopilotChat<cr>", opts)
bind({ "n", "v" }, ";co", ":CopilotChatOptimize<cr>", opts)
bind({ "n", "v" }, ";cp", ":CopilotChatTests<cr>", opts)
bind({ "n", "v" }, ";ce", ":CopilotChatExplain<cr>", opts)
bind({ "n", "v" }, ";cr", ":CopilotChatReview<cr>", opts)
bind({ "n", "v" }, ";cf", ":CopilotChatFix<cr>", opts)
bind({ "n", "v" }, ";cd", ":CopilotChatFixDiagnostic<cr>", opts)

-- Yanky
bind({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts)
bind({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts)
bind({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts)
bind({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts)
bind("n", "<c-n>", "<Plug>(YankyCycleForward)", opts)
bind("n", "<c-p>", "<Plug>(YankyCycleBackward)", opts)
bind("n", ";yw", ":YankyRingHistory<CR>", opts)

-- Neotree
bind("n", "<leader>e", ":Neotree toggle<CR>", opts)

local termtoggle = require("local.term")
vim.keymap.set('n', '<C-t>', termtoggle.toggleterm, { desc = 'toggle terminal' })
vim.keymap.set('t', '<C-t>', termtoggle.toggleterm, { buffer = termtoggle.buf, desc = 'toggle terminal' })
