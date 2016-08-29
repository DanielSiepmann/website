.. post:: Sep 17, 2016
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

In general I try to keep my setup as smart as possible to have best experience. Following:

    As much as necessary, as less as possible

And here are the reasons I'm using Vim instead of any other editor:

Vim grammar
    No other editor has this grammar which is so powerful: ``[operator][count][motion]``

Modal based
    Yes also other editors are modal based, but I don't like the CTRL+ALT+. stuff. In Germany we
    call the typical Windows shortcut CTRL+ALT+DEL the "Affengriff"

Easy to remember shortcuts
    Most parts are easy to remember.

Most features can be combined with others
    Learning one new feature will be exponential useful as you can combine it with other already
    known features.

Features used on a daily basis
------------------------------

* Folding

* Autocompletion

* Jumps / Tags

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
VST                         Weekly      Provide folding for rst files like presentations.
ctrlp.vim                   Daily       Faster file and buffer navigation.
emmet-vim                   Rarely      To speed up HTML creation.
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
vim-mustache-handlebars     Rarely      Syntax for mustache template engine.
vim-pug                     Rarely      Syntax for another template engine.
vim-repeat                  (Lib)
vim-signature               Daily       Display set marks beside line.
vim-snipmate                Daily       Snippet management.
vim-surround                Rarely      Allows to surround parts via text objects.
vim-textobj-comment         Weekly      Text objects based on comments.
vim-textobj-user            Dependency
=========================== =========== ======

25 plugins in total

Configuration options
---------------------

Folder structure
----------------

Further reading
---------------

.. _Vimfest: http://vimfest.de/
.. _Vim: http://www.vim.org/
