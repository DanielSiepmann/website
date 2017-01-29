.. post:: Sep 09, 2016
   :tags: typo3, typoscript
   :excerpt: 2

Build TYPO3 Language Menu without the need of optionSplit
=========================================================

TYPO3 CMS allows you to build a language menu to enable the frontend user to switch the current
language. This menu is generated via TypoScript using :ref:`t3tsref:objects-optionsplit`. Just
`start a query <https://www.google.com/search?q=typo3+language+menu>`_ and take a look at the
snippets. This way has one big drawback. In a multi domain setup you have to change the config

We have overcame this issue with one language menu working for all setup on all domains without the
need to adjust anything. Read here how to achieve this.

The idea
--------

The basic idea is to use the ``HMENU`` like all other solutions, but instead of using the
``optionSplit`` we are using :ref:`t3tsref:stdwrap-data` to inject the values from a language file.

The TypoScript
--------------

.. literalinclude:: /Code/TYPO3/example/Configuration/TypoScript/Setup/Menu/Language.ts
   :language: typoscript
   :linenos:

On Line 5 to 8 we define the menu as you normally would. With one exception, we add all
``sys_language_uid``'s, not only the one we want on the current site. Via ``NO`` all existing
languages that are not currently active are rendered. With ``ACT`` the current active language is
rendered and via ``USERDEF1`` we define to not show links to languages which are not available for
the current site, depending on your configuration.

By Using ``USERDEF1`` we don't have to adjust the set of languages for each page.

Inside of ``data``, the ``field: _PAGES_OVERLAY_LANGUAGE`` contains the uid of the current
sys_language to render.

Using the ``data`` we can render the content of a language file. This file can be different for each
language. This way we can adjust the labels for each language depending on the language.

.. note::

  The language configuration is needed in addition. But as this is documented anywhere else, it's
  not part of this post. This post just covers the menu generation.

  Take a look at `Frontend Localization Guide`_.

The language file
-----------------

The language file for above example might look like the following.

.. note::

  You have to provide the id ``languageMenu.title.`` for our example, as default language ``0`` will
  not have a number in this menu.
  See Line 5.

.. literalinclude:: /Code/TYPO3/example/Resources/Private/Language/Frontend.xlf
   :language: xml
   :linenos:
   :emphasize-lines: 5

The result
----------

The output will look like the following:

.. figure:: /images/2016/09-typo3-language-menu-via-language-file/output.png
   :align: center

   Example output

Credits
-------

This solution was "invented" by :twitteruser:`Justus Moroni <Leonmrni>` and myself during one project, as we
thought that option split and adjusting the settings for each site is not the best way. Also we were
just to lazy, you know programmer?, to adjust the configuration for each multisite.

Further reading
---------------

Here is just one example how it's done through option split:
https://typo3.org/documentation/snippets/sd/64/

And further resources to TYPO3 documentation which are used in this example:

- :ref:`t3tsref:cobj-hmenu`

- :ref:`t3tsref:hmenu-special-language`

- :ref:`t3tsref:tmenuitem`

- :ref:`t3tsref:stdwrap-data`

- :ref:`t3tsref:stdwrap-cobject`

.. _Frontend Localization Guide: https://docs.typo3.org/typo3cms/FrontendLocalizationGuide/BasicSetupOfALocalizedWebsite/TyposcriptConfiguration/Index.html
