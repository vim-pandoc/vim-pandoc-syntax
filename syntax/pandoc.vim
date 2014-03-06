" vi: fdm=marker 
" Vim syntax file
" Language: Pandoc (superset of Markdown)
" Maintainer: Felipe Morales <hel.sheep@gmail.com>
" Contributor: David Sanson <dsanson@gmail.com>
" Contributor: Jorge Israel Peña <jorge.israel.p@gmail.com>
" OriginalAuthor: Jeremy Schultz <taozhyn@gmail.com>
" Version: 5.0

" Configuration: {{{1
"
" use conceal {{{2
if !exists("g:pandoc_use_conceal")
    if v:version < 703
	let g:pandoc_use_conceal = 0
    else
	let g:pandoc_use_conceal = 1
    endif
else
    " exists, but we cannot use it, disable anyway
    if v:version < 703
	let g:pandoc_use_conceal = 0
    endif
endif
"}}}2
" what groups not to use conceal in. works as a blacklist {{{2
if !exists("g:pandoc_syntax_dont_use_conceal_for_rules")
    let g:pandoc_syntax_dont_use_conceal_for_rules = []
endif
"}}}2
" cchars used in conceal rules {{{2
let s:cchars = { 
	    \"newline": "↵", 
	    \"image": "▨", 
	    \"super": "ⁿ", 
	    \"sub": "ₙ", 
	    \"strike": "x̶", 
	    \"atx": "§",  
	    \"codelang": "λ",
	    \"abbrev": "→",
	    \"footnote": "†",
	    \"definition": " ",
	    \"li": "•",
	    \"hr": "—" }
"}}}2
" if the user has a dictionary with replacements for the default cchars, use those {{{2
if exists("g:pandoc_syntax_user_cchars")
    let s:cchars = extend(s:cchars, g:pandoc_syntax_user_cchars)
endif
"}}}2
" leave specified codeblocks as Normal (i.e. 'unhighlighted') {{{2
if !exists("g:pandoc_syntax_ignore_codeblocks")
    let g:pandoc_syntax_ignore_codeblocks = []
endif
"}}}2
" use embedded highlighting for delimited codeblocks where a language is specifed. {{{2
if !exists("g:pandoc_use_embeds_in_codeblocks")
    let g:pandoc_use_embeds_in_codeblocks = 1
endif
"}}}2
" for what languages and using what vim syntax files highlight those embeds. {{{2
" defaults to None.
if !exists("g:pandoc_use_embeds_in_codeblocks_for_langs")
    let g:pandoc_use_embeds_in_codeblocks_for_langs = []
endif
"}}}2
" underline subscript, superscript and strikeout? {{{2
if !exists("g:pandoc_underline_special_blocks")
    let g:pandoc_underline_special_blocks = 1
endif
" }}}2
" }}}

" Functions: {{{1
" EnableEmbedsforCodeblocksWithLang {{{2
function! EnableEmbedsforCodeblocksWithLang(entry)
    try
        let s:langname = matchstr(a:entry, "^[^=]*")
        let s:langsyntaxfile = matchstr(a:entry, "[^=]*$")
        unlet! b:current_syntax
        exe 'syn include @'.toupper(s:langname).' syntax/'.s:langsyntaxfile.'.vim'
        exe "syn region pandocDelimitedCodeBlock_" . s:langname . ' start=/\(\_^\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\s*\%({[^.]*\.\)\=' . s:langname . '.*\n\)\@<=\_^/' .
        \' end=/\_$\n\(\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\_$\n\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock' .
        \' contains=@' . toupper(s:langname)
    catch /E484/
      echo "No syntax file found for '" . s:langsyntaxfile . "'"
    endtry
endfunction
"}}}2
" DisableEmbedsforCodeblocksWithLang {{{2
function! DisableEmbedsforCodeblocksWithLang(langname)
    try
      exe 'syn clear pandocDelimitedCodeBlock_'.a:langname
      exe 'hi clear pandocDefinitionBlock_'.a:langname
    catch /E28/
      echo "No existing highlight definitions found for '" . a:langname . "'"
    endtry
endfunction
"}}}2
" WithConceal {{{2
function! s:WithConceal(rule_group, rule, conceal_rule)
    let l:rule_tail = ""
    if g:pandoc_use_conceal != 0
	if index(g:pandoc_syntax_dont_use_conceal_for_rules, a:rule_group) == -1
	    let l:rule_tail = " " . a:conceal_rule
	endif
    endif
    execute a:rule . l:rule_tail
endfunction
"}}}2
"}}}1

" Commands: {{{1
command! -buffer -nargs=1 -complete=syntax PandocHighlight call EnableEmbedsforCodeblocksWithLang(<f-args>)
command! -buffer -nargs=1 -complete=syntax PandocUnhighlight call DisableEmbedsforCodeblocksWithLang(<f-args>)
" }}}

" BASE: {{{1
syntax clear
if g:pandoc_use_conceal != 0
    setlocal conceallevel=2
endif
syntax spell toplevel
"}}}

" Embeds: {{{1
" HTML: {{{2
" Set embedded HTML highlighting
syn include @HTML syntax/html.vim
syn match pandocHTML /<\/\?\a[^>]\+>/ contains=@HTML
" Support HTML multi line comments
syn region pandocHTMLComment start=/<!--/ end=/-->/
" }}}
" LaTeX: {{{2
" Set embedded LaTex (pandoc extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim
syn match pandocLaTeXInlineMath /\$[[:graph:]]\@=\_.\{-}[[:graph:]]\@<=\$/ contains=@LATEX
syn region pandocLaTeXMathBlock start=/\$\$/ end=/\$\$/ keepend contains=@LATEX 
syn match pandocLaTeXCommand /\\[[:alpha:]]\+\(\({.\{-}}\)\=\(\[.\{-}\]\)\=\)*/ contains=@LATEX 
syn region pandocLaTeXRegion start=/\\begin{\z(.\{-}\)}/ end=/\\end{\z1}/ keepend contains=@LATEX
" }}}}
" }}}

" Titleblock: {{{1
"
syn region pandocTitleBlock start=/\%^%/ end=/\n\n/ contains=pandocReferenceLabel,pandocReferenceURL,pandocNewLine
call s:WithConceal("titleblock", 'syn match pandocTitleBlockMark /%\ / contained containedin=pandocTitleBlock,pandocTitleBlockTitle', 'conceal')
syn match pandocTitleBlockTitle /\%^%.*\n/ contained containedin=pandocTitleBlock
"}}}

" Blockquotes: {{{1
"
syn match pandocBlockQuote /^>.*\n\(.*\n\@<!\n\)*/ contains=@Spell,pandocEmphasis,pandocStrong,pandocPCite,pandocSuperscript,pandocSubscript,pandocStrikeout,pandocUListItem skipnl

" }}}

" Code Blocks: {{{1
"
syn region pandocCodeBlockInsideIndent   start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{8,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/ contained
"}}}

" Links: {{{1
"
" Base: {{{2
syn region pandocReferenceLabel matchgroup=Operator start=/!\{,1}\[/ skip=/\]\]\@=/ end=/\]/ keepend
syn region pandocReferenceURL matchgroup=Operator start=/\]\@<=(/ end=/)/ keepend
syn match pandocLinkTip /\s*".\{-}"/ contained containedin=pandocReferenceURL contains=@Spell
call s:WithConceal("image", 'syn match pandocImageIcon /!\[\@=/', 'conceal cchar='. s:cchars["image"])
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
"}}}

" Citations: {{{1
" parenthetical citations
syn match pandocPCite /\[-\{0,1}@.\{-}\]/ contains=pandocEmphasis,pandocStrong,pandocLatex,@Spell
" in-text citations without location
syn match pandocPCite /@[[:graph:]äëïöüáéíóúàèìòùłßÄËÏÖÜÁÉÍÓÚÀÈÌÒÙŁß]*/

" in-text citations with location
syn match pandocPCite /@[[:graph:]äëïöüáéíóúàèìòùłßÄËÏÖÜÁÉÍÓÚÀÈÌÒÙŁß]*\s\[.\{-}\]/
syn match pandocPCiteAnchor /@/ contained containedin=pandocPCite
" }}}

" Text Styles: {{{1

" Emphasis: {{{2
"
call s:WithConceal("block", 'syn region pandocEmphasis matchgroup=Operator start=/\\\@<!\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\*\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasis matchgroup=Operator start=/\\\@<!\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=_\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell', 'concealends')
" }}}
" Strong: {{{2
"
call s:WithConceal("block", 'syn region pandocStrong matchgroup=Operator start=/\*\*/ end=/\*\*/ contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocStrong matchgroup=Operator start=/__/ end=/__/ contains=@Spell', 'concealends')
"}}}
" Strong Emphasis: {{{2
"
call s:WithConceal("block", 'syn region pandocStrongEmphasis matchgroup=Operator start=/\*\*\*/ end=/\*\*\*/ contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocStrongEmphasis matchgroup=Operator start=/___/ end=/___/ contains=@Spell', 'concealends')
" }}}
" Mixed: {{{2
call s:WithConceal("block", 'syn region pandocStrongInEmphasis matchgroup=Operator start=/\*\*/ end=/\*\*/ contained containedin=pandocEmphasis contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocStrongInEmphasis matchgroup=Operator start=/__/ end=/__/ contained containedin=pandocEmphasis contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasisInStrong matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=\*\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasisInStrong matchgroup=Operator start=/\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=_\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell', 'concealends')

" Inline Code: {{{2

" Using single back ticks
call s:WithConceal("inlinecode", 'syn region pandocNoFormatted matchgroup=Operator start=/`/ end=/`/', 'concealends')
" Using double back ticks
call s:WithConceal("inlinecode", 'syn region pandocNoFormatted matchgroup=Operator start=/``/ end=/``/', 'concealends')
"}}}
" Subscripts: {{{2 
syn region pandocSubscript start=/\~\(\([[:graph:]]\(\\ \)\=\)\{-}\~\)\@=/ end=/\~/ keepend
call s:WithConceal("subscript", 'syn match pandocSubscriptMark /\~/ contained containedin=pandocSubscript', 'conceal cchar='.s:cchars["sub"])
"}}}
" Superscript: {{{2
syn region pandocSuperscript start=/\^\(\([[:graph:]]\(\\ \)\=\)\{-}\^\)\@=/ skip=/\\ / end=/\^/ keepend
call s:WithConceal("superscript", 'syn match pandocSuperscriptMark /\^/ contained containedin=pandocSuperscript', 'conceal cchar='.s:cchars["super"])
"}}}
" Strikeout: {{{2
syn region pandocStrikeout start=/\~\~/ end=/\~\~/ contains=@Spell keepend
call s:WithConceal("strikeout", 'syn match pandocStrikeoutMark /\~\~/ contained containedin=pandocStrikeout', 'conceal cchar='.s:cchars["strike"])
" }}}
" }}}

" Headers: {{{1
"
syn match pandocAtxHeader /^\s*#\{1,6}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted
call s:WithConceal("atx", 'syn match AtxStart /#/ contained containedin=pandocAtxHeader', 'conceal cchar='.s:cchars["atx"])
syn match pandocSetexHeader /^.\+\n[=]\+$/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted
syn match pandocSetexHeader /^.\+\n[-]\+$/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted
"}}}

" Delimited Code Blocks: {{{1
" this is here because we can override strikeouts and subscripts
syn region pandocDelimitedCodeBlock start=/^\z(\(\s\{4,}\)\=\~\{3,}\~*\)/ end=/\z1\~*/ skipnl contains=pandocDelimitedCodeBlockStart,pandocDelimitedCodeBlockEnd keepend
syn region pandocDelimitedCodeBlock start=/^\z(\(\s\{4,}\)\=`\{3,}`*\)/ end=/\z1`*/ skipnl contains=pandocDelimitedCodeBlockStart,pandocDelimitedCodeBlockEnd keepend
call s:WithConceal("codeblock_start", 'syn match pandocDelimitedCodeBlockStart /\(\_^\n\_^\(\s\{4,}\)\=\)\@<=\(\~\{3,}\~*\|`\{3,}`*\)/ contained nextgroup=pandocDelimitedCodeBlockLanguage', 'conceal cchar='.s:cchars["codelang"])
syn match pandocDelimitedCodeBlockLanguage /\(\s\?\)\@<=.\+\(\_$\)\@=/ contained
call s:WithConceal("codeblock_delim", 'syn match pandocDelimitedCodeBlockEnd /\(`\{3,}`*\|\~\{3,}\~*\)\(\_$\n\_$\)\@=/', 'conceal')
syn match pandocCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pandocCodePre /<code>.\{-}<\/code>/ skipnl

" enable highlighting for embedded region in codeblocks if there exists a
" g:pandoc_use_embeds_in_codeblocks_for_langs *list*.
"
" entries in this list are the language code interpreted by pandoc,
" if this differs from the name of the vim syntax file, append =vimname
" e.g. let g:pandoc_use_embeds_in_codeblocks_for_langs = ["haskell", "literatehaskell=lhaskell"]
"
if g:pandoc_use_embeds_in_codeblocks != 0
    for l in g:pandoc_use_embeds_in_codeblocks_for_langs
      call EnableEmbedsforCodeblocksWithLang(l)
    endfor
endif
" }}}

" Abbreviations: {{{1
syn region pandocAbbreviationDefinition start=/^\*\[.\{-}\]:\s*/ end="$" contains=pandocNoFormatted,@Spell
call s:WithConceal('abbrev', 'syn match pandocAbbreviationSeparator /:/ contained containedin=pandocAbbreviationDefinition', "conceal cchar=".s:cchars["abbrev"])
syn match pandocAbbreviation /\*\[.\{-}\]/ contained containedin=pandocAbbreviationDefinition
call s:WithConceal('abbrev', 'syn match pandocAbbreviationHead /\*\[/ contained containedin=pandocAbbreviation', "conceal")
call s:WithConceal('abbrev', 'syn match pandocAbbreviationTail /\]/ contained containedin=pandocAbbreviation', "conceal")
" }}}

" Footnotes: {{{1
" we put these here not to interfere with superscripts.
"
syn match pandocFootnoteID /\[\^[^\]]\+\]/ nextgroup=pandocFootnoteDef
"   Inline footnotes
syn region pandocFootnoteDef start=/\^\[/ end=/\]/ contains=pandocReferenceLabel,pandocReferenceURL,pandocLatex,pandocPCite,,pandocEnDash,pandocEmDash,pandocEllipses,pandocBeginQuote,pandocEndQuote,@Spell skipnl keepend 
call s:WithConceal("footnote", 'syn match pandocFootnoteDefHead /\^\[/ contained containedin=pandocFootnoteDef', 'conceal cchar='.s:cchars["footnote"])
call s:WithConceal("footnote", 'syn match pandocFootnoteDefTail /\]/ contained containedin=pandocFootnoteDef', 'conceal')

" regular footnotes
syn region pandocFootnoteBlock start=/\[\^.\{-}\]:\s*\n*/ end=/^\n^\s\@!/ contains=pandocReferenceLabel,pandocReferenceURL,pandocLatex,pandocPCite,pandocStrong,pandocEmphasis,pandocNoFormatted,pandocSuperscript,pandocSubscript,pandocStrikeout,pandocEnDash,pandocEmDash,pandocNewLine,pandocStrongEmphasis,pandocEllipses,pandocBeginQuote,pandocEndQuote,@Spell skipnl
syn match pandocFootnoteBlockSeparator /:/ contained containedin=pandocFootnoteBlock
syn match pandocFootnoteID /\[\^.\{-}\]/ contained containedin=pandocFootnoteBlock
call s:WithConceal("footnote", 'syn match pandocFootnoteIDHead /\[\^/ contained containedin=pandocFootnoteID', 'conceal cchar='.s:cchars["footnote"])
call s:WithConceal("footnote", 'syn match pandocFootnoteIDTail /\]/ contained containedin=pandocFootnoteID', 'conceal')
" }}}

" Definitions: {{{1
"
syn region pandocDefinitionBlock start=/^\%(\_^\s*\([`~]\)\1\{2,}\)\@!.*\n\(^\s*\n\)*\s\{0,2}[:~]\(\~\{2,}\~*\)\@!/ skip=/\n\n\zs\s/ end=/\n\n/ contains=pandocDefinitionBlockMark,pandocDefinitionBlockTerm,pandocCodeBlockInsideIndent,pandocEmphasis,pandocStrong,pandocStrongEmphasis,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocFootnoteID,pandocReferenceURL,pandocReferenceLabel,pandocAutomaticLink keepend 
syn match pandocDefinitionBlockTerm /^.*\n\(^\s*\n\)*\(\s*[:~]\)\@=/ contained contains=pandocNoFormatted,pandocEmphasis,pandocStrong
call s:WithConceal("definition", 'syn match pandocDefinitionBlockMark /^\s*[:~]/ contained', 'conceal cchar='.s:cchars["definition"])
" }}}

" List Items: {{{1
"
" Unordered lists 
syn match pandocUListItem /^>\=\s*[*+-]\s\+/he=e-1,hs=s+1
call s:WithConceal("list", 'syn match pandocUListItemBullet /[*+-]/ contained containedin=pandocUListItem', 'conceal cchar='.s:cchars["li"])
" Ordered lists
syn match pandocListItem /^\s*\(\((*\d\+[.)]\+\)\|\((*\l[.)]\+\)\)\s\+/he=e-1
syn match pandocListItem /^\s*(*\u[.)]\+\s\{2,}/he=e-1
syn match pandocListItem /^\s*(*[#][.)]\+\s\{1,}/he=e-1
syn match pandocListItem /^\s*(*@.\{-}[.)]\+\s\{1,}/he=e-1
" roman numerals, up to 'c', for now
syn match pandocListItem /^\s*(*x\=l\=\(i\{,3}[vx]\=\)\{,3}c\{,3}[.)]\+/ 
" }}}

" Special: {{{1

" New_lines: {{{2
call s:WithConceal("newline", 'syn match pandocNewLine /\(  \|\\\)$/', 'conceal cchar='.s:cchars["newline"])
"}}}
" Dashes: {{{2
call s:WithConceal("dashes", 'syn match pandocEmDash /---/', 'conceal cchar=—')
call s:WithConceal("dashes", 'syn match pandocEnDash /---\@!/', 'conceal cchar=-')
call s:WithConceal("ellipses", 'syn match pandocEllipses /\.\.\./', 'conceal cchar=…')
" }}}
" Horizontal Rules: {{{2
call s:WithConceal("hrule", 'syn match pandocHRule /^\s\{,3}\([-*_]\s*\)\{3,}\n/', 'conceal cchar='.s:cchars["hr"])
"}}}
" Quotes: {{{2
call s:WithConceal("quotes", 'syn match pandocBeginQuote /"\</  containedin=pandocEmphasis,pandocStrong', 'conceal cchar=“')
call s:WithConceal("quotes", 'syn match pandocEndQuote /\(\>[[:punct:]]*\)\@<="/  containedin=pandocEmphasis,pandocStrong', 'conceal cchar=”')

" }}}
"
" }}}

" Tables: {{{1

" Simple: {{{2

syn region pandocSimpleTable start=/\(^.*[[:graph:]].*\n\)\@<!\(^.*[[:graph:]].*\n\)\(-\+\s*\)\+\n\n\@!/ end=/\n\n/ keepend
syn match pandocSimpleTableDelims /\-/ contained containedin=pandocSimpleTable
syn match pandocSimpleTableHeader /\(^.*[[:graph:]].*\n\)\@<!\(^.*[[:graph:]].*\n\)/ contained containedin=pandocSimpleTable
hi link pandocSimpleTableDelims Delimiter
hi link pandocSimpleTableHeader pandocStrong

syn region pandocTable start=/^\(-\+\s*\)\+\n\n\@!/ end=/^\(-\+\s*\)\+\n\n/ keepend
syn match pandocTableDelims /\-/ contained containedin=pandocTable
syn region pandocTableMultilineHeader start=/\(^-\+\n\)\@<=./ end=/\n-\@=/ contained containedin=pandocTable
hi link pandocTableMultilineHeader pandocStrong
hi link pandocTableDelims Delimiter

" }}}2
" Grid: {{{2
syn region pandocGridTable start=/\n\@<=+-/ end=/+\n\n/ keepend
syn match pandocGridTableDelims /[\|=]/ contained containedin=pandocGridTable
syn match pandocGridTableDelims /\([\-+][\-+=]\@=\|[\-+=]\@<=[\-+]\)/ contained containedin=pandocGridTable
syn match pandocGridTableHeader /\(^.*\n\)\(+=.*\)\@=/ contained containedin=pandocGridTable 
hi link pandocGridTableDelims Delimiter
hi link pandocGridTableHeader Delimiter
"}}}2
" Pipe: {{{2
" with beginning and end pipes
syn region pandocPipeTable start=/\([+|]\n\)\@<!\n\@<=|/ end=/|\n\n/ keepend 
" without beginning and end pipes
syn region pandocPipeTable start=/^.*\n-.\{-}|/ end=/|.*\n\n/ keepend
syn match pandocPipeTableDelims /[\|\-:+]/ contained containedin=pandocPipeTable
syn match pandocPipeTableHeader /\(^.*\n\)\(|-\)\@=/ contained containedin=pandocPipeTable
syn match pandocPipeTableHeader /\(^.*\n\)\(-\)\@=/ contained containedin=pandocPipeTable
hi link pandocPipeTableDelims Delimiter
hi link pandocPipeTableHeader Delimiter
" }}}2
syn match pandocTableHeaderWord /\<.\{-}\>/ contained containedin=pandocGridTableHeader,pandocPipeTableHeader
hi link pandocTableHeaderWord pandocStrong
" }}}1

" YAML: {{{1

try
    unlet! b:current_syntax
    syn include @YAML colors/yaml.vim
catch /E484/
endtry
syn region pandocYAMLHeader matchgroup=Delimiter start=/\%^\-\{3}/ end=/[\-|\.]\{3}/ contains=@YAML 
"}}}

" Styling: {{{1
" override this for consistency
hi pandocTitleBlock term=italic gui=italic
hi link pandocTitleBlockTitle Directory
hi link pandocAtxHeader Title
hi link AtxStart Operator
hi link pandocSetexHeader Title

hi link pandocHTMLComment Comment
hi link pandocBlockQuote Comment

" if the user sets g:pandoc_syntax_ignore_codeblocks to contain
" a codeblock type, don't highlight it so that it remains Normal

if index(g:pandoc_syntax_ignore_codeblocks, 'definition') == -1
  hi link pandocCodeBlockInsideIndent String
endif

if index(g:pandoc_syntax_ignore_codeblocks, 'delimited') == -1
  hi link pandocDelimitedCodeBlock Special
endif

hi link pandocDelimitedCodeBlockStart Delimiter
hi link pandocDelimitedCodeBlockEnd Delimiter
hi link pandocDelimitedCodeBlockLanguage Comment
hi link pandocCodePre String
hi link pandocUListItem Operator
hi link pandocListItem Operator
hi link pandocUListItemBullet Operator

hi link pandocReferenceLabel Label
hi link pandocReferenceURL Underlined
hi link pandocLinkTip Identifier
hi link pandocImageIcon Operator

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
hi link pandocSubscriptMark Operator
hi link pandocSuperscriptMark Operator
hi link pandocStrikeoutMark Operator
if g:pandoc_underline_special_blocks == 1
    hi pandocSubscript gui=underline cterm=underline
    hi pandocSuperscript gui=underline cterm=underline
    hi pandocStrikeout gui=underline cterm=underline
endif
hi link pandocNewLine Error
hi link pandocHRule Delimiter

"}}}

let b:current_syntax = "pandoc"

syntax sync clear
syntax sync minlines=100

