local opt = vim.opt
local cmd = vim.cmd

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tab & indents
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Cursor
opt.cursorline = true

-- Appearence
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- QoL
opt.iskeyword:append("-")
cmd("set noswapfile")
