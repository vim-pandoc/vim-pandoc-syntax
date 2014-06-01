# vim-pandoc-syntax

standalone pandoc syntax module.

forked from the version provided by `fmoralesc/vim-pantondoc`, in turn taken
from `vim-pandoc/vim-pandoc`.

compatible with vim versions having `+conceal`.

Filetype Detection and File Extensions
======================================

If you have this plugin installed alongside [vim-markdown][], be aware
that both plugins attempt to claim the common markdown extensions for
their own. We match the following extensions:

+    .markdown, .md, .mkd, .pd, .pdk, .pandoc, and .text

In our experience, vim-pandoc trumps vim-markdown.

We do not claim files with the `.txt` extension, since that would seem
a bit presumptuous. If you want `.txt` files to be treated as pandoc
files, add

    autocmd BufNewFile,BufRead *.txt   set filetype=pandoc

to your `.vimrc`.

[vim-markdown]: http://plasticboy.com/markdown-vim-mode/

## features

* supports most (if not all) pandoc's markdown features.
* can handle multiple embedded languages (LaTeX, YAML headers, many languages
  in delimited codeblocks). Some commands are provided to help with this (see
  `:help pandoc-syntax-commands`)
* pretty display using `conceal`.
* is configurable (see `:help pandoc-syntax-configuration`).
* includes tests, to ease development.

## obligatory screenshots

![img1](http://i.imgur.com/YBABRYw.png)
![img](http://i.imgur.com/QU7niN3.png)
