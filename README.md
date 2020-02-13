# Vim Syntax for Simplified Pandoc

[![Vint](https://github.com/rwxrob/vim-pandoc-syntax-simple/workflows/Vint/badge.svg)](https://github.com/rwxrob/vim-pandoc-syntax-simple/actions?workflow=Vint)

The `vim-pandoc-simple-syntax` standalone Pandoc syntax module is a fork from the [vim-pandoc/vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax):

* Corrects faults in highlighting and smart punctuation
* Adds opinionated color settings
* Removes many confusing default conceals
* Removes (and flags) common departures from Simplified Pandoc

## Requirements

* A vim version with `+conceal`
* [vim-pandoc](http://github.com/vim-pandoc/vim-pandoc), to set the
  `pandoc` filetype (otherwise you'll have to set it up yourself).

## Installation

Add something like the following to your `.vimrc` after installing the [`Plug`](https://github.com/junegunn/vim-plug) Vim package manager (all the others are rather dated and don't allow storing plugins separated):


```vim
call plug#begin('~/.vimplugins')
Plug 'vim-pandoc/vim-pandoc'
Plug 'rwxrob/vim-pandoc-syntax-simple'
call plug#end()
```

### Standalone

If you want to use `vim-pandoc-syntax` without vim-pandoc, you'll need to tell Vim to load it for certain files. Just add something like this to your vimrc:

```vim
augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
```

## Features

* Supports most (if not all) Pandoc's markdown features, including tables,
  delimited codeblocks, references, etc.

* Can handle multiple embedded languages (LaTeX, YAML headers, many languages in delimited codeblocks). Some commands are provided to help with this (see `:help pandoc-syntax-commands`)

* Pretty display using `conceal` (optional).

* Configurable (see `:help pandoc-syntax-configuration` for an overview of the options).

## TODO

* ***Remove*** conceal ligatures for section and lists.
* Add back screenshots (from imgur to keep plugin light).
* Correct syntax highlighting of Pandoc Tables.
* Integrated better defaults colors.
* Consider adding themes for better color customization.
* Add ellipsis smart punctuation from list context. 
* Correct en-dash and em-dash missing contexts.
* Other stuff ...
