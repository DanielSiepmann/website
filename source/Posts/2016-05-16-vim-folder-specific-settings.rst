.. post:: May 16, 2016
   :tags: vim

.. _folder_specific_settings_in_vim:

Folder specific settings in Vim
===============================

If you are like me, you have a structured filesystem for your different jobs. E.g. one for your own
projects, one for customers, one for learnings, etc.
This allows you to set specific options within Vim related to the projects or customers. E.g. if
typo3 uses tabs instead of spaces you can configure that for ``Projects/typo3/**``. And if you want
to ignore certain folders like ``build`` within Sphinx installations, but not within e.g. typo3
projects, you can do it like the following.

My structure looks like the following::

    ~/Projects
    ├── docker
    │   ├── jenkins
    │   ├── phpcs
    │   └── t3-sphinx
    ├── flow
    │   ├── Quickstart
    │   ├── docs
    │   ├── flow-development-collection
    │   └── tutorial
    ├── opensource
    │   └── PHP_CodeSniffer.wiki
    ├── own
    │   ├── sphinx
    │   └── website
    ├── typo3
    │   ├── docs
    │   ├── extensions
    │   └── tools
    └── work
        ├── one-company
        │   ├── customer
        │   ├── packages
        │   └── typo3-extensions
        └── one-customer
            ├── example_t3_extension
            └── example_t3_installation

Current structure of Vim configuration
--------------------------------------

First let me show you my setup of Vim configuration. The main goal is to keep all files small and
structure the settings. Therefore I've created a new folder :file:`configs` where further files
are used to group options, e.g. for mappings or plugins. The folder structure looks like:

.. code-block:: text
   :emphasize-lines: 7-25

    ~/.vim
    ├── after
    │   └── ftplugin
    ├── autoload
    ├── bundle
    ├── colors
    ├── configs
    |   ├── autocommands
    |   │   ├── apache.vim
    |   │   ├── basics.vim
    |   │   ├── typo3.vim
    |   │   ├── vdebug.vim
    |   │   └── vim.vim
    |   ├── folderspecific
    |   │   ├── one-customer.vim
    |   │   └── sphinx.vim
    |   └── plugins
    |       ├── ctrlp.vim
    |       ├── nerdtree.vim
    |       ├── php-getter-setters.vim
    |       ├── plantuml.vim
    |       ├── syntastic.vim
    |       ├── tagbar.vim
    |       ├── undotree.vim
    |       └── vdebug.vim
    ├── ftdetect
    ├── sessions
    ├── snippets
    ├── spell
    ├── syntax
    └── view

And the files are included from within my :file:`~/.vimrc`:

.. literalinclude:: /.dotfiles/.vim/init.vim
   :language: vim
   :lines: 107-115

This way I can place further configuration in the files and don't mess up my main :file:`~/.vimrc`.
The :file:`configs/folderspecific/*.vim` contains the configurations for specific folders. As
Projects are nothing more then folders in my setup, it can be as specific as for one projects, one
file or just one customer.

Example of specific configuration
---------------------------------

The setup for sphinx looks like :file:`~/.vim/configs/folderspecific/sphinx.vim`:

.. literalinclude:: /.dotfiles/.vim/configs/folderspecific/sphinx.vim
   :language: vim

This allows me to exclude the :file:`build` folder from *ctrlp* Plugin search. But just for the
matching folders.

And for a customer with PHP and PSR-2 it looks like :file:`~/.vim/configs/folderspecific/one-customer.vim`:

.. code-block:: vim

    " Special configuration for customer with PSR-2
    augroup customerwithpsr2
        autocmd!
        " Define PSR2 for PHP Code Sniffer as default
        autocmd BufRead,BufNewFile **/one-customer/* execute ":let g:syntastic_php_phpcs_args='--report=csv --standard=PSR2'"
    augroup END

Source
------

The hint to use ``autocmd`` was given on `Stackoverflow
<http://stackoverflow.com/questions/456792/vim-apply-settings-on-files-in-directory#answer-456846>`_.
There are also other ways, as often, like plugins or the built in ``exrc``. All of them are mentioned
on Stackoverflow.
