" Vim syntax file
" Filetype: pandoc
" Language: pandoc markdown, simplified
" Maintainer: Felipe Morales <hel.sheep@gmail.com>

scriptencoding utf-8

syntax clear

syn spell toplevel

" A pandoc markdown document is based on blocks.

syn region pdcPar start=/^\s*[[:print:]]/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend contains=@Spell

" YAML headers
unlet! b:current_syntax
syn include @YAML syntax/yaml.vim
syn region pdcYAML matchgroup=Delimiter start=/^\s*---\(\n\s*[[:print:]]\)\@=/ end=/---\n\s*\n/ keepend contains=@YAML

" LaTeX environments
unlet! b:current_syntax
syn include @LATEX syntax/tex.vim
syn region pdcLaTeXEnv start=/\\begin{\z(.\{-}\)}/ end=/\\end{\z1}/ keepend contains=@LATEX
syn region pdcLaTeXDisplayMath start=/\z(\\\@<!\$\{1,2}\)/ end=/\z1/ keepend contains=@LATEX containedin=pdcPar,pdcBlockQuote,pdcOList,pdcUList,pdcFootnote,pdcFootnotePar
"syn match pdcLaTeXCmd /\\\S\{1,}/ contains=@LATEX keepend containedin=pdcPar
syn match pdcLaTeXCmd /\\[[:alpha:]]\+\(\({.\{-}}\)\=\(\[.\{-}\]\)\=\)*/ contains=@LATEX keepend containedin=pdcPar,pdcBlockQuote,pdcOList,pdcUList,pdcFootnote,pdcFootnotePar

" Code Blocks
syn region pdcCodeblock start=/^\(\s\{4,}\|\t\{1,}\)/ end=/[[:print:]]\zs\n\ze\s*\n/
syn region pdcDelimitedCodeBlock start=/^\z([`~]\{3}\)/ end=/\z1\n\s*\n/
syn region pdcLaTeXCodeBlock matchgroup=Delimiter start=/^```{=latex}/ end=/```\n\s*\n/ keepend contains=@LATEX

" Blockquotes
syn region pdcBlockQuote start=/^\s\{,3}>\s\?/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend

" Lists
syn region pdcUList start=/^>\=\s*[*=-]\ze\s*[[:print:]]$/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend
syn region pdcOList start=/^(\?\(\d\+\|\l\|\#\|@.\{-}\|x\=l\=\(i\{,3}[vx]\=\)\{,3}c\{,3}\)[.)]/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend

" Fenced DIVS
syn region pdcFencedDiv matchgroup=Delimiter start=/^:::.*$/ end=/:::\n\s*\n/ keepend contains=@LATEX,pdcPar contains=@Spell

" Atx headers
syn match pdcAtxHeader /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{1,6}.*\n/ keepend contained containedin=pdcPar contains=@Spell

" Footnotes
syn region pdcFootnote start=/^\[\^/ end=/[[:print:]]\zs\n\ze\s*\n/ keepend contains=@Spell
syn region pdcInlineFootnote matchgroup=Delimiter start=/\^\[/ skip=/\[[[:print:]]*\]/ end=/\]/ keepend contained containedin=pdcPar,pdcUList,pdcOList
syn region pdcFootnoteRef matchgroup=Delimiter start=/\[\^/ end=/\]/ contained containedin=pdcPar,pdcBlockQuote,pdcUList,pdcOList,pdcFootnote nextgroup=pdcFootnotePar
syn region pdcFootnotePar start=/^\t[[:print:]]/ end=/[[:print:]]\(\n\s*\n\)\@=/ keepend contains=@Spell nextgroup=pdcFootnotePar

" References.
syn match pdcBibRef /@[[:alnum:]:_-]\{1,}\(\[[[:print:]]\{-}\]\)\?/ containedin=pdcPar,pdcUList,pdcOList,pdcBlockQuote
syn match pdcBibRefIF /@[[:alnum:]:_-]\{1,}\(\[[[:print:]]\{-}\]\)\?/ containedin=pdcInlineFootnote,pdcFootnote,pdcFootnotePar

let b:current_syntax = 'pandoc'

hi def link pdcCodeblock Special
hi def link pdcDelimitedCodeBlock pdcCodeblock
hi def link pdcAtxHeader Directory
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
