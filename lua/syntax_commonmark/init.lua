package.loaded["rust"] = nil -- Force module reload during dev
local rust = require("libvim_pandoc_syntax")

local rustymarks = vim.api.nvim_create_namespace("rustymarks")

local call = vim.api.nvim_call_function
local addhl = vim.api.nvim_buf_add_highlight

local function byte2pos (buffer, byte)
	local line = call("byte2line", { byte }) - 1
	local col = byte - vim.api.nvim_buf_get_offset(buffer, line)
	-- local col = byte - call("line2byte", { line })
	return line, col
end

local function highlight (buffer, contents)
	vim.api.nvim_buf_clear_namespace(buffer, rustymarks, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, true)
	local contents = table.concat(lines)
	local events = rust.get_offsets(contents)
	for i, event in ipairs(events) do
		local sline, scol = byte2pos(buffer, event.first)
		local eline, ecol = byte2pos(buffer, event.last)
		if eline > sline then
		else
			addhl(buffer, rustymarks, event.group, sline, scol - 1, ecol)
		end
	end
end

return {
	rust = rust,
	highlight = highlight,
}
