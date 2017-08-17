.. post:: Jun 22, 2017
   :tags: vim, nvim, python
   :category: Talk
   :location: Vimfest Berlin
   :excerpt: 2

Writing NeoVim Plugins using Python Plugin API
==============================================

This talk will be held at `Vimfest`_ 2017 in Berlin. I'll show how to write plugins for Nvim using
the new `Python Plugin API`_. The API is async and wraps the new `msgpack`_. The API is called
"Remote Plugin API".

As an example I will use my first plugin `neotags`_.

What's the difference?
----------------------

All you have to do, except setting up the environment, is to write a single Python file and place it
:file:`rplugin/python3/file.py`.  Afterwards run ``:UpdateRemotePlugins`` from within Nvim once, to
generate the necessary Vimscript to make your Plugin available.

Example of generated :file:`~/.local/share/nvim/rplugin.vim`:

.. code-block:: vim

    " python3 plugins
    call remote#host#RegisterPlugin('python3', '/Users/siepmann/.dotfiles/.vim/bundle/neotags/rplugin/python3/neotags.py', [
        \ {'sync': v:false, 'name': 'BufWritePost', 'type': 'autocmd', 'opts': {'pattern': '*', 'eval': 'expand("<afile>:p")'}},
        \ ])

There is no need to write any Vimscript, you can fully stick to your preferred language. Beside
Python also Ruby is supported via `Ruby Plugin API`_.

For full Nvim documentation on the remote plugin API, take a look at the official docs at
https://neovim.io/doc/user/remote_plugin.html.

Most communication is async by default.

Setting up the environment
--------------------------

#. Install Neovim

#. Install Python3

#. Install Python3 Neovim module

.. code-block:: bash

    pip3 install --upgrade neovim

First example
-------------

.. code-block:: python
   :linenos:

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

How to test your plugin
-----------------------

Of course you can add Unittests to test the code. But vim and nvim can be started with the ``-c``
option. This will execute the provided command, e.g. calling you plugin, so for above example:

.. code-block:: bash

   rm tags; nvim someCodeFile -c ':w'

This will first delete a generated tags file and open a file with code inside neovim and save it,
triggering our auto command.

Executing Nvim functions
------------------------

Just use the API:

.. code-block:: python

   self.nvim.funcs.execute('pwd')

The neovim instance has a instance of ``Funcs`` which will pass the method name as function call to
nvim. This way all nvim functions are available.

Getting options from Nvim
-------------------------

Beside functions the nvim instance provides ``vars`` as an array containing all existing variables and options.

.. code-block:: python

   self.nvim.vars.['neotags_logging']

This will return the ``let g:neotags_logging`` value.

The API is documented through code and `https://neovim.io/doc/user/api.html#nvim_get_var() <https://neovim.io/doc/user/api.html#nvim_get_var()>`_.

Defining functions and commands
-------------------------------

You can define functions and commands the same way as autocommands. Examples are provided in the
official docs at `https://neovim.io/doc/user/remote_plugin.html#remote-plugin-example
<https://neovim.io/doc/user/remote_plugin.html#remote-plugin-example>`_.

Further reading
---------------

Thanks to the implementation of Nvim it's possible to create plugins in every single language. Just
one has to provide a wrapper around the `msgpack`_ to allow communication with Nvim.

- `Vimfest`_ 2017

- `Python Plugin API`_ repository and docs.

- `Ruby Plugin API`_ repository and docs.

- `neotags`_ the Nvim plugin written in Python3, covered with Unittests.

.. _Vimfest: https://vimfest.de/
.. _Python Plugin API: https://github.com/neovim/python-client#python-client-to-neovim
.. _msgpack: https://msgpack.org/
.. _neotags: https://gitlab.com/DanielSiepmann/neotags
.. _Ruby Plugin API: https://github.com/alexgenco/neovim-ruby
