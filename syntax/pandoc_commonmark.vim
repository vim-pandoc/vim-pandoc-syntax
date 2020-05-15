" Vim syntax file
"
" Language: CommonMark
" Maintainer: Caleb Maclennan <caleb@alerque.com>

scriptencoding utf-8

syntax clear

lua s = require("libvim_pandoc_syntax")
lua foo = s.render_html("# foo")
lua print(foo)

lua << EOC
s = require("libvim_pandoc_syntax")
bar = s.render_html("*bar*")
print(bar)
EOC
