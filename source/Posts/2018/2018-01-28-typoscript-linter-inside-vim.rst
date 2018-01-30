.. highlight:: vim
.. post:: Jan 28, 2018
   :tags: typo3, development
   :excerpt: 2

.. _integrate_typoscript_linter_into_vim:

Integrate Typoscript linter into VIM
====================================

As more and more people like to lint their files, it's obvious that we also should lint our
Typoscript files in TYPO3 projects. Therefore Martin Helmich has created a Typoscript parser and
`Typoscript linter`_.

In this blog post you will learn how to integrate this linter into vim and neovim by using
`syntastic`_ as a plugin.

Install dependencies
--------------------

First of all you need *syntastic* to be installed properly, refer to their docs for installation
guideline.

Also you need to have the linter installed. We prefer `composer <https://getcomposer.org/>`_:

.. code-block:: bash

   composer require --dev helmich/typo3-typoscript-lint

That will install the linter package with all dependencies into your project. By default the binary
will be installed into :file:`vendor/bin/typoscript-lint`. But the concrete path depends on your
composer settings. Also it's possible to install the package globally.

Configure VIM
-------------

After all dependencies are installed, we need to add the ``syntax checker`` for Typoscript. The file
has to be located at :file:`syntax_checkers/typoscript/lint.vim` inside your runtimepath, e.g.
:file:`~/.vim/syntax_checkers/typoscript/lint.vim`.

The file has the following content:

.. literalinclude:: /Code/VIM/typoscript-syntax-checker.vim
   :lines: 12-

Also add the path to your installed executable, e.g. inside of :file:`~/.vimrc` like so::

    let g:syntastic_typoscript_lint_exec='./vendor/bin/typoscript-lint'

If you have installed the binary on a per project base with default paths. Otherwise adjust
accordingly. If your path is different on a project level, take a look at
:ref:`folder_specific_settings_in_vim`.

Further reading
---------------

- `syntastic`_

- `Typoscript linter`_

.. _syntastic: https://github.com/vim-syntastic/syntastic
.. _Typoscript linter: https://github.com/martin-helmich/typo3-typoscript-lint
