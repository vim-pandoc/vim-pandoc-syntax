# vim-pandoc-syntax

[![Vint](https://github.com/vim-pandoc/vim-pandoc-syntax/workflows/Vint/badge.svg)](https://github.com/vim-pandoc/vim-pandoc-syntax/actions?workflow=Vint)

Standalone pandoc syntax module, to be used alongside
[vim-pandoc](http://github.com/vim-pandoc/vim-pandoc).

Forked from the version provided by `fmoralesc/vim-pantondoc`, in turn taken
from `vim-pandoc/vim-pandoc`.

## Requirements

* A vim version with `+conceal`
* [vim-pandoc](http://github.com/vim-pandoc/vim-pandoc), to set the
  `pandoc` filetype (otherwise you'll have to set it up yourself).

## Installation

The repository follows the usual bundle structure, so it's easy to install it
using [pathogen](https://github.com/tpope/vim-pathogen),
[Vundle](https://github.com/gmarik/vundle) or NeoBundle.

For Vundle users, it should be enough to add

    Plugin 'vim-pandoc/vim-pandoc-syntax'

to `.vimrc`, and then run `:PluginInstall`.

For those who need it, a tarball is available from
[here](https://github.com/vim-pandoc/vim-pandoc-syntax/archive/master.zip).

### Standalone

If you want to use `vim-pandoc-syntax` without vim-pandoc, you'll need to tell
Vim to load it for certain files. Just add something like this to your vimrc:

~~~ vim
    augroup pandoc_syntax
        au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
    augroup END
~~~

## Features

* Supports most (if not all) pandoc's markdown features, including tables,
  delimited codeblocks, references, etc.
* Can handle multiple embedded languages (LaTeX, YAML headers, many languages
  in delimited codeblocks). Some commands are provided to help with this (see
  `:help pandoc-syntax-commands`)
* Pretty display using `conceal` (optional).
* Configurable (see `:help pandoc-syntax-configuration` for an overview of the
  options).

## Screenshots

![img1](http://i.imgur.com/UKXbG2V.png)
![img2](http://i.imgur.com/z8FpxRP.png)
![img3](http://i.imgur.com/ziNjQiE.png)
![img4](http://i.imgur.com/UKoOxzP.png)
