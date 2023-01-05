local api = vim.api
local fn = vim.fn

local attach_to_buffer = function(bufnr, pattern, command)
	api.nvim_create_autocmd("BufWritePost", {
		group = api.nvim_create_augroup("autosave", { clear = true }),
		pattern = pattern,
		callback = function()
			local append_data = function(_, data)
				if data then
					api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
				end
			end

			api.nvim_buf_set_lines(bufnr, 0, -1, false, { "output:" })
			fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = append_data,
				on_stderr = append_data,
			})
		end,
	})
end

api.nvim_create_user_command("Autorun", function()
	local bufnr = tonumber(vim.fn.input("Bufnr: "))
	local pattern = vim.fn.input("Pattern: ")
	local command = vim.split(vim.fn.input("Command: "), " ")
	attach_to_buffer(bufnr, pattern, command)
end, {})
