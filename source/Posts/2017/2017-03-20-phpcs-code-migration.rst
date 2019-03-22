.. _highlight: shell
.. post:: Mar 20, 2017
   :tags: phpcs, php, typo3
   :excerpt: 2

Using PHP_CodeSniffer for automated code migrations
===================================================

`PHP_CodeSniffer`_ is a command line tool allowing to check php, js and css. The main use case is to
check code styles like the popular `PSR-2`_. Beside checking coding styles, some communities are
already using this tool for further checks like direct access to global variables like ``$_POST``
instead of using the provided API, e.g. take a look at `Magento PHP_CodeSniffer Coding Standard`_.
Also there is a standard to check `compatibility of the code with PHP versions`_.

Beside this use cases and huge benefits, there is another use case: *automated code migrations* that
can be achieved using PHP_CodeSniffer. In this blog post I will provide the necessary basics and an
example how to auto migrate your PHP code using PHP_CodeSniffer.

The idea
--------

PHP_CodeSniffer already is able to parse PHP code. It can be used as a framework to check code
against any possible rule, as you can implement new rules using PHP.

Beside the check, it's also possible to use the cli tool ``phpcbf``, which comes with
PHP_CodeSniffer, to auto fix the found issues. This way we can provide own rules to find code that
needs migration and provide a fix for each occurrence.

As PHP_CodeSniffer already parses the source code for us, it's very easy to implement new rules and
fixes.

By providing an easy to use command line interface, we are able to include this migrations into
existing workflows like pre-commit hooks or continuous integrations. Also we can run them on our
local dev environments without complex installation instructions.

IDEs like `PHPStorm`_ and editors like `Vim`_ or `Sublime Text`_ already integrate PHP_CodeSniffer
directly, or through plugins, and make it easy to warn about outdated code while writing new code.
Also you can fix the issues from within your IDE / Editor. That makes PHP_CodeSniffer the perfect
tool for automated code migrations.

Benefits
--------

* Integration into IDE / Editor

* Automation on CLI through CVS hooks / continuous integrations

* Easy to use

* Easy to extend

* A lot of available examples

The basics
----------

PHP_CodeSniffer comes with two command line tools ``phpcs`` for "PHP_CodeSniffer" which will check
code against configured rules, and ``phpcbf`` for "PHP Code Beautifier and Fixer" which will adjust
the code accordingly.

To provide your own migration, you need a new "Coding Standard" that can be used with these tools.
Creating a new standard basically consists of creating a new folder, and a :file:`ruleset.xml` which
configures the standard. Also you can provide further *Sniffs*, which are PHP files including
further rules.  A "`Coding Standard Tutorial`_" can be found at github.

Afterwards you need to "install" your new standard to enable the cli tools to execute the standard,
that's it. Installation of a new standard is also explained at Github, see "`Setting the installed
standard paths
<https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options#setting-the-installed-standard-paths>`_".
Also you can always provide the path to the standard, like::

  $ phpcs --standard=/path/to/MyStandard test.php

How to
------

As already a tutorial is provided by the project itself, I'll provide further information not
covered by the tutorial.

Own standard
^^^^^^^^^^^^

There is not much to say, just follow the tutorial and "create" a standard. As documented on github
in the `Annotated ruleset.xml`_ it's possible to include existing standards. E.g. gather existing
sniffs from other projects, here are some examples:

* `Magento PHP_CodeSniffer Coding Standard`_ to check for best practices in Magento development.

* `compatibility of the code with PHP versions`_ to check for your PHP version.

* `Drupal <https://www.drupal.org/node/1419980>`_.

* `TYPO3 Standard <https://github.com/typo3-ci/TYPO3CMS>`_
  `TYPO3 Sniffs <https://github.com/Konafets/TYPO3SniffPool>`_

Chances are that your cms / framework already provides a basic standard. At least `PSR-2`_ which is
already included in PHP_CodeSniffer installation is available.

Own Sniffs fixing code
^^^^^^^^^^^^^^^^^^^^^^

Once you configured the standard to include some existing standard, you need to add custom Sniffs as
documented in the tutorial.

Most of the time your sniff will gather the tokens for current file and check some parts before or
after the current stack to match certain conditions. E.g. check out the small examples at our own
project in the `LegacyClassnames folder at Github
<https://github.com/DanielSiepmann/automated-typo3-update/tree/develop/src/Standards/Typo3Update/Sniffs/LegacyClassnames>`_.

Make sure you make use of ``$phpcsFile->addFixableError`` whenever possible, to allow ``phpcbf`` to
fix the issues. Otherwise it's not about automated code migration, but just a check providing you
with a list of violations.

Allowing to fix an error instead of only reporting the error is done by the following code::

        $fix = $phpcsFile->addFixableError(
            'Legacy classes are not allowed; found "%s", use "%s" instead', // Error message
            $stackPtr, // Stack pointer
            'legacyClassname', // identifier inside the sniff
            [$classname, $this->getNewClassname($classname)] // Arguments used for replacement in error message
        );

        // Check whether fixing is active
        if ($fix === true) {
            // Execute code to modify the tokens to fix the violation
            $phpcsFile->fixer->replaceToken($stackPtr, 'new token content');
        }

You add the error as usual but using a different method. This method will return ``true`` if
``phpcbf`` is run and fixes should be done. If fixes should happen, use the `replaceToken`_ method
of the `PHP_CodeSniffer_Fixer`_ class to adjust the code.

``$stackPtr`` in the above example is no longer the provided ``$stackPtr`` from PHP_CodeSniffer, but
the token that contains the violation. So if you register ``T_NEW`` but the classname afterwards
contains the violation, ``$stackPtr`` is the token of the classname.

Further help for new sniffs
^^^^^^^^^^^^^^^^^^^^^^^^^^^

While writing own sniffs, some information might be handy, that are:

Where do I find the tokens I can return inside of the ``register`` method?
    The first step is to check out the official php tokens at `php.net
    <https://secure.php.net/manual/en/tokens.php>`_
    Also check out the additional tokens of PHP_CodeSniffer itself inside the `Tokens.php`_
    Also note that `Tokens.php`_ contains some collections you can reuse, e.g.::

        /**
         * Tokens that are comments.
         *
         * @var array(int)
         */
        public static $commentTokens = array(
                                        T_COMMENT                => T_COMMENT,
                                        T_DOC_COMMENT            => T_DOC_COMMENT,
                                        T_DOC_COMMENT_STAR       => T_DOC_COMMENT_STAR,
                                        T_DOC_COMMENT_WHITESPACE => T_DOC_COMMENT_WHITESPACE,
                                        T_DOC_COMMENT_TAG        => T_DOC_COMMENT_TAG,
                                        T_DOC_COMMENT_OPEN_TAG   => T_DOC_COMMENT_OPEN_TAG,
                                        T_DOC_COMMENT_CLOSE_TAG  => T_DOC_COMMENT_CLOSE_TAG,
                                        T_DOC_COMMENT_STRING     => T_DOC_COMMENT_STRING,
                                    );

How do I run only one sniff, the one I'm working on right now?
    Just provide the ``--sniffs`` option during CLI calls::

       phpcbf -p --colors -s --sniffs=Typo3Update.LegacyClassnames.DocComment Classes/Controller.php

How do I get the sniff name of a sniff?
    1. Coding Standard name (``Typo3Update``)

    2. Folder name (``LegacyClassnames``)

    3. File name (``DocCommentSniff.php`` -> ``DocComment``)

    Also they are displayed by running ``phpcs`` with option ``-s``, like:

    .. code-block:: shell
       :emphasize-lines: 4

       $ ./vendor/bin/phpcs -s <path>
       8 | ERROR | [x] Legacy classes are not allowed; found
         |       |   backend_toolbarItem
         |       |   (Typo3Update.LegacyClassnames.Inheritance.legacyClassname)

Make parts configurable through :file:`ruleset.xml`
    All public properties of sniffs are configurable through the :file:`ruleset.xml`. So all you
    have to do, is to provide a public property as an option. The properties are configured on a
    sniff base. So extending a class with a public option makes the option available to all sniffs,
    same goes for traits.

    The configuration will look like the following:

    .. code-block:: xml

       <rule ref="Typo3Update.LegacyClassnames.DocComment">
           <properties>
               <property name="allowedTags" type="array" value="@param,@return,@var,@see,@throws"/>
           </properties>
       </rule>

    You have to define the rule to configure, followed by Tag ``properties`` that contain each
    property you want to configure as a tag inside.

    You can also take a look at `Customisable Sniff Properties
    <https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties>`_.

REPL your sniffs
    I prefer to use `psysh`_ nowadays and it makes it easy to "discover" your code and write your
    sniffs interactively. It's an Symfony Cli App you can call from within your code by including
    the following line:

    .. code-block:: php

        require_once('~/bin/psysh');eval(\Psy\sh());

    Like an ``xdebug_break()`` the execution will halt and you are inside the app and can play
    around.

Result
^^^^^^

The result is a check like::

   $ ./vendor/bin/phpcs -p --colors -s <path>
   E


   FILE: <path>
   ----------------------------------------------------------------------
   FOUND 5 ERRORS AFFECTING 5 LINES
   ----------------------------------------------------------------------
    8 | ERROR | [x] Legacy classes are not allowed; found
      |       |   backend_toolbarItem
      |       |   (Typo3Update.LegacyClassnames.Inheritance.legacyClassname)
   14 | ERROR | [x] Legacy classes are not allowed; found TYPO3backend
      |       |   (Typo3Update.LegacyClassnames.DocComment.legacyClassname)
   16 | ERROR | [x] Legacy classes are not allowed; found TYPO3backend
      |       |   (Typo3Update.LegacyClassnames.TypeHint.legacyClassname)
   48 | ERROR | [x] Legacy classes are not allowed; found t3lib_extMgm
      |       |   (Typo3Update.LegacyClassnames.StaticCall.legacyClassname)
   61 | ERROR | [x] Legacy classes are not allowed; found t3lib_div
      |       |   (Typo3Update.LegacyClassnames.StaticCall.legacyClassname)
   ----------------------------------------------------------------------
   PHPCBF CAN FIX THE 5 MARKED SNIFF VIOLATIONS AUTOMATICALLY
   ----------------------------------------------------------------------

   Time: 35ms; Memory: 5Mb

And of course the auto migrated code.

History
-------

We are currently using PHP_CodeSniffer to auto migrate TYPO3 Extensions in a 6.2 installation, to be
compatible with the latest LTS release. Due to massive namespace changes in versions between the
original writing of the extensions, we make heavy use of PHP_CodeSniffer to auto migrate the code.

Before we did some small research how TYPO3 migrated the code itself and how Neos / Flow does the
job. But plain regular expressions are not enough for us. Also regular expressions are not as well
integrated into IDEs and editors as PHP_CodeSniffer.

You can check out our project at Github: `DanielSiepmann/automated-typo3-update`_.

Further reading
---------------

* `PHP_CodeSniffer at Github <https://github.com/squizlabs/PHP_CodeSniffer>`_

* `PHP_CodeSniffer documentation (wiki) at Github
  <https://github.com/squizlabs/PHP_CodeSniffer/wiki>`_

* `PHP_CodeSniffer documentation at php.net
  <https://pear.php.net/manual/en/package.php.php-codesniffer.php>`_

* `DanielSiepmann/automated-typo3-update`_

.. _PHP_CodeSniffer: https://github.com/squizlabs/PHP_CodeSniffer
.. _Magento PHP_CodeSniffer Coding Standard: https://github.com/magento-ecg/coding-standard
.. _compatibility of the code with PHP versions: https://github.com/wimg/PHPCompatibility
.. _PHPStorm: https://confluence.jetbrains.com/display/PhpStorm/PHP+Code+Sniffer+in+PhpStorm
.. _Vim: https://github.com/vim-syntastic/syntastic
.. _Sublime Text: https://github.com/squizlabs/sublime-PHP_CodeSniffer
.. _Coding Standard Tutorial: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Coding-Standard-Tutorial
.. _Annotated ruleset.xml: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Annotated-ruleset.xml
.. _PSR-2: https://www.php-fig.org/psr/psr-2/
.. _psysh: https://psysh.org/
.. _DanielSiepmann/automated-typo3-update: https://github.com/DanielSiepmann/automated-typo3-update

.. _replaceToken: https://pear.php.net/package/PHP_CodeSniffer/docs/2.8.1/PHP_CodeSniffer/PHP_CodeSniffer_Fixer.html#methodreplaceToken
.. _PHP_CodeSniffer_Fixer: https://pear.php.net/package/PHP_CodeSniffer/docs/2.8.1/PHP_CodeSniffer/PHP_CodeSniffer_Fixer.html
.. _Tokens.php: https://github.com/squizlabs/PHP_CodeSniffer/blob/2.8.1/CodeSniffer/Tokens.php
