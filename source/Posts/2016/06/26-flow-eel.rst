.. highlight:: php

.. post:: Jun 26, 2016
   :tags: flow, eel, neos
   :excerpt: 2

.. _eel:

Flow's embedded expression language (Eel)
=========================================

`Flow`_ provides different packages, one is `Eel <https://github.com/neos/eel>`_ the embedded
expression language. A developer can use Eel to generate a `domain specific language`_, (=DSL).
`Neos`_, the CMS built upon Flow, uses Eel to parse parts of their TypoScript 2. Also I've heard of
one using Eel to generate QR-Codes.  Myself has used Eel like Vim auto command for filetype
detection. There is a wide range of use cases where Eel can be used.

In this blog post you get a short introduction into the basics to understand how and when to use
Eel.

.. _eel-simple-example:

A simple example
----------------

Given the following PHP Code:

.. literalinclude:: /Code/Flow/eel/Eel.php
   :linenos:
   :lines: 40, 50-61
   :dedent: 4

We have an expression inside ``$this->eelExpression`` and a method that will evaluate the
expression. The result is a boolean value indicating whether the PHP class can handle the given
file, based on the evaluated Eel expression.

.. _eel-grammar:

The grammar
-----------

Eel already comes with a defined grammar, which is documented as `plain text file
<https://github.com/neos/eel/blob/master/Documentation/FLOW3-Eel-Grammar.txt>`_ inside the package.

It will define things like Types, e.g. ``true`` and ``false``, and more complex object paths. Also
expressions like ``mystr ~= /Test/`` and ``myint + i < 42`` are already defined.

The grammar is nothing more then grammar, there are no defined methods or variables out of the box,
like used in the above example ``String.substr()``.

In the above example we already make use of the grammar by combining some conditions using ``&&``
and comparing things using ``==``.

.. _eel-context:

You need the context
--------------------

To enable the evaluation of an Eel expression you need to provide a context to the evaluator. The
expression will be evaluated inside this context.

The context allows you to define which expressions are available. As mentioned earlier, Eel ships
with a grammar. But to allow the above expression to be evaluated, we also need to define what
``file`` and ``file.fileExtension`` is. Also we need to define ``String.substr()``.

That's done with the following lines:

.. literalinclude:: /Code/Flow/eel/Eel.php
   :lines: 52-58
   :dedent: 8

Mainly the context is just a pure PHP array with key value pairs defining what's available inside
the expression during evaluation. In the above Example, we define ``file`` and ``lines``. ``file``
is of type ``Resource`` and provides all public methods of the object. Also ``lines`` is just an
array containing all lines of the given file.

``String`` is "special" in that case that it's a predefined ``EelHelper`` delivered as part of Eel.
All helpers are auto-documented at :ref:`neos:Eel Helpers Reference`.

Once you have defined the context, you are able to parse the expression, in that context.

.. _eel-parsing:

You can parse the expression
----------------------------

Parsing is as easy as calling a method with two arguments:

.. literalinclude:: /Code/Flow/eel/Eel.php
   :lines: 60
   :dedent: 8

The result of the evaluation depends on the expression. It can be of any type. In case of a boolean
expression like ``true != false`` the result is a boolean itself. In case of some string
manipulation like ``String.substr("Hello World!", 0, 4)`` it's a string.

The result depends on the expression and what you need. That's why a cast to boolean is done in the
above example, as the method has to return a boolean as defined by the interface in this example.

.. _eel-usages:

Further usages
--------------

Not always the result of the ``evaluate()`` method is what you need, but what you can do within the
expression.

As you can provide own classes via context, you can do whatever makes sense, e.g.  trigger methods
of a PHP class to put something into a queue, generate an image or something else.

It's up to the developer what to achieve with Eel. Eel is not, only, a template engine to parse a
string and replace some parts. It's a package to enable developers to create their own domain
specific language, wherever they need it.

Of course you can use Eel standalone outside of Neos and Flow. Just make sure to use
``InterpretedEvaluator`` as evaluator. Also note, he's not that good in performance, as mentioned in
his PHP class doc.

.. _eel-when-to-use:

When to use eel
---------------

As mentioned at the beginning, Eel enables you to define a DSL. So whenever you need a DSL you can
use Eel. Some examples were already given, especially in the section :ref:`eel-usages`.

So get fancy, start your inspiration and find use cases for Eel.

E.g. generate a new task runner like Grunt, rake, make, ... .
Or a new template engine? Parse files, generate something like PDFs.

Note that you define the context, what is available to the user is up to you, as you define the
domain specific language.

.. _eel-complete-example:

Complete example
----------------

Here comes one real world example where I've used Eel to ease work for developers.

The main idea is to parse a file that can be of any format like PHPUnit result, PHPLoc result,
checkstyle output from phpcs, and so on.
As each format is different, it should be possible to detect which parser should be used for the
file, just by knowing the file.

The software provides and interface defining that each parser has to implement the
``canHandle(Resource $file)`` method. All that is provided is the file, nothing more. The parser
itself should check whether he can parse the file.

Also a trait is provided by the software:

.. literalinclude:: /Code/Flow/eel/Eel.php

Each developer can now ``use`` this trait in his parser and inject the Eel expression using the
:file:`Objects.yaml`:

.. literalinclude:: /Code/Flow/eel/Objects.yaml

Instead of implementing the logic in his class, the developer now can configure the parsing
detection, using the domain specific language.

.. _eel-further-reading:

Further reading
---------------

The package itself can be found at `Github <https://github.com/neos/eel>`_.

Documentation is available at :ref:`flow:eel`. Also the `grammar
<https://github.com/neos/eel/blob/master/Documentation/FLOW3-Eel-Grammar.txt>`_ is already
documented. Same is true for the :ref:`neos:Eel Helpers Reference`.

.. _Flow: https://flowframework.readthedocs.io/
.. _Neos: https://www.neos.io/
.. _domain specific language: https://en.wikipedia.org/wiki/Domain-specific_language
