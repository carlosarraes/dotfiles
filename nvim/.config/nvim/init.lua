require("plugins-setup")
require("core.options")
require("core.keymaps")
require("plugins.comment")
-- require("plugins.nvim-tree")
require("plugins.lualine")
require("plugins.copilot")
require("plugins.colorizer")
require("plugins.yanky")
require("plugins.chatgpt")
require("plugins.noice")
require("plugins.telescope")
require("plugins.nvim-cmp")
require("plugins.lsp.mason")
require("plugins.indent-blankline")
require("plugins.lsp.lspsaga")
require("plugins.lsp.lspconfig")
require("plugins.lsp.null-ls")
require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.gitsigns")
require("plugins.git")
require("plugins.bufferline")
require("plugins.dap")
require("plugins.dapui")
require("plugins.dap-go")
require("plugins.goto-preview")
require("funcs.test-file")
require("core.colorscheme")
vim.cmd([[autocmd BufRead,BufNewFile *.gohtml setfiletype html]])
