.. highlight:: vim

.. post::
   :tags: vim
   :category: Talk
   :location: Vimfest Berlin
   :excerpt: 1

.. _my-vim-setup:

My Vim Setup
============

This talk will be held at `Vimfest`_ 2016 in Berlin. I'll show my current `Vim`_ setup like Plugins,
Configuration options and structure. Also I'm trying to show the Vim features I'm using on a daily
basis.

In general I try to keep my setup as smart as possible to have best experience. Following the
principle:

    As much as necessary, as less as possible

In other words, I'm a purist.

Principles for choosing Vim
---------------------------

And here are the reasons I'm using Vim instead of any other editor:

Vim grammar
    No other editor has a grammar which is so powerful: ``[operator][count][motion]``.

Mode based
    Yes also other editors are mode based. I don't like the CTRL+ALT+. stuff. In Germany we
    call the typical Windows shortcut CTRL+ALT+DEL the "Affengriff".

Easy to remember shortcuts
    Most parts are easy to remember.

Most features can be combined with others
    Learning one new feature will be exponential useful as you can combine it with other already
    known features.

Features used on a daily basis
------------------------------

* Folding

* Autocompletion / Spelling correction

* Jumps / Tags

* Plugins

Features I definitely need to use more often
--------------------------------------------

* Quickfix

* Locationlist

* Spelling correction while in insert mode

* Jumps, even while already using them, there is so much more potential

* Motions, same as with jumps, see ``:h various-motions``

Plugins in use
--------------

=========================== =========== ======
Pluginname                  Usage       Reason
=========================== =========== ======
ctrlp.vim                   Daily       Faster file and buffer navigation.
nerdtree                    Daily       To browse file system.
php-getter-setter.vim       Rarely      To generate getter and setter from PHP instance variable.
php.vim                     Daily       To provide more up to date PHP Support like keyword in syntax file.
plantuml-syntax             Rarely      PlantUML Syntax support.
syntastic                   Daily       Linting of files like PHP, JS, HTML, rst, Python, Ruby, Bash, ...
tagbar                      Daily       Generate outline of code like class, methods, variables of current file.
tlib_vim                    (Lib)
undotree                    Weekly      Provide visual representation of Vim built in feature.
vdebug                      Weekly      Allow debugging through GDB like xdebug for PHP.
vim-addon-mw-utils          (Lib)
vim-commentary              Daily       Easier comment or uncomment parts of code.
vim-fugitive                Weekly      Git support inside of Vim.
vim-indent-object           Rarely      Text objects based on indentation.
vim-misc                    (Lib)
vim-repeat                  (Lib)
vim-signature               Daily       Display set marks beside line.
vim-snipmate                Daily       Snippet management.
vim-surround                Rarely      Allows to surround parts via text objects.
vim-textobj-comment         Weekly      Text objects based on comments.
vim-textobj-user            Dependency
=========================== =========== ======

24 plugins in total

Tagbar is used in combination with `universal ctags`_.

ctrlp is used in combination with `the silver searcher`_.

Configuration options
---------------------

I've tried to split my configuration up, in a nice structure.
Still vimrc has 126 lines.

The configuration is done in the following structure and included via vims ``runtime!``::

    " Trigger pathogen to autoload plugins
        execute pathogen#infect()
        call pathogen#helptags()

    " Include further plugins
        " Add manpage command (:Man) and highlighting!
        runtime! ftplugin/man.vim

    " Load further configurations
        " Load general configurations
        runtime! configs/*.vim
        " Load autocommands
        runtime! configs/autocommands/*.vim
        " Load plugin configurations
        runtime! configs/plugins/*.vim
        " Load path specific configuration to override everything else
        runtime! configs/folderspecific/*.vim
        " Load at last, as this are modes like "day" or "present" which will
        " overwrite all existing configuration
        runtime! configs/modes/*.vim

The structure is the following:

.. code-block:: text

    /Users/siepmann/.vim/configs
    ├── autocommands
    │   ├── apache.vim
    │   ├── basics.vim
    │   ├── rst.vim
    │   ├── typo3.vim
    │   ├── vdebug.vim
    │   └── vim.vim
    ├── folderspecific
    │   ├── digital-competence.vim
    │   ├── nodejs.vim
    │   └── sphinx.vim
    ├── functions.vim
    ├── grepping.vim
    ├── indentation.vim
    ├── mappings.vim
    ├── modes
    │   └── present.vim
    ├── plugins
    │   ├── ctrlp.vim
    │   ├── easytags.vim
    │   ├── nerdtree.vim
    │   ├── php-getter-setters.vim
    │   ├── plantuml.vim
    │   ├── syntastic.vim
    │   ├── tagbar.vim
    │   ├── undotree.vim
    │   └── vdebug.vim
    ├── searching.vim
    ├── statusline.vim
    └── wildignore.vim

    4 directories, 26 files

That's in addition to vims builtin structure:

.. code-block:: text

    /Users/siepmann/.vim/
    ├── after
    │   └── ...
    ├── autoload
    │   └── ...
    ├── colors
    │   └── ...
    ├── ftdetect
    │   └── ...
    ├── spell
    │   └── ...
    └── syntax
        └── ...

    258 directories, 678 files

Settings
--------

* Keep UI to a minimum, no cursorline, no numbers.

* Use indentation for folding, as it will work in nearly all cases.

* Highlight todos and trailing whitespace using ``match``.

* Configure grepping through variable for adjustmends based on folderspecific, see
  ~/.dotfiles/.vim/configs/folderspecific/sphinx.vim and ~/.dotfiles/.vim/configs/grepping.vim

* Use vim to clear caches during development, see
  ~/.dotfiles/.vim/configs/autocommands/typo3.vim

* Or restart apache webserver, see
  ~/.dotfiles/.vim/configs/autocommands/apache.vim

* Also helpfull are some functions, see
  ~/.dotfiles/.vim/configs/functions.vim

Further reading
---------------

.. _Vimfest: http://vimfest.de/
.. _Vim: http://www.vim.org/
.. _universal ctags: https://ctags.io/
.. _the silver searcher: 
