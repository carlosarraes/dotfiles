function Go_to_test_file()
	local filetype = vim.bo.filetype
	local conventions = {
		["java"] = "%sTest.java",
		["typescript"] = "%s.test.ts",
		["javascript"] = "%s.test.js",
		["go"] = "%s_test.go",
	}

	local convention = conventions[filetype]
	if not convention then
		print("Unsupported file type: " .. filetype)
		return
	end

	local current_file = vim.fn.expand("%:t")
	local test_filename = string.format(convention, string.gsub(current_file, "%..*$", ""))

	local cmd = string.format("fd -a %s", vim.fn.shellescape(test_filename))
	local result = vim.fn.systemlist(cmd)

	if #result > 0 then
		vim.cmd(string.format("e %s", result[1]))
	else
		print("No test file found")
	end
end
