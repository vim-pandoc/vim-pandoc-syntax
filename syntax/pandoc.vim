" Vim syntax file
"
" Language: Pandoc (superset of Markdown)
" Maintainer: Felipe Morales <hel.sheep@gmail.com>
" Maintainer: Caleb Maclennan <caleb@alerque.com>
" Contributor: David Sanson <dsanson@gmail.com>
" Contributor: Jorge Israel Peña <jorge.israel.p@gmail.com>
" OriginalAuthor: Jeremy Schultz <taozhyn@gmail.com>

scriptencoding utf-8

if exists('b:current_syntax')
    finish
endif

if exists('g:pandoc#syntax#flavor#commonmark') || exists('b:pandoc#syntax#flavor#commonmark')
	lua package.loaded["syntax_commonmark"] = nil -- Force module reload during dev
	lua vcs = require("syntax_commonmark")
	lua vcs.highlight(vim.api.nvim_get_current_buf())
else
    runtime syntax/pandoc_legacy.vim
endif

hi link cmarkHeading1 Title
hi link cmarkHeading2 Title
hi link cmarkHeading3 Title
hi link cmarkHeading4 Title
hi link cmarkHeading5 Title
hi link cmarkHeading6 Title
hi link cmarkParagraph Integer
hi link cmarkBlockquote Integer
hi link cmarkComment Comment
hi cmarkEmphasis gui=italic cterm=italic
hi cmarkStrong gui=bold cterm=bold

let b:current_syntax = 'pandoc'
