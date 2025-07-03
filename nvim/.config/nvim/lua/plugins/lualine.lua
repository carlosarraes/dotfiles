return {
	"nvim-lualine/lualine.nvim",
	config = function()
		if vim.g.vscode then
			return
		end

		local navic = require("nvim-navic")
		local token_counter = require("local.token_counter")

		require("lualine").setup({
			options = {
				theme = "tokyonight",
				icons_enabled = true,
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_x = {
					{
						function()
							return token_counter.get_status()
						end,
						cond = function()
							local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
							return #content > 0 and table.concat(content, "") ~= ""
						end,
						color = { fg = "#7aa2f7" },
					},
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_c = {
					{
						function()
							return navic.get_location()
						end,
						cond = function()
							return navic.is_available()
						end,
					},
				},
			},
		})

		-- Set up token counting on buffer changes with debouncing
		local timer = vim.loop.new_timer()
		local function schedule_token_count()
			timer:stop()
			timer:start(1000, 0, vim.schedule_wrap(function()
				token_counter.count_tokens(function()
					-- Force lualine refresh
					vim.cmd('redrawstatus')
				end)
			end))
		end

		-- Create autocommands for token counting
		local group = vim.api.nvim_create_augroup("TokenCounter", { clear = true })
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufEnter" }, {
			group = group,
			callback = schedule_token_count,
		})
	end,
}
