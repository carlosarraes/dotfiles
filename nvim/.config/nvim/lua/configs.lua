local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true
opt.numberwidth = 1 -- Width of the line number column

-- Tab & indents
opt.tabstop = 2
opt.softtabstop = 2 -- Number of spaces for a tab when editing
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true
opt.showbreak = "↳  "
-- opt.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Characters to show for tabs, spaces, and end of line
-- opt.list = true -- Show whitespace characters
opt.linebreak = true

-- Wrapping
opt.wrap = false -- Disable line wrapping

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Cursor
opt.cursorline = true
-- opt.guicursor = "i:block" -- Use block cursor in insert mode
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor

-- Appearence
opt.signcolumn = "yes"
opt.termguicolors = true -- Enable true colors
-- opt.colorcolumn = "80" -- Highlight column 80

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- QoL
opt.iskeyword:append("-")
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("config") .. "~/.config/undodir"
opt.undofile = true
opt.inccommand = "nosplit" -- Shows the effects of a command incrementally in the buffer
opt.completeopt = { "menuone", "popup", "noinsert" } -- Options for completion menu
opt.winborder = "rounded" -- Use rounded borders for windows
opt.laststatus = 0 -- Only show status line in last window
opt.cmdheight = 1
-- vim.opt.statusline = '%F'

vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

