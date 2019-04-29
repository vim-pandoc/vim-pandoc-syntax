let g:vim_pandoc_syntax_exists = 1

au BufNewFile,BufRead,BufFilePost *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md 
                    \ let b:current_syntax = "markdown"
