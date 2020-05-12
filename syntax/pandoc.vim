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
    runtime syntax/pandoc_commonmark.vim
else
    runtime syntax/pandoc_legacy.vim
endif

let b:current_syntax = 'pandoc'
