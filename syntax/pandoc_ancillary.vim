" Vim syntax file
" Filetype: pandoc
" Language: pandoc markdown, simplified
" Maintainer: Felipe Morales <hel.sheep@gmail.com>

scriptencoding utf-8

runtime syntax/commonmark.vim

syn spell toplevel

" A pandoc markdown document is based on blocks.

" YAML headers
unlet! b:current_syntax
syn include @YAML syntax/yaml.vim
syn region pdcYAML matchgroup=Delimiter start=/^\s*---\(\n\s*[[:print:]]\)\@=/ end=/---\n\s*\n/ keepend contains=@YAML

" LaTeX environments
unlet! b:current_syntax
syn include @LATEX syntax/tex.vim
syn region pdcLaTeXEnv start=/\\begin{\z(.\{-}\)}/ end=/\\end{\z1}/ keepend contains=@LATEX
syn region pdcLaTeXDisplayMath start=/\z(\\\@<!\$\{1,2}\)/ end=/\z1/ keepend contains=@LATEX
syn match pdcLaTeXCmd /\\[[:alpha:]]\+\(\({.\{-}}\)\=\(\[.\{-}\]\)\=\)*/ contains=@LATEX keepend

" Definitions
syn region pdcDefinition matchgroup=Label start=/^[[:print:]]\{1,}\ze\s*\n\~/ end=/[[:print:]]\zs\(\n\s*\n\)\@=/ keepend contains=@Spell

" Footnotes
syn region pdcFootnote start=/^\[\^/ end=/[[:print:]]\zs\n\ze\s*\n/ keepend contains=@Spell
syn region pdcInlineFootnote matchgroup=Delimiter start=/\^\[/ skip=/\[[[:print:]]*\]/ end=/\]/ keepend
syn region pdcFootnoteRef matchgroup=Delimiter start=/\[\^/ end=/\]/ nextgroup=pdcFootnotePar
syn region pdcFootnotePar start=/^\t[[:print:]]/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend contains=@Spell nextgroup=pdcFootnotePar

" References.
syn match pdcBibRef /@[[:alnum:]:_-]\{1,}\(\[[[:print:]]\{-}\]\)\?/
syn match pdcBibRefIF /@[[:alnum:]:_-]\{1,}\(\[[[:print:]]\{-}\]\)\?/ containedin=pdcInlineFootnote,pdcFootnote,pdcFootnotePar

" Highlighting

hi def link pdcFootnote Comment
hi def link pdcInlineFootnote pdcFootnote
hi def link pdcFootnotePar pdcFootnote
hi def link pdcFootnoteBlockQuote pdcFootnote
hi def pdcBodyLink ctermfg=fg guifg=fg guisp=SteelBlue4 gui=underline cterm=underline
let fn_fg = pandoc#syntax#color#Instrospect('pdcInlineFootnote').guifg
exe 'hi def pdcFootLink guifg='.fn_fg.' guisp=SteelBlue4 gui=underline cterm=underline'
hi def link pdcBibRef pdcBodyLink
hi def link pdcFootnoteRef pdcFootLink
hi def link pdcBibRefIF pdcFootLink
hi def link pdcYAML Normal
hi def link pdcLaTeXEnv Normal
hi def link pdcLaTeXCmd Normal
hi def link pdcLaTeXDisplayMath Normal
