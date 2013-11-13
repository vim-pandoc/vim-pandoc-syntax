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
syn region pandocCodeBlockInsideIndent   start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{8,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/ contained
"}}}

" Links: {{{1
"
" Inline: {{{2
syn region pandocLinkArea start=/!\{,1}\[.\{-}\](/ end=/)/ keepend
syn match pandocLinkText /\[\zs.*\ze\]/ contained containedin=pandocLinkArea
syn match pandocLinkData /(\zs.*\ze)/ contained containedin=pandocLinkArea
syn match pandocLinkTip /\s*".\{-}"/ contained containedin=pandocLinkData contains=@Spell
" }}}
" Reference: {{{2
syn region pandocReferenceArea start=/!\{,1}\[.\{-}\]\s\{,1}\[/ end=/\]/ keepend
syn match pandocReferenceText /\[\zs.\{-}\ze\]\s\{,1}\[/ contained containedin=pandocReferenceArea
syn match pandocReferenceLabel /\]\s\{,1}\[\zs.\{-}\ze\]/ contained containedin=pandocReferenceArea
" }}}
" Image: {{{2
syn match pandocImageIcon /!/ contained containedin=pandocLinkArea,pandocReferenceArea conceal cchar=▨
" }}}
" Definitions: {{{2
syn region pandocReferenceDefinition start=/\[.\{-}\]:/ end=/\(\n\s*".*"$\|$\)/ keepend
syn match pandocReferenceDefinitionLabel /\[\zs.\{-}\ze\]:/ contained containedin=pandocReferenceDefinition
syn match pandocReferenceDefinitionAddress /:\s*\zs.*/ contained containedin=pandocReferenceDefinition
syn match pandocReferenceDefinitionTip /\s*".\{-}"/ contained containedin=pandocReferenceDefinition,pandocReferenceDefinitionAddress contains=@Spell
"}}}
" Automatic_links: {{{2
syn match pandocAutomaticLink /<\(https\{0,1}.\{-}\|.\{-}@.\{-}\..\{-}\)>/
" }}}
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

" Emphasis: {{{2
"
syn region pandocEmphasis matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=\*\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell concealends
syn region pandocEmphasis matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=_\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell concealends
" }}}
" Strong: {{{2
"
syn region pandocStrong matchgroup=Operator start=/\*\*/ end=/\*\*/ contains=@Spell concealends
syn region pandocStrong matchgroup=Operator start=/__/ end=/__/ contains=@Spell concealends
"}}}
" Strong Emphasis: {{{2
"
syn region pandocStrongEmphasis matchgroup=Operator start=/\*\*\*/ end=/\*\*\*/ contains=@Spell concealends
syn region pandocStrongEmphasis matchgroup=Operator start=/___/ end=/___/ contains=@Spell concealends
" }}}
" Mixed: {{{2
syn region pandocStrongInEmphasis matchgroup=Operator start=/\*\*/ end=/\*\*/ contained containedin=pandocEmphasis contains=@Spell concealends
syn region pandocStrongInEmphasis matchgroup=Operator start=/__/ end=/__/ contained containedin=pandocEmphasis contains=@Spell concealends
syn region pandocEmphasisInStrong matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=\*\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell concealends
syn region pandocEmphasisInStrong matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=_\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell concealends

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
syn region pandocDelimitedCodeBlock start=/^\z(\(\s\{4,}\)\=\~\{3,}\~*\)/ end=/\z1\~*/ skipnl contains=pandocDelimitedCodeBlockStart keepend
syn region pandocDelimitedCodeBlock start=/^\z(\(\s\{4,}\)\=`\{3,}`*\)/ end=/\z1`*/ skipnl contains=pandocDelimitedCodeBlockStart keepend
syn match pandocDelimitedCodeBlockStart /\(\_^\n\_^\(\s\{4,}\)\=\)\@<=\(\~\{3,}\~*\|`\{3,}`*\)/ contained nextgroup=pandocDelimitedCodeBlockLanguage conceal cchar=λ
syn match pandocDelimitedCodeBlockLanguage /\(\s\?\)\@<=.\+\(\_$\)\@=/ contained
syn match pandocDelimitedCodeBlockEnd /\(`\{3,}`*\|\~\{3,}\~*\)\(\_$\n\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock conceal
syn match pandocCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pandocCodePre /<code>.\{-}<\/code>/ skipnl
" }}}

" Abbreviations: {{{1
syn region pandocAbbreviationDefinition start=/^\*\[.\{-}\]:\s*/ end="$" contains=pandocNoFormatted,@Spell
syn match pandocAbbreviationSeparator /:/ contained containedin=pandocAbbreviationDefinition conceal cchar=→
syn match pandocAbbreviation /\*\[.\{-}\]/ contained containedin=pandocAbbreviationDefinition
syn match pandocAbbreviationHead /\*\[/ contained containedin=pandocAbbreviation conceal
syn match pandocAbbreviationTail /\]/ contained containedin=pandocAbbreviation conceal
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

" Definitions: {{{1
"
syn region pandocDefinitionBlock start=/^.*\n\(^\s*\n\)*\s\{0,2}[:~]/ skip=/\n\n\zs\s/ end=/\n\n/ contains=pandocDefinitionBlockMark,pandocDefinitionBlockTerm,pandocCodeBlockInsideIndent,pandocEmphasis,pandocStrong,pandocStrongEmphasis,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocFootnoteID,pandocLinkArea,pandocAutomaticLink keepend 
syn match pandocDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained contains=pandocNoFormatted,pandocEmphasis,pandocStrong
syn match pandocDefinitionBlockMark /^\s*[:~]/ contained conceal cchar= 
" }}}

" List Items: {{{1
"
" Unordered lists 
syn match pandocUListItem /^\s*[*+-]\s\+/he=e-1
syn match pandocUListItemBullet /[*+-]/ contained containedin=pandocUListItem conceal cchar=•
" Ordered lists
syn match pandocListItem /^\s*\(\((*\d\+[.)]\+\)\|\((*\l[.)]\+\)\)\s\+/he=e-1
syn match pandocListItem /^\s*(*\u[.)]\+\s\{2,}/he=e-1
syn match pandocListItem /^\s*(*[#][.)]\+\s\{1,}/he=e-1
syn match pandocListItem /^\s*(*@.\{-}[.)]\+\s\{1,}/he=e-1
" roman numerals, up to 'c', for now
syn match pandocListItem /^\s*(*x\=l\=\(i\{,3}[vx]\=\)\{,3}c\{,3}[.)]\+/ 
" }}}

" Special: {{{1
"
" Horizontal Rules: {{{2
"
" 3 or more * on a line
syn match pandocHRule /\s\{0,3}\(-\s*\)\{3,}\n/ conceal cchar=—
" 3 or more - on a line
syn match pandocHRule /\s\{0,3}\(\*\s*\)\{3,}\n/ conceal cchar=—
"}}}
" New lines: {{{2
syn match pandocNewLine /\(  \|\\\)$/ conceal cchar=↵
"}}}
" }}}

" YAML: {{{1

unlet b:current_syntax
syn include @YAML colors/yaml.vim
syn region pandocYAMLHeader matchgroup=Delimiter start=/\%^\-\-\-/ end=/\-\-\-/ contains=@YAML 
"}}}

" Styling: {{{1
hi pandocTitleBlock term=italic gui=italic
hi link pandocTitleBlockTitle Directory
hi link pandocAtxHeader Title
hi link AtxStart Operator
hi link pandocSetexHeader Title

hi link pandocBlockQuote Comment
hi link pandocCodeBlock String
hi link pandocCodeBlockInsideIndent String
hi link pandocDelimitedCodeBlock String
hi link pandocDelimitedCodeBlockStart Delimiter
hi link pandocDelimitedCodeBlockEnd Delimiter
hi link pandocDelimitedCodeBlockLanguage Comment
hi link pandocCodePre String
hi link pandocUListItem Operator
hi link pandocListItem Operator
hi link pandocUListItemBullet Operator

hi link pandocLinkArea Operator
hi link pandocLinkText String 
hi link pandocLinkData Underlined
hi link pandocLinkTip Identifier 
hi link pandocImageIcon Operator

hi link pandocReferenceArea Operator
hi link pandocReferenceText String
hi link pandocReferenceLabel Label

hi link pandocReferenceDefinition Operator
hi link pandocReferenceDefinitionLabel Label
hi link pandocReferenceDefinitionAddress Underlined
hi link pandocReferenceDefinitionTip Identifier

hi link pandocAutomaticLink Underlined

hi link pandocDefinitionBlockTerm Identifier
hi link pandocDefinitionBlockMark Operator

hi link pandocAbbreviationHead Type
hi link pandocAbbreviation Label
hi link pandocAbbreviationTail Type
hi link pandocAbbreviationSeparator Identifier
hi link pandocAbbreviationDefinition Comment

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
hi pandocStrongEmphasis gui=bold,italic cterm=bold,italic
hi pandocStrongInEmphasis gui=bold,italic cterm=bold,italic
hi pandocEmphasisInStrong gui=bold,italic cterm=bold,italic
hi link pandocNoFormatted String
hi pandocSubscript gui=underline cterm=underline
hi pandocSuperscript gui=underline cterm=underline
hi pandocStrikeout gui=underline cterm=underline

hi link pandocNewLine Error
"}}}

let b:current_syntax = "pandoc"
