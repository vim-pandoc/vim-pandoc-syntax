" vim: set fdm=marker foldlevel=0:
" 
" Vim syntax file
"
" Language: Pandoc (superset of Markdown)
" Maintainer: Felipe Morales <hel.sheep@gmail.com>
" Contributor: David Sanson <dsanson@gmail.com>
" Contributor: Jorge Israel Peña <jorge.israel.p@gmail.com>
" OriginalAuthor: Jeremy Schultz <taozhyn@gmail.com>
" Version: 5.0

" Configuration: {{{1
"
" use conceal? {{{2
if !exists("g:pandoc#syntax#conceal#use")
    if v:version < 703
	let g:pandoc#syntax#conceal#use = 0
    else
	let g:pandoc#syntax#conceal#use = 1
    endif
else
    " exists, but we cannot use it, disable anyway
    if v:version < 703
	let g:pandoc#syntax#conceal#use = 0
    endif
endif
"}}}2
" what groups not to use conceal in. works as a blacklist {{{2
if !exists("g:pandoc#syntax#conceal#blacklist")
    let g:pandoc#syntax#conceal#blacklist = []
endif
"}}}2
" cchars used in conceal rules {{{2
" utf-8 defaults (preferred)
if &encoding == "utf-8"
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
                \"html_c_s": "‹",
                \"html_c_e": "›"}
else
    " ascii defaults
    let s:cchars = { 
		\"newline": " ", 
		\"image": "i", 
		\"super": "^", 
		\"sub": "_", 
		\"strike": "~", 
		\"atx": "#",  
		\"codelang": "l",
		\"abbrev": "a",
		\"footnote": "f",
		\"definition": " ",
		\"li": "*",
                \"html_c_s": "+",
                \"html_c_e": "+"}
endif
"}}}2
" if the user has a dictionary with replacements for the default cchars, use those {{{2
if exists("g:pandoc#syntax#conceal#cchar_overrides")
    let s:cchars = extend(s:cchars, g:pandoc#syntax#conceal#cchar_overrides)
endif
"}}}2
"should the urls in links be concealed? {{{2
if !exists("g:pandoc#syntax#conceal#urls")
    let g:pandoc#syntax#conceal#urls = 0
endif
" should backslashes in escapes be concealed? {{{2
if !exists("g:pandoc#syntax#conceal#backslash") 
    let g:pandoc#syntax#conceal#backslash = 0
endif
"}}}2
" leave specified codeblocks as Normal (i.e. 'unhighlighted') {{{2
if !exists("g:pandoc#syntax#codeblocks#ignore")
    let g:pandoc#syntax#codeblocks#ignore = []
endif
"}}}2
" use embedded highlighting for delimited codeblocks where a language is specifed. {{{2
if !exists("g:pandoc#syntax#codeblocks#embeds#use")
    let g:pandoc#syntax#codeblocks#embeds#use = 1
endif
"}}}2
" for what languages and using what vim syntax files highlight those embeds. {{{2
" defaults to None.
if !exists("g:pandoc#syntax#codeblocks#embeds#langs")
    let g:pandoc#syntax#codeblocks#embeds#langs = []
endif
"}}}2
" use italics ? {{{2
if !exists("g:pandoc#syntax#style#emphases")
    let g:pandoc#syntax#style#emphases = 1
endif
" if 0, we don't conceal the emphasis marks, otherwise there wouldn't be a way
" to tell where the styles apply.
if g:pandoc#syntax#style#emphases == 0
    call add(g:pandoc#syntax#conceal#blacklist, "block")
endif
" }}}2
" underline subscript, superscript and strikeout? {{{2
if !exists("g:pandoc#syntax#style#underline_special")
    let g:pandoc#syntax#style#underline_special = 1
endif
" }}}2
" protect code blocks? {{{2
if !exists("g:pandoc#syntax#protect#codeblocks")
    let g:pandoc#syntax#protect#codeblocks = 1
endif
" use color column? {{{2
if !exists("g:pandoc#syntax#colorcolumn")
    let g:pandoc#syntax#colorcolumn = 0
endif
" }}}2
" highlight new lines? {{{2
if !exists("g:pandoc#syntax#newlines")
    let g:pandoc#syntax#newlines = 1
endif
" }}}
" detect roman-numeral list items? {{{2
if !exists('g:pandoc#syntax#roman_lists')
    let g:pandoc#syntax#roman_lists = 0
endif
" }}}
"}}}1

" Functions: {{{1
" EnableEmbedsforCodeblocksWithLang {{{2
function! EnableEmbedsforCodeblocksWithLang(entry)
    try
        let s:langname = matchstr(a:entry, "^[^=]*")
        let s:langsyntaxfile = matchstr(a:entry, "[^=]*$")
        unlet! b:current_syntax
        exe 'syn include @'.toupper(s:langname).' syntax/'.s:langsyntaxfile.'.vim'
        exe "syn region pandocDelimitedCodeBlock_" . s:langname . ' start=/\(\_^\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\s*\%({[^.]*\.\)\=' . s:langname . '\>.*\n\)\@<=\_^/' .
		    \' end=/\_$\n\(\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\_$\n\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock' .
		    \' contains=@' . toupper(s:langname)
	exe "syn region pandocDelimitedCodeBlockinBlockQuote_" . s:langname . ' start=/>\s\(`\{3,}`*\|\~\{3,}\~*\)\s*\%({[^.]*\.\)\=' . s:langname . '\>/' .
		    \ ' end=/\(`\{3,}`*\|\~\{3,}\~*\)/ contained containedin=pandocDelimitedCodeBlock' .
		    \' contains=@' . toupper(s:langname) . 
		    \",pandocDelimitedCodeBlockStart,pandocDelimitedCodeBlockEnd,pandodDelimitedCodeblockLang,pandocBlockQuoteinDelimitedCodeBlock"
    catch /E484/
      echo "No syntax file found for '" . s:langsyntaxfile . "'"
    endtry
endfunction
"}}}2
" DisableEmbedsforCodeblocksWithLang {{{2
function! DisableEmbedsforCodeblocksWithLang(langname)
    try
      exe 'syn clear pandocDelimitedCodeBlock_'.a:langname
      exe 'syn clear pandocDelimitedCodeBlockinBlockQuote_'.a:langname
    catch /E28/
      echo "No existing highlight definitions found for '" . a:langname . "'"
    endtry
endfunction
"}}}2
" WithConceal {{{2
function! s:WithConceal(rule_group, rule, conceal_rule)
    let l:rule_tail = ""
    if g:pandoc#syntax#conceal#use != 0
	if index(g:pandoc#syntax#conceal#blacklist, a:rule_group) == -1
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

" BASE:
syntax clear
syntax spell toplevel
" apply extra settings: {{{1
if g:pandoc#syntax#colorcolumn == 1
    exe "setlocal colorcolumn=".string(&textwidth+5)
elseif g:pandoc#syntax#colorcolumn == 2
    exe "setlocal colorcolumn=".join(range(&textwidth+5, 2*&columns), ',')
endif
if g:pandoc#syntax#conceal#use != 0
    setlocal conceallevel=2
endif
"}}}1

" Syntax Rules: {{{1
" Embeds: {{{2
" HTML: {{{3
" Set embedded HTML highlighting
syn include @HTML syntax/html.vim
syn match pandocHTML /<\/\?\a.\{-}>/ contains=@HTML
" Support HTML multi line comments
syn region pandocHTMLComment start=/<!--\s\=/ end=/\s\=-->/ keepend contains=pandocHTMLCommentStart,pandocHTMLCommentEnd
call s:WithConceal('html_c_s', 'syn match pandocHTMLCommentStart /<!--/ contained', 'conceal cchar='.s:cchars['html_c_s'])
call s:WithConceal('html_c_e', 'syn match pandocHTMLCommentEnd /-->/ contained', 'conceal cchar='.s:cchars['html_c_e'])
" }}}
" LaTeX: {{{3
" Set embedded LaTex (pandoc extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim
syn region pandocLaTeXInlineMath start=/\\\@<!\$[[:graph:]]\@=/ end=/\\\@<!\$/ keepend contains=@LATEX 
syn match pandocProtectedFromInlineLaTeX /\\\@<!\${.*}\(\(\s\|[[:punct:]]\)\([^$]*\|.*\(\\\$.*\)\{2}\)\n\n\|$\)\@=/ display
" contains=@LATEX
syn region pandocLaTeXMathBlock start=/\$\$/ end=/\$\$/ keepend contains=@LATEX 
syn match pandocLaTeXCommand /\\[[:alpha:]]\+\(\({.\{-}}\)\=\(\[.\{-}\]\)\=\)*/ contains=@LATEX 
syn region pandocLaTeXRegion start=/\\begin{\z(.\{-}\)}/ end=/\\end{\z1}/ keepend contains=@LATEX
" we rehighlight sectioning commands, because otherwise tex.vim captures all text until EOF or a new sectioning command
syn region pandocLaTexSection start=/\\\(part\|chapter\|\(sub\)\{,2}section\|\(sub\)\=paragraph\)\*\=\(\[.*\]\)\={/ end=/\}/ keepend
syn match pandocLaTexSectionCmd /\\\(part\|chapter\|\(sub\)\{,2}section\|\(sub\)\=paragraph\)/ contained containedin=pandocLaTexSection 
syn match pandocLaTeXDelimiter /[[\]{}]/ contained containedin=pandocLaTexSection
" }}}}
" }}}2
" Titleblock: {{{2
"
syn region pandocTitleBlock start=/\%^%/ end=/\n\n/ contains=pandocReferenceLabel,pandocReferenceURL,pandocNewLine 
call s:WithConceal("titleblock", 'syn match pandocTitleBlockMark /%\ / contained containedin=pandocTitleBlock,pandocTitleBlockTitle', 'conceal')
syn match pandocTitleBlockTitle /\%^%.*\n/ contained containedin=pandocTitleBlock
"}}}
" Blockquotes: {{{2
"
syn match pandocBlockQuote /^\s\{,3}>.*\n\(.*\n\@1<!\n\)*/ contains=@Spell,pandocEmphasis,pandocStrong,pandocPCite,pandocSuperscript,pandocSubscript,pandocStrikeout,pandocUListItem,pandocNoFormatted skipnl
syn match pandocBlockQuoteMark /\_^\s\{,3}>/ contained containedin=pandocEmphasis,pandocStrong,pandocPCite,pandocSuperscript,pandocSubscript,pandocStrikeout,pandocUListItem,pandocNoFormatted

" }}}
" Code Blocks: {{{2
if g:pandoc#syntax#protect#codeblocks == 1
    syn match pandocCodeblock /\s\{4}.*$/
endif
syn region pandocCodeBlockInsideIndent   start=/\(\(\d\|\a\|*\).*\n\)\@<!\(^\(\s\{8,}\|\t\+\)\).*\n/ end=/.\(\n^\s*\n\)\@=/ contained
"}}}
" Links: {{{2
"
" Base: {{{3
syn region pandocReferenceLabel matchgroup=Operator start=/!\{,1}\\\@<!\[/ skip=/\(\\\@<!\]\]\@=\|`.*\\\@<!].*`\)/ end=/\\\@<!\]/ keepend display
if g:pandoc#syntax#conceal#urls == 1
    syn region pandocReferenceURL matchgroup=Operator start=/\]\@1<=(/ end=/)/ keepend display conceal
else
    syn region pandocReferenceURL matchgroup=Operator start=/\]\@1<=(/ end=/)/ keepend display 
endif
" let's not consider "a [label] a" as a label, remove formatting - Note: breaks implicit links
syn match pandocNoLabel /\]\@1<!\(\s\{,3}\|^\)\[[^\[\]]\{-}\]\(\s\+\|$\)[\[(]\@!/ contains=pandocPCite
syn match pandocLinkTip /\s*".\{-}"/ contained containedin=pandocReferenceURL contains=@Spell display
call s:WithConceal("image", 'syn match pandocImageIcon /!\[\@=/ display', 'conceal cchar='. s:cchars["image"]) 
" }}}
" Definitions: {{{3
syn region pandocReferenceDefinition start=/\[.\{-}\]:/ end=/\(\n\s*".*"$\|$\)/ keepend
syn match pandocReferenceDefinitionLabel /\[\zs.\{-}\ze\]:/ contained containedin=pandocReferenceDefinition display
syn match pandocReferenceDefinitionAddress /:\s*\zs.*/ contained containedin=pandocReferenceDefinition
syn match pandocReferenceDefinitionTip /\s*".\{-}"/ contained containedin=pandocReferenceDefinition,pandocReferenceDefinitionAddress contains=@Spell
"}}}
" Automatic_links: {{{3
syn match pandocAutomaticLink /<\(https\{0,1}.\{-}\|.\{-}@.\{-}\..\{-}\)>/ contains=NONE
" }}}
"}}}
" Citations: {{{2
" parenthetical citations
syn match pandocPCite /\[.\{-}-\{0,1}@.\{-}\]/ contains=pandocEmphasis,pandocStrong,pandocLatex,pandocCiteKey,@Spell display
" in-text citations with location
syn match pandocICite /@[[:graph:]äëïöüáéíóúàèìòùłßÄËÏÖÜÁÉÍÓÚÀÈÌÒÙŁß]*\s\[.\{-}\]/ contains=pandocCiteKey,@Spell display
" cite keys
syn match pandocCiteKey /\(-\=@[[:graph:]äëïöüáéíóúàèìòùłßÄËÏÖÜÁÉÍÓÚÀÈÌÒÙŁß]*\)\(\]\|\>\)\@=/ containedin=pandocPCite,pandocICite contains=@NoSpell display
syn match pandocCiteAnchor /[-@]/ contained containedin=pandocCiteKey display
syn match pandocCiteLocator /[\[\]]/ contained containedin=pandocPCite,pandocICite
" }}}
" Text Styles: {{{2

" Emphasis: {{{3
"
call s:WithConceal("block", 'syn region pandocEmphasis matchgroup=Operator start=/\\\@1<!\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\*\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell,pandocNoFormattedInEmphasis,pandocLatexInlineMath', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasis matchgroup=Operator start=/\\\@1<!\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@1<=_\([[:punct:]]\|\s\|\_$\)\@=/ contains=@Spell,pandocNoFormattedInEmphasis,pandocLatexInlineMath', 'concealends')
" }}}
" Strong: {{{3
"
call s:WithConceal("block", 'syn region pandocStrong matchgroup=Operator start=/\(\\\@<!\*\)\{2}/ end=/\(\\\@<!\*\)\{2}/ contains=@Spell,pandocNoFormattedInStrong,pandocLatexInlineMath', 'concealends')
call s:WithConceal("block", 'syn region pandocStrong matchgroup=Operator start=/__/ end=/__/ contains=@Spell,pandocNoFormattedInStrong,pandocLatexInlineMath', 'concealends')
"}}}
" Strong Emphasis: {{{3
"
call s:WithConceal("block", 'syn region pandocStrongEmphasis matchgroup=Operator start=/\*\{3}\(\S[^*]*\(\*\S\|\n[^*]*\*\S\)\)\@=/ end=/\S\@<=\*\{3}/ contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocStrongEmphasis matchgroup=Operator start=/\(___\)\S\@=/ end=/\S\@<=___/ contains=@Spell', 'concealends')
" }}}
" Mixed: {{{3
call s:WithConceal("block", 'syn region pandocStrongInEmphasis matchgroup=Operator start=/\*\*/ end=/\*\*/ contained containedin=pandocEmphasis contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocStrongInEmphasis matchgroup=Operator start=/__/ end=/__/ contained containedin=pandocEmphasis contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasisInStrong matchgroup=Operator start=/\\\@1<!\(\_^\|\s\|[[:punct:]]\)\@<=\*\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=\*\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell', 'concealends')
call s:WithConceal("block", 'syn region pandocEmphasisInStrong matchgroup=Operator start=/\\\@<!\(\_^\|\s\|[[:punct:]]\)\@<=_\S\@=/ skip=/\(\*\*\|__\)/ end=/\S\@<=_\([[:punct:]]\|\s\|\_$\)\@=/ contained containedin=pandocStrong contains=@Spell', 'concealends')

" Inline Code: {{{3

" Using single back ticks
call s:WithConceal("inlinecode", 'syn region pandocNoFormatted matchgroup=Operator start=/\\\@<!`/ end=/\\\@<!`/ nextgroup=pandocNoFormattedAttrs', 'concealends')
call s:WithConceal("inlinecode", 'syn region pandocNoFormattedInEmphasis matchgroup=Operator start=/\\\@<!`/ end=/\\\@<!`/ nextgroup=pandocNoFormattedAttrs contained', 'concealends')
call s:WithConceal("inlinecode", 'syn region pandocNoFormattedInStrong matchgroup=Operator start=/\\\@<!`/ end=/\\\@<!`/ nextgroup=pandocNoFormattedAttrs contained', 'concealends')
" Using double back ticks
call s:WithConceal("inlinecode", 'syn region pandocNoFormatted matchgroup=Operator start=/\\\@<!``/ end=/\\\@<!``/ nextgroup=pandocNoFormattedAttrs', 'concealends')
call s:WithConceal("inlinecode", 'syn region pandocNoFormattedInEmphasis matchgroup=Operator start=/\\\@<!``/ end=/\\\@<!``/ nextgroup=pandocNoFormattedAttrs contained', 'concealends')
call s:WithConceal("inlinecode", 'syn region pandocNoFormattedInStrong matchgroup=Operator start=/\\\@<!``/ end=/\\\@<!``/ nextgroup=pandocNoFormattedAttrs contained', 'concealends')
syn match pandocNoFormattedAttrs /{.\{-}}/ contained
"}}}
" Subscripts: {{{3 
syn region pandocSubscript start=/\~\(\([[:graph:]]\(\\ \)\=\)\{-}\~\)\@=/ end=/\~/ keepend
call s:WithConceal("subscript", 'syn match pandocSubscriptMark /\~/ contained containedin=pandocSubscript', 'conceal cchar='.s:cchars["sub"])
"}}}
" Superscript: {{{3
syn region pandocSuperscript start=/\^\(\([[:graph:]]\(\\ \)\=\)\{-}\^\)\@=/ skip=/\\ / end=/\^/ keepend
call s:WithConceal("superscript", 'syn match pandocSuperscriptMark /\^/ contained containedin=pandocSuperscript', 'conceal cchar='.s:cchars["super"])
"}}}
" Strikeout: {{{3
syn region pandocStrikeout start=/\~\~/ end=/\~\~/ contains=@Spell keepend
call s:WithConceal("strikeout", 'syn match pandocStrikeoutMark /\~\~/ contained containedin=pandocStrikeout', 'conceal cchar='.s:cchars["strike"])
" }}}
" }}}
" Headers: {{{2
"
syn match pandocAtxHeader /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{1,6}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,@Spell, display
syn match pandocAtxHeaderMark /\(^#\{1,6}\|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader
call s:WithConceal("atx", 'syn match pandocAtxStart /#/ contained containedin=pandocAtxHeaderMark', 'conceal cchar='.s:cchars["atx"])
syn match pandocSetexHeader /^.\+\n[=]\+$/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,@Spell
syn match pandocSetexHeader /^.\+\n[-]\+$/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,@Spell
syn match pandocHeaderAttr /{.*}/ contained containedin=pandocAtxHeader,pandocSetexHeader
syn match pandocHeaderID /#[-_:.[:alpha:]]*/ contained containedin=pandocHeaderAttr
"}}}
" Line Blocks: {{{2
syn region pandocLineBlock start=/^|/ end=/\(^|\(.*\n|\@!\)\@=.*\)\@<=\n/ 
syn match pandocLineBlockDelimiter /^|/ contained containedin=pandocLineBlock
"}}}
" Tables: {{{2

" Simple: {{{3

syn region pandocSimpleTable start=/\%#=2\(^.*[[:graph:]].*\n\)\@<!\(^.*[[:graph:]].*\n\)\(-\+\s*\)\+\n\n\@!/ end=/\n\n/ containedin=ALLBUT,pandocDelimitedCodeBlock,pandocYAMLHeader keepend
syn match pandocSimpleTableDelims /\-/ contained containedin=pandocSimpleTable
syn match pandocSimpleTableHeader /\%#=2\(^.*[[:graph:]].*\n\)\@<!\(^.*[[:graph:]].*\n\)/ contained containedin=pandocSimpleTable

syn region pandocTable start=/\%#=2^\(-\+\s*\)\+\n\n\@!/ end=/\%#=2^\(-\+\s*\)\+\n\n/ containedin=ALLBUT,pandocDelimitedCodeBlock,pandocYAMLHeader keepend
syn match pandocTableDelims /\-/ contained containedin=pandocTable
syn region pandocTableMultilineHeader start=/\%#=2\(^-\+\n\)\@<=./ end=/\%#=2\n-\@=/ contained containedin=pandocTable

" }}}3
" Grid: {{{3
syn region pandocGridTable start=/\%#=2\n\@1<=+-/ end=/+\n\n/ containedin=ALLBUT,pandocDelimitedCodeBlock,pandocYAMLHeader keepend
syn match pandocGridTableDelims /[\|=]/ contained containedin=pandocGridTable
syn match pandocGridTableDelims /\%#=2\([\-+][\-+=]\@=\|[\-+=]\@1<=[\-+]\)/ contained containedin=pandocGridTable
syn match pandocGridTableHeader /\%#=2\(^.*\n\)\(+=.*\)\@=/ contained containedin=pandocGridTable 
"}}}3
" Pipe: {{{3
" with beginning and end pipes
syn region pandocPipeTable start=/\%#=2\([+|]\n\)\@<!\n\@1<=|\(.*|\)\@=/ end=/|.*\n\n/ containedin=ALLBUT,pandocDelimitedCodeBlock,pandocYAMLHeader keepend 
" without beginning and end pipes
syn region pandocPipeTable start=/\%#=2^.*\n-.\{-}|/ end=/|.*\n\n/ keepend
syn match pandocPipeTableDelims /[\|\-:+]/ contained containedin=pandocPipeTable
syn match pandocPipeTableHeader /\(^.*\n\)\(|-\)\@=/ contained containedin=pandocPipeTable
syn match pandocPipeTableHeader /\(^.*\n\)\(-\)\@=/ contained containedin=pandocPipeTable
" }}}3
syn match pandocTableHeaderWord /\<.\{-}\>/ contained containedin=pandocGridTableHeader,pandocPipeTableHeader
" }}}2
" Delimited Code Blocks: {{{2
" this is here because we can override strikeouts and subscripts
syn region pandocDelimitedCodeBlock start=/^\(>\s\)\?\z(\(\s\{4,}\)\=\~\{3,}\~*\)/ end=/^\z1\~*/ skipnl contains=pandocDelimitedCodeBlockStart,pandocDelimitedCodeBlockEnd keepend
syn region pandocDelimitedCodeBlock start=/^\(>\s\)\?\z(\(\s\{4,}\)\=`\{3,}`*\)/ end=/^\z1`*/ skipnl contains=pandocDelimitedCodeBlockStart,pandocDelimitedCodeBlockEnd keepend
call s:WithConceal("codeblock_start", 'syn match pandocDelimitedCodeBlockStart /\(\_^\n\_^\(>\s\)\?\(\s\{4,}\)\=\)\@<=\(\~\{3,}\~*\|`\{3,}`*\)/ contained containedin=pandocDelimitedCodeBlock nextgroup=pandocDelimitedCodeBlockLanguage', 'conceal cchar='.s:cchars["codelang"])
syn match pandocDelimitedCodeBlockLanguage /\(\s\?\)\@<=.\+\(\_$\)\@=/ contained 
call s:WithConceal("codeblock_delim", 'syn match pandocDelimitedCodeBlockEnd /\(`\{3,}`*\|\~\{3,}\~*\)\(\_$\n\(>\s\)\?\_$\)\@=/ contained containedin=pandocDelimitedCodeBlock', 'conceal')
syn match pandocBlockQuoteinDelimitedCodeBlock '^>' contained containedin=pandocDelimitedCodeBlock
syn match pandocCodePre /<pre>.\{-}<\/pre>/ skipnl
syn match pandocCodePre /<code>.\{-}<\/code>/ skipnl

" enable highlighting for embedded region in codeblocks if there exists a
" g:pandoc#syntax#codeblocks#embeds#langs *list*.
"
" entries in this list are the language code interpreted by pandoc,
" if this differs from the name of the vim syntax file, append =vimname
" e.g. let g:pandoc#syntax#codeblocks#embeds#langs = ["haskell", "literatehaskell=lhaskell"]
"
if g:pandoc#syntax#codeblocks#embeds#use != 0
    for l in g:pandoc#syntax#codeblocks#embeds#langs
      call EnableEmbedsforCodeblocksWithLang(l)
    endfor
endif
" }}}
" Abbreviations: {{{2
syn region pandocAbbreviationDefinition start=/^\*\[.\{-}\]:\s*/ end="$" contains=pandocNoFormatted,@Spell
call s:WithConceal('abbrev', 'syn match pandocAbbreviationSeparator /:/ contained containedin=pandocAbbreviationDefinition', "conceal cchar=".s:cchars["abbrev"])
syn match pandocAbbreviation /\*\[.\{-}\]/ contained containedin=pandocAbbreviationDefinition
call s:WithConceal('abbrev', 'syn match pandocAbbreviationHead /\*\[/ contained containedin=pandocAbbreviation', "conceal")
call s:WithConceal('abbrev', 'syn match pandocAbbreviationTail /\]/ contained containedin=pandocAbbreviation', "conceal")
" }}}
" Footnotes: {{{2
" we put these here not to interfere with superscripts.
"
syn match pandocFootnoteID /\[\^[^\]]\+\]/ nextgroup=pandocFootnoteDef
"   Inline footnotes
syn region pandocFootnoteDef start=/\^\[/ end=/\]/ contains=pandocReferenceLabel,pandocReferenceURL,pandocLatex,pandocPCite,,pandocEnDash,pandocEmDash,pandocEllipses,pandocBeginQuote,pandocEndQuote,@Spell skipnl keepend 
call s:WithConceal("footnote", 'syn match pandocFootnoteDefHead /\^\[/ contained containedin=pandocFootnoteDef', 'conceal cchar='.s:cchars["footnote"])
call s:WithConceal("footnote", 'syn match pandocFootnoteDefTail /\]/ contained containedin=pandocFootnoteDef', 'conceal')

" regular footnotes
syn region pandocFootnoteBlock start=/\[\^.\{-}\]:\s*\n*/ end=/^\n^\s\@!/ contains=pandocReferenceLabel,pandocReferenceURL,pandocLatex,pandocPCite,pandocCiteKey,pandocStrong,pandocEmphasis,pandocNoFormatted,pandocSuperscript,pandocSubscript,pandocStrikeout,pandocEnDash,pandocEmDash,pandocNewLine,pandocStrongEmphasis,pandocEllipses,pandocBeginQuote,pandocEndQuote,@Spell skipnl
syn match pandocFootnoteBlockSeparator /:/ contained containedin=pandocFootnoteBlock
syn match pandocFootnoteID /\[\^.\{-}\]/ contained containedin=pandocFootnoteBlock
call s:WithConceal("footnote", 'syn match pandocFootnoteIDHead /\[\^/ contained containedin=pandocFootnoteID', 'conceal cchar='.s:cchars["footnote"])
call s:WithConceal("footnote", 'syn match pandocFootnoteIDTail /\]/ contained containedin=pandocFootnoteID', 'conceal')
" }}}
" List Items: {{{2
"
" Unordered lists
syn match pandocUListItem /^>\=\s*[*+-]\s\+-\@!.*$/ nextgroup=pandocUListItem,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocDelimitedCodeBlock,pandocListItemContinuation contains=@Spell,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocStrongEmphasis,pandocStrongEmphasis,pandocPCite,pandocICite,pandocCiteKey,pandocReferenceLabel,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocReferenceURL,pandocAutomaticLink skipempty display
call s:WithConceal('list', 'syn match pandocUListItemBullet /^>\=\s*\zs[*+-]/ contained containedin=pandocUListItem', 'conceal cchar='.s:cchars['li'])

" Ordered lists
syn match pandocListItem /^\s*(\?\(\d\+\|\l\|\#\|@\)[.)].*$/ nextgroup=pandocListItem,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocDelimitedCodeBlock,pandocListItemContinuation contains=@Spell,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocStrongEmphasis,pandocStrongEmphasis,pandocPCite,pandocICite,pandocCiteKey,pandocReferenceLabel,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocAutomaticLink skipempty display 
" support for roman numerals up to 'c'
if g:pandoc#syntax#roman_lists != 0
    syn match pandocListItem /^\s*(\?x\=l\=\(i\{,3}[vx]\=\)\{,3}c\{,3}[.)].*$/ nextgroup=pandocListItem,pandocMathBlock,pandocLaTeXInlineMath,pandocDelimitedCodeBlock,pandocListItemContinuation,pandocAutomaticLink skipempty display 
endif
syn match pandocListItemBullet /^(\?.\{-}[.)]/ contained containedin=pandocListItem
syn match pandocListItemBulletId /\(\d\+\|\l\|\#\|@.\{-}\|x\=l\=\(i\{,3}[vx]\=\)\{,3}c\{,3}\)/ contained containedin=pandocListItemBullet

syn match pandocListItemContinuation /^\s\+\([-+*]\s\+\|(\?.\+[).]\)\@<!\([[:alpha:]ñäëïöüáéíóúàèìòùłßÄËÏÖÜÁÉÍÓÚÀÈÌÒÙŁß_"[]\|\*\S\)\@=.*$/ nextgroup=pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocDelimitedCodeBlock,pandocListItemContinuation,pandocListItem contains=@Spell,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocStrongEmphasis,pandocStrongEmphasis,pandocPCite,pandocICite,pandocCiteKey,pandocReferenceLabel,pandocReferenceURL,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocAutomaticLink contained skipempty display 
" }}}
" Definitions: {{{2
"
syn region pndocDefinitionBlock start=/^\%(\_^\s*\([`~]\)\1\{2,}\)\@!.*\n\(^\s*\n\)\=\s\{0,2}[:~]\(\~\{2,}\~*\)\@!/ skip=/\n\n\zs\s/ end=/\n\n/ contains=pandocDefinitionBlockMark,pandocDefinitionBlockTerm,pandocCodeBlockInsideIndent,pandocEmphasis,pandocStrong,pandocStrongEmphasis,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocFootnoteID,pandocReferenceURL,pandocReferenceLabel,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocAutomaticLink,pandocEmDash,pandocEnDash
syn match pandocDefinitionBlockTerm /^.*\n\(^\s*\n\)\=\(\s*[:~]\)\@=/ contained contains=pandocNoFormatted,pandocEmphasis,pandocStrong nextgroup=pandocDefinitionBlockMark
call s:WithConceal("definition", 'syn match pandocDefinitionBlockMark /^\s*[:~]/ contained', 'conceal cchar='.s:cchars["definition"])
" }}}
" Special: {{{2

" New_lines: {{{3
if g:pandoc#syntax#newlines == 1
    call s:WithConceal("newline", 'syn match pandocNewLine /\(  \|\\\)$/ display containedin=pandocEmphasis,pandocStrong,pandocStrongEmphasis,pandocStrongInEmphasis,pandocEmphasisInStrong', 'conceal cchar='.s:cchars["newline"])
endif
"}}}
" Ellipses: {{{3
if &encoding == "utf-8"
    call s:WithConceal("ellipses", 'syn match pandocEllipses /\.\.\./ display', 'conceal cchar=…')
endif
" }}}
" Quotes: {{{3
if &encoding == "utf-8"
    call s:WithConceal("quotes", 'syn match pandocBeginQuote /"\</  containedin=pandocEmphasis,pandocStrong,pandocListItem,pandocListItemContinuation,pandocUListItem display', 'conceal cchar=“')
    call s:WithConceal("quotes", 'syn match pandocEndQuote /\(\>[[:punct:]]*\)\@<="[[:blank:][:punct:]\n]\@=/  containedin=pandocEmphasis,pandocStrong,pandocUListItem,pandocListItem,pandocListItemContinuation display', 'conceal cchar=”')
endif
" Hrule: {{{3
syn match pandocHRule /^\s*\([*\-_]\)\s*\%(\1\s*\)\{2,}$/ display
" Backslashes: {{{3
if g:pandoc#syntax#conceal#backslash == 1
    syn match pandocBackslash /\\\@<!\\/ containedin=ALLBUT,pandocCodeblock,pandocCodeBlockInsideIndent,pandocNoFormatted,pandocNoFormattedInEmphasis,pandocNoFormattedInStrong,pandocDelimitedCodeBlock,pandocLineBlock,pandocYAMLHeader conceal
endif
" }}}
" }}}
" YAML: {{{2

try
    unlet! b:current_syntax
    syn include @YAML syntax/yaml.vim
catch /E484/
endtry
syn region pandocYAMLHeader start=/\%(\%^\|\_^\s*\n\)\@<=\_^-\{3}\ze\n.\+/ end=/^\([-.]\)\1\{2}$/ keepend contains=@YAML containedin=TOP
"}}}
"}}}1

" Styling: {{{1
" override this for consistency
hi pandocTitleBlock term=italic gui=italic
hi link pandocTitleBlockTitle Directory
hi link pandocAtxHeader Title
hi link pandocAtxStart Operator
hi link pandocSetexHeader Title
hi link pandocHeaderAttr Comment
hi link pandocHeaderID Identifier

hi link pandocLaTexSectionCmd texSection
hi link pandocLaTeXDelimiter texDelimiter

hi link pandocHTMLComment Comment
hi link pandocHTMLCommentStart Delimiter
hi link pandocHTMLCommentEnd Delimiter
hi link pandocBlockQuote Comment
hi link pandocBlockQuoteMark Comment

" if the user sets g:pandoc#syntax#codeblocks#ignore to contain
" a codeblock type, don't highlight it so that it remains Normal

if index(g:pandoc#syntax#codeblocks#ignore, 'definition') == -1
  hi link pandocCodeBlockInsideIndent String
endif

if index(g:pandoc#syntax#codeblocks#ignore, 'delimited') == -1
  hi link pandocDelimitedCodeBlock Special
endif

hi link pandocDelimitedCodeBlockStart Delimiter
hi link pandocDelimitedCodeBlockEnd Delimiter
hi link pandocDelimitedCodeBlockLanguage Comment
hi link pandocBlockQuoteinDelimitedCodeBlock pandocBlockQuote
hi link pandocCodePre String

hi link pandocLineBlockDelimiter Delimiter

hi link pandocListItemBullet Operator
hi link pandocUListItemBullet Operator
hi link pandocListItemBulletId Identifier

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

hi link pandocSimpleTableDelims Delimiter
hi link pandocSimpleTableHeader pandocStrong
hi link pandocTableMultilineHeader pandocStrong
hi link pandocTableDelims Delimiter
hi link pandocGridTableDelims Delimiter
hi link pandocGridTableHeader Delimiter
hi link pandocPipeTableDelims Delimiter
hi link pandocPipeTableHeader Delimiter
hi link pandocTableHeaderWord pandocStrong

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

hi link pandocPCite Normal
hi link pandocICite Normal
hi link pandocCiteKey Identifier
hi link pandocCiteAnchor Operator
hi link pandocCiteLocator Operator

if g:pandoc#syntax#style#emphases == 1
    hi pandocEmphasis gui=italic cterm=italic
    hi pandocStrong gui=bold cterm=bold
    hi pandocStrongEmphasis gui=bold,italic cterm=bold,italic
    hi pandocStrongInEmphasis gui=bold,italic cterm=bold,italic
    hi pandocEmphasisInStrong gui=bold,italic cterm=bold,italic
    if !exists('s:hi_tail')
        for s:i in ["fg", "bg"]
            let s:tmp_val = synIDattr(synIDtrans(hlID("String")), s:i)
            let s:tmp_ui =  has('gui_running') ? 'gui' : 'cterm'
            if !empty(s:tmp_val) && s:tmp_val != -1
                exe 'let s:'.s:i . ' = "'.s:tmp_ui.s:i.'='.s:tmp_val.'"'
            else
                exe 'let s:'.s:i . ' = ""'
            endif
        endfor
        let s:hi_tail = ' '.s:fg.' '.s:bg
    endif
    exe 'hi pandocNoFormattedInEmphasis gui=italic cterm=italic'.s:hi_tail
    exe 'hi pandocNoFormattedInStrong gui=bold cterm=bold'.s:hi_tail
endif
hi link pandocNoFormatted String
hi link pandocNoFormattedAttrs Comment
hi link pandocSubscriptMark Operator
hi link pandocSuperscriptMark Operator
hi link pandocStrikeoutMark Operator
if g:pandoc#syntax#style#underline_special == 1
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
