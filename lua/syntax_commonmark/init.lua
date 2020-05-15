local rust = require("libvim_pandoc_syntax")

local get_buf = vim.api.nvim_get_current_buf

local function foobar ()
	offsets = rust.get_offsets(get_buf())
	for i, event in ipairs(offsets) do
		print(event.tag, event.start)
	end
	return offsets
end

return {
	rust = rust,
	foobar = foobar,
}
