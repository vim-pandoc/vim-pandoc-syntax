" Vim syntax file
" Filetype: pandoc
" Language: CommonMark
" Maintainer: Caleb Maclennan <caleb@alerque.com>
" Maintainer: Felipe Morales <hel.sheep@gmail.com>

scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

if !exists('b:is_legacy')
  let b:is_legacy = exists('g:pandoc_legacy')
endif

if b:is_legacy
	syntax clear
else
	source pandoc_legacy.vim
endif

let b:current_syntax = b:is_legacy ? 'pandoc' : 'pandoc_legacy'
