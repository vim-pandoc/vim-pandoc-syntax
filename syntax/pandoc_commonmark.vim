" Vim syntax file
"
" Language: CommonMark
" Maintainer: Caleb Maclennan <caleb@alerque.com>

scriptencoding utf-8

syntax clear

lua << EOC
vps = require("libvim_pandoc_syntax")
offsets = vps.get_offsets(vim.api.nvim_get_current_buf())
for i, event in ipairs(offsets) do
	print(event.tag, event.start)
end
EOC
