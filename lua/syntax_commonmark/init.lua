local rust = require("libvim_pandoc_syntax")

local rustymarks = vim.api.nvim_create_namespace("rustymarks")

local call = vim.api.nvim_call_function
local addhl = vim.api.nvim_buf_add_highlight

local function event2pos (event)
	local line = call("byte2line", { event.first })
	local col = event.first - call("line2byte", { line })
	return line, col
end

local function highlight (buffer)
	events = rust.get_event_offsets(buffer)
	vim.api.nvim_buf_clear_namespace(buffer, rustymarks, 1, -1)
	addhl(buffer, rustymarks, "cmarkComment", 1, 4, 99)
	for i, event in ipairs(events) do
		local line, col = event2pos(event)
		addhl(buffer, rustymarks, event.group, line, col, 99)
	end
	return offsets
end

return {
	rust = rust,
	highlight = highlight,
}
