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

if exists('g:pandoc#syntax#flavor')
    let s:flavor = g:pandoc#syntax#flavor
endif
if exists('b:pandoc#syntax#flavor')
    let s:flavor = b:pandoc#syntax#flavor
endif

let s:cmd = 'runtime syntax/pandoc_'.s:flavor.'.vim'

exe s:cmd

let b:current_syntax = 'pandoc'
