.. post::
   :tags: vim
   :category: Talk
   :location: Never Code Alone Check 24
   :excerpt: 1

.. _vim-advanced-nevercodealone-check24:

VIM Advanced - Talk bei NeverCodeAlone Check 24 Köln
====================================================

Vorteile von Vim
----------------

* Extrem individualisierbar.

* Auf nahezu jedem Rechner und Server verfügbar.

Voreile von neovim
^^^^^^^^^^^^^^^^^^

* Integriertes Terminal

* Tolle Plugin API

* Schnellere Entwicklung von Plugins

Wofür kann man Vim sinnvoll nutzen?
-----------------------------------

Zum schreiben erstellen und lesen von:

  * Code

  * Dokumentation

  * Konzepte / Texte

Neovim kann auch in scripten (bash, python, ...) genutzt werden.

Wie lernt man Vim?
------------------

* `Vimtutor <https://neovim.io/doc/user/usr_01.html#vimtutor>`_, für einen ersten Eindruck und Navigation.

* Learning by doing, wie eigentlich alles.

* Lesen der `enthaltenen Dokumentation <https://neovim.io/doc/user/index.html>`_, sowie des Buchs `Practical Vim <https://pragprog.com/book/dnvim2/practical-vim-second-edition>`_.

* Vim Grammar ``[operator][count][motion]``.

Die Praxis
----------

Eingebaute Hilfe
^^^^^^^^^^^^^^^^

Online: https://neovim.io/doc/user/index.html

Integriert erreichbar mit:

.. code-block:: vim

   :help

   :helpgrep <word>

Starten und beenden von Vim
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   # Bearbeiten einer oder mehrerer Dateien
   vim <filename>

   # Bearbeiten von stdin
   git help | vim -

   # Starten mit Vim commands
   vim -c ':Man git'

   # Bearbeiten von Remote Dateien
   vim protocol:///

Die `interne Dokumentation <https://neovim.io/doc/user/pi_netrw.html#netrw-externapp>`_ zu remote Protokollen.

Beenden von Vim:

.. code-block:: vim

    CTRL-C

    :q

Code schreiben
^^^^^^^^^^^^^^

In "Insert mode" wechseln mittels: ``o`` ``O`` ``i`` ``I`` ``a`` ``A``

Hilfreiche Cheatsheets:

* https://cdn.shopify.com/s/files/1/0165/4168/files/preview.png

* https://rawgit.com/darcyparker/1886716/raw/eab57dfe784f016085251771d65a75a471ca22d4/vimModeStateDiagram.svg

* http://talks.caktusgroup.com/lightning-talks/2015/vim-normal-mode/images/vim-cheat-sheet.gif

`Autocompletion dokumentation <https://neovim.io/doc/user/insert.html#ins-completion>`_

In Code navigieren
^^^^^^^^^^^^^^^^^^

* `Marks <https://neovim.io/doc/user/motion.html#mark-motions>`_

* `Tags <https://neovim.io/doc/user/usr_29.html#29.1>`_

* Go to tag: `CTRL-] <https://neovim.io/doc/user/tagsrch.html#CTRL-]>`_

  + Zur generierung empfehle ich: `universal ctags <https://ctags.io/>`_

* `Motions <https://neovim.io/doc/user/motion.html>`_

* `Folding <https://neovim.io/doc/user/fold.html>`_

Plugins
^^^^^^^

Es gibt unterschiedliche Pluginmnager, Anleitungen zur Insallation befinden sich auf `vimawesome.com
<https://vimawesome.com/>`_

* Plugins findet man auf `Github <https://github.com/search?q=language%3Aviml&type=Repositories&utf8=%E2%9C%93>`_ und `vimawesome.com <https://vimawesome.com/>`_

* Bekannte / hilfreiche Plugins:

  * `nerdtree <https://vimawesome.com/plugin/nerdtree-red>`_

  * `syntastic <https://vimawesome.com/plugin/syntastic>`_

  * `tagbar <https://vimawesome.com/plugin/tagbar>`_

  * `undotree <https://vimawesome.com/plugin/undotree-vim>`_

  * `vdebug <https://vimawesome.com/plugin/vdebug>`_

  * `vim-commentary <https://vimawesome.com/plugin/vim-commentary>`_

  * `vim-fugitive <https://vimawesome.com/plugin/fugitive-vim>`_

Vim individualisieren
^^^^^^^^^^^^^^^^^^^^^

* Basis Konfiguration:

.. code-block:: vim

    " Zeilennummern aktivieren
    set number
    " Zeilennummern de-aktivieren
    set nonumber

    " Relative Zeilennummern
    set relativenumber
    " Relative Zeilennummern aus
    set norelativenumber

    set cursorline
    set nocursorline

    " Statuszeile immer anzeigen, auch bei nur einem Buffer.
    set laststatus=2

    " Nicht in die erste Zeile springen wenn man Buffer wechselt.
    set nostartofline

    " Auch das Wörterbuch für autocompletion nutzen.
    set complete+=kspell

    " Allow syntax highlighting and other file / language specific things
    syntax enable
    " Activate filetype detection and auto indent
    filetype plugin indent on

    " Show command in bottom of the screen
    set showcmd
    set showmode
    " More useful command-line completion
    set wildmenu
    " Auto-completion menu
    set wildmode=longest,list:full

Meine Konfig Struktur
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

    ~/.vim
    ├── after
    │   └── ftplugin
    │       ├── dnsmasq.vim
    │       ├── gitcommit.vim
    │       ├── help.vim
    │       ├── ...
    │       └── yaml.vim
    ├── autoload
    │   └── pathogen.vim
    ├── colors
    │   ├── nice-blue-soda.vim
    │   └── twilight.vim
    ├── configs
    │   ├── autocommands
    │   │   ├── apache.vim
    │   │   ├── ...
    │   │   ├── typo3.vim
    │   │   └── vim.vim
    │   ├── folderspecific
    │   │   ├── ...
    │   │   └── spieleliste.vim
    │   ├── functions.vim
    │   ├── grepping.vim
    │   ├── indentation.vim
    │   ├── mappings.vim
    │   ├── modes
    │   │   └── present.vim
    │   ├── plugins
    │   │   ├── autotag.vim
    │   │   ├── ...
    │   │   └── vdebug.vim
    │   ├── searching.vim
    │   ├── statusline.vim
    │   ├── undo.vim
    │   └── wildignore.vim
    ├── ftdetect
    │   ├── ...
    │   └── xt.vim
    ├── init.vim -> ../.vimrc
    ├── snippets
    │   ├── typoscript.snippets
    │   ├── ...
    │   └── xml.snippets
    ├── spell
    │   └── ...
    ├── syntax
    │   ├── conf.vim
    │   ├── confluencewiki.vim
    │   ├── mediawiki.vim
    │   ├── php.vim
    │   └── typoscript.vim
    ├── syntax_checkers
    │   └── typoscript
    └── view

    18 Ordner, 108 Dateien
    (Ohne Plugins)

Default Editor definieren
-------------------------

Wird von anderen Programmen wie Git verwendet.

.. code-block:: bash

   export EDITOR='"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" -w'
   export EDITOR='vim'
   export EDITOR='nvim'
