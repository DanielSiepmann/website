.. post:: Jun 22, 2017
   :tags: vim, python
   :category: Talk
   :location: Vimfest Berlin
   :excerpt: 2

Writing NeoVim Plugins using Python Plugin API
==============================================

This talk will be held at `Vimfest`_ 2017 in Berlin. I'll show how to write plugins for Nvim using
the new `Python Plugin API`_. Beside that how to write UnitTests for Python3 and how to execute them
on `Gitlab`_ CI via Docker.

As an example I will use my first plugin `neotags`_.

What's the difference?
----------------------

All you have to do is to write a single Python file and place it :file:`rplugin/python3/file.py`.
Afterwards run ``:UpdateRemotePlugins`` from within Nvim once, to generate the necessary Vimscript
to make your Plugin available.

There is no need to write any Vimscript, you can fully stick to your preferred language. Beside
Python also Ruby is supported via `Ruby Plugin API`_.

For full Nvim documentation on the remote plugin API, take a look at the official docs at
https://neovim.io/doc/user/remote_plugin.html.

Most communication is asynchron by default.

First example
-------------

.. code-block:: python

   import neovim

   @neovim.plugin
   class NeotagsPlugin(object):

       def __init__(self, nvim):
           self.nvim = nvim

       @neovim.autocmd('BufWritePost', pattern='*', eval='expand("<afile>:p")')
       def update_tags_for_file(self, filename):
           self.nvim.out_write('neotags > ' + message + "\n")

First of all you have to import the ``neovim`` module to get access to the API. This will also
import decorators for classes and methods.

By decorating the class as a plugin, it will become a plugin.

By decorating a method as ``autocmd`` it will be registered as an auto command.

In our above example all writes to files will trigger our python method and display the file name as
a message inside Nvim.

To have access to the current Nvim instance, we keep a relation to the instance when we receive it
in the constructor.

Executing Nvim functions
------------------------

Getting options from Nvim
-------------------------

Adding Unit tests
-----------------

Integration into Gitlab CI
--------------------------

Further reading
---------------

Thanks to the implementation of Nvim it's possible to create plugins in every single language. Just
one has to provide a wrapper around the `msgpack`_ to allow communication with Nvim.

.. _Vimfest: https://vimfest.de/
.. _Python Plugin API: https://github.com/jacobsimpson/nvim-example-python-plugin
.. _Gitlab: https://gitlab.com/
.. _msgpack: https://msgpack.org/
.. _neotags: https://gitlab.com/DanielSiepmann/neotags
.. _Ruby Plugin API: https://github.com/alexgenco/neovim-ruby
