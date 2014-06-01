# vim-pandoc-syntax

standalone pandoc syntax module.

forked from the version provided by `fmoralesc/vim-pantondoc`, in turn taken
from `vim-pandoc/vim-pandoc`.

compatible with vim versions having `+conceal`.

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
