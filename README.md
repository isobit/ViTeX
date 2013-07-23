ViTeX
=====

A LaTeX-groking comment assistant plugin for Vim.

Intro
-----

ViTeX makes it easier to add pretty comment structures while programming. 
Blocks, sections, titles, etc, call all be added with a simple keystroke!

Current features:
  * Customizable comment structure characters and widths.
  * Automagic filetype-based commenting.

Installation
------------
1) Make sure you have Pathogen installed (https://github.com/tpope/vim-pathogen)

2) Copy plugin/ViTex.vim to your .vim/plugins folder. That's it!

Usage
-----

Note: For maximum LaTeX-groking, a leader of '\' is recommended.
####Insert Mode Commands:

 * \<Leader\>block
```
#=============================
# Comment
#=============================
```

 * \<Leader\>sec
```
#=== Comment ===========
```
