package.loaded["rust"] = nil
local rust = require("libvim_pandoc_syntax")

local rustymarks = vim.api.nvim_create_namespace("rustymarks")

local call = vim.api.nvim_call_function
local addhl = vim.api.nvim_buf_add_highlight

local function byte2pos (byte)
	local line = call("byte2line", { byte })
	local col = byte - call("line2byte", { line })
	return line, col
end

local function highlight (buffer)
	addhl(buffer, rustymarks, "cmarkComment", 0, 3, 5)
	vim.api.nvim_buf_clear_namespace(buffer, rustymarks, 1, -1)
	events = rust.get_offsets(buffer)
		vim.api.nvim_err_writeln("num::: "..#events)
	for i, event in ipairs(events) do
		vim.api.nvim_err_writeln("should I "..event.group)
		local sline, scol = event2pos(event)
		local eline, ecol = event2pos(event)
		if eline > sline then
		else
			addhl(buffer, rustymarks, event.group, sline, scol, ecol)
			vim.api.nvim_err_writeln("did a "..event.group)
		end
		-- while sline < eline do
			-- sline = sline + 1
		-- end
	end
	return offsets
end

return {
	rust = rust,
	highlight = highlight,
}
