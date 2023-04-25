local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tab & indents
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Wrapping
opt.wrap = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

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
opt.scrolloff = 8
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("config") .. "/undodir"
opt.undofile = true
