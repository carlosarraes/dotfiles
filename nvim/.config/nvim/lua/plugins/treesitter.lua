local ts = require("nvim-treesitter")

ts.setup()

local wanted = {
	"bash",
	"c",
	"css",
	"go",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"scss",
	"toml",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

-- `main` builds every parser with the tree-sitter CLI; without it each install
-- fails separately, so bail out once instead of erroring per language.
local has_cli = vim.fn.executable("tree-sitter") == 1

-- `main` dropped `ensure_installed`; install() is async and would refetch on every
-- startup, so diff against what is already on disk first.
local installed = ts.get_installed("parsers")
local missing = vim.tbl_filter(function(lang)
	return not vim.tbl_contains(installed, lang)
end, wanted)
if #missing > 0 then
	if has_cli then
		ts.install(missing)
	else
		vim.notify(
			("nvim-treesitter: %d parser(s) missing and `tree-sitter` CLI not found (pacman -S tree-sitter-cli)"):format(
				#missing
			),
			vim.log.levels.WARN
		)
	end
end

-- `main` has no `highlight` module either: highlighting is started per-buffer.
local available = ts.get_available()

vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local lang = vim.treesitter.language.get_lang(ev.match)
		if not lang then
			return
		end

		if vim.treesitter.language.add(lang) then
			vim.treesitter.start(ev.buf, lang)
		elseif has_cli and vim.tbl_contains(available, lang) then
			-- stand-in for the old `auto_install`
			ts.install({ lang }):await(function(err)
				if not err and vim.api.nvim_buf_is_valid(ev.buf) then
					vim.schedule(function()
						pcall(vim.treesitter.start, ev.buf, lang)
					end)
				end
			end)
		end
	end,
})
