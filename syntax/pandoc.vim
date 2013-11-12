" vi: fdm=marker 
" Vim syntax file
" Language: Pandoc (superset of Markdown)
" Maintainer: David Sanson <dsanson@gmail.com>
" Maintainer: Felipe Morales <hel.sheep@gmail.com>
" OriginalAuthor: Jeremy Schultz <taozhyn@gmail.com>
" Version: 5.0

" BASE: {{{1
syntax clear
setlocal conceallevel=2
syntax spell toplevel
"}}}

" Embeds: {{{1
" HTML: {{{2
" Set embedded HTML highlighting
syn include @HTML syntax/html.vim
syn match pandocHTML /<\a[^>]\+>/ contains=@HTML
" Support HTML multi line comments
syn region pandocHTMLComment start=/<!--/ end=/-->/
" }}}
" LaTeX: {{{2
" Set embedded LaTex (pandoc extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim
" Single Tex command
"syn match pandocLatex /\\\w\S/ contains=@LATEX
" Math Tex
syn match pandocLatex /\$.\{-}\$/ contains=@LATEX
" }}}}
" }}}

" Headings: {{{1

syn region pandocTitleBlock start=/\%^%/ end=/\n\n/ contains=pandocLinkArea,pandocNewLine
syn match pandocTitleBlockMark /%\ / contained containedin=pandocTitleBlock,pandocTitleBlockTitle conceal
syn match pandocTitleBlockTitle /\%^%.*\n/ contained containedin=pandocTitleBlock

"""""""""""""""""""""""""""""""""""""""""""""
" Header:
"
syn match pandocAtxHeader /^\s*#\{1,6}.*\n/ contains=pandocEmphasis,pandocStrong
syn match pandocSetexHeader /^.\+\n[=]\+$/ contains=pandocEmphasis,pandocStrong
syn match pandocSetexHeader /^.\+\n[-]\+$/ contains=pandocEmphasis,pandocStrong
syn match AtxStart /#/ contained containedin=pandocAtxHeader conceal cchar=§

"}}}

" Blockquotes: {{{1
"
syn match pandocBlockQuote /^>.*\n\(.*\n\@<!\n\)*/ contains=@Spell,pandocEmphasis,pandocStrong,pandocPCite,pandocSuperscript,pandocSubscript,pandocStrikeout skipnl

" }}}

" Code Blocks: {{{1
"
syn region pandocCodeBlock   start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{4,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/
"}}}

" Definitions: {{{1
"
syn match pandocDefinitionBlock /^.*\n\(^\s*\n\)*\s\{0,2}[:~]\(\s\{1,3}\|\t\).*\n\(\(^\s\{4,}\|^\t\).*\n\)*/ skipnl contains=pandocDefinitionBlockTerm,pandocDefinitionBlockMark,pandocLinkArea,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,@Spell
syn match pandocDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained containedin=pandocDefinitionBlock contains=pandocNoFormatted,pandocEmphasis
syn match pandocDefinitionBlockMark /^\s*[:~]/ contained containedin=pandocDefinitionBlock
" }}}

" Links: {{{1
syn region pandocLinkArea start=/\[.\{-}\]\@<=\(:\|(\|\[\)/ end=/\(\(\]\|)\)\|\(^\s*\n\|\%^\)\)/ contains=pandocLinkText,pandocLinkURL,pandocLinkTitle,pandocAutomaticLink,pandocPCite keepend
syn region pandocLinkText matchgroup=Operator start=/\[/ end=/\]/ contained contains=@Spell containedin=pandocLinkArea extend 
syn region pandocLinkTextRef matchgroup=Operator start=/(/ end=/)/ contained containedin=pandocLinkArea transparent 
syn match pandocLinkTextText /\S*/ contained containedin=pandocLinkTextRef 
syn match pandocLinkTitle /".\{-}"/ contained containedin=pandocLinkTextRef contains=@Spell

" Automatic_links:
syn match pandocAutomaticLink /<\(https\{0,1}.\{-}\|.\{-}@.\{-}\..\{-}\)>/
" }}}

" Citations: {{{1
" parenthetical citations
syn match pandocPCite /\[-\{0,1}@.\{-}\]/ contains=pandocEmphasis,pandocStrong,pandocLatex,@Spell
" in-text citations without location
syn match pandocPCite /@\w*/
" in-text citations with location
syn match pandocPCite /@\w*\s\[.\{-}\]/
syn match pandocPCiteAnchor /@/ contained containedin=pandocPCite
" }}}

" Text Styles: {{{1

"" Emphasis: {{{2
"
syn region pandocEmphasis matchgroup=Operator start=/\(\_^\|\s\)\@<=\*\S\@=/ end=/\S\@<=\*\(\s\|\_$\)\@=/ contains=@Spell concealends
syn region pandocEmphasis matchgroup=Operator start=/\(\_^\|\s\)\@<=_\S\@=/ end=/\S\@<=_\(\s\|\_$\)\@=/ contains=@Spell concealends
" }}}
" Strong: {{{2
"
syn region pandocStrong matchgroup=Operator start=/\*\*/ end=/\*\*/ contains=@Spell concealends 
syn region pandocStrong matchgroup=Operator start=/__/ end=/__/ contains=@Spell concealends
"}}}
" Inline Code: {{{2

" Using single back ticks
syn region pandocNoFormatted matchgroup=Operator start=/`/ end=/`/ concealends
" Using double back ticks
syn region pandocNoFormatted matchgroup=Operator start=/``/ end=/``/ concealends
"}}}
" Subscripts: {{{2 
syn region pandocSubscript matchgroup=Operator start=/\~/ end=/\~/ contains=@Spell concealends cchar=ₙ
"}}}
" Superscript: {{{2
syn region pandocSuperscript matchgroup=Operator start=/\^/ end=/\^/ contains=@Spell concealends cchar=ⁿ
"}}}
" Strikeout: {{{2
syn region pandocStrikeout matchgroup=Operator start=/\~\~/ end=/\~\~/  contains=@Spell concealends cchar=!
" }}}
" }}}

" Delimited Code Blocks: {{{1
" this is here because we can override strikeouts and subscripts
syn region pandocDelimitedCodeBlock start=/^\z(\~\{3,}\~*\)/ end=/\z1\~*/ skipnl contains=pandocDelimitedCodeBlockStart keepend
syn region pandocDelimitedCodeBlock start=/^\z(`\{3,}`*\)/ end=/\z1`*/ skipnl contains=pandocDelimitedCodeBlockStart keepend
syn match pandocDelimitedCodeBlockStart /\(\_^\n\_^\)\@<=\~\{3,}\~*/ contained nextgroup=pandocDelimitedCodeBlockLanguage conceal cchar=λ
syn match pandocDelimitedCodeBlockStart /\(\_^\n\_^\)\@<=`\{3,}`*/ contained nextgroup=pandocDelimitedCodeBlockLanguage conceal cchar=λ
syn match pandocDelimitedCodeBlockLanguage /\(\s\?\)\@<=.\+\(\_$\)\@=/ contained
syn match pandocDelimitedCodeBlockEnd /`\{3,}`*\(\_$\n\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock conceal
syn match pandocDelimitedCodeBlockEnd /\~\{3,}\~*\(\_$\n\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock conceal
syn match pandocCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pandocCodePre /<code>.\{-}<\/code>/ skipnl
" }}}

" Footnotes: {{{1
" we put these here not to interfere with superscripts.
"
syn match pandocFootnoteID /\[\^[^\]]\+\]/ nextgroup=pandocFootnoteDef
"   Inline footnotes
syn region pandocFootnoteDef start=/\^\[/ end=/\]/ contains=pandocLinkArea,pandocLatex,pandocPCite,@Spell skipnl keepend 
syn match pandocFootnoteDefHead /\^\[/ contained containedin=pandocFootnoteDef conceal cchar=†
syn match pandocFootnoteDefTail /\]/ contained containedin=pandocFootnoteDef conceal

" regular footnotes
syn region pandocFootnoteBlock start=/\[\^.\{-}\]:\s*\n*/ end=/^\n^\s\@!/ contains=pandocLinkArea,pandocLatex,pandocPCite,pandocStrong,pandocEmphasis,pandocNoFormatted,pandocSuperscript,pandocSubscript,pandocStrikeout,@Spell skipnl
syn match pandocFootnoteBlockSeparator /:/ contained containedin=pandocFootnoteBlock
syn match pandocFootnoteID /\[\^.\{-}\]/ contained containedin=pandocFootnoteBlock
syn match pandocFootnoteIDHead /\[\^/ contained containedin=pandocFootnoteID conceal cchar=†
syn match pandocFootnoteIDTail /\]/ contained containedin=pandocFootnoteID conceal
" }}}

" List Items: {{{1
"
" Unordered lists 
syn match pandocUListItem /^\s*[*+-]\s\+/he=e-1
syn match pandocUListItemBullet /[*+-]/ contained containedin=pandocUListItem conceal cchar=•
" Ordered lists
" TODO: support roman numerals
syn match pandocListItem /^\s*\(\((*\d\+[.)]\+\)\|\((*\l[.)]\+\)\)\s\+/he=e-1
syn match pandocListItem /^\s*(*\u[.)]\+\s\{2,}/he=e-1
syn match pandocListItem /^\s*(*[#][.)]\+\s\{1,}/he=e-1
syn match pandocListItem /^\s*(*@.\{-}[.)]\+\s\{1,}/he=e-1
" }}}

" Special: {{{1
"
" Horizontal Rules: {{{2
"
" 3 or more * on a line
syn match pandocHRule /\s\{0,3}\(-\s*\)\{3,}\n/ conceal cchar=⁂
" 3 or more - on a line
syn match pandocHRule /\s\{0,3}\(\*\s*\)\{3,}\n/ conceal cchar=⁂
"}}}
" New lines: {{{2
syn match pandocNewLine /\(  \|\\\)$/ conceal cchar=↵
"}}}
" }}}

" Styling: {{{1
hi link pandocTitleBlockTitle Directory
hi link pandocAtxHeader Title
hi link pandocSetexHeader Title

hi link pandocBlockQuote Comment
hi link pandocCodeBlock String
hi link pandocDelimitedCodeBlock String
hi link pandocDelimitedCodeBlockLanguage Comment
hi link pandocCodePre String
hi link pandocUListItem Operator
hi link pandocListItem Operator
hi link pandocUListItemBullet Operator

hi link pandocLinkArea Type
hi link pandocLinkText Label
hi link pandocLinkTextText Underlined
hi link pandocLinkTitle Identifier
hi link pandocAutomaticLink Underlined

hi link pandocDefinitionBlockTerm Identifier
hi link pandocDefinitionBlockMark Operator

hi link pandocFootnoteID Label
hi link pandocFootnoteIDHead Type
hi link pandocFootnoteIDTail Type
hi link pandocFootnoteDef Comment
hi link pandocFootnoteDefHead Type
hi link pandocFootnoteDefTail Type
hi link pandocFootnoteBlock Comment
hi link pandocFootnoteBlockSeparator Operator

hi link pandocPCite Identifier
hi link pandocPCiteAnchor Operator

hi pandocEmphasis gui=italic cterm=italic
hi pandocStrong gui=bold cterm=bold
hi link pandocNoFormatted String
hi pandocSubscript gui=underline cterm=underline
hi pandocSuperscript gui=underline cterm=underline
hi pandocStrikeout gui=underline cterm=underline

hi link pandocNewLine Error
"}}}

let b:current_syntax = "pandoc"
