.. post:: Sep 02, 2016
   :tags: typo3, language, typoscript, fluid
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
``optionSplit`` we are using the :ref:`t3tsref:stdwrap-datawrap` to inject the values from a
language file.

The TypoScript
--------------

.. code-block:: typoscript
   :linenos:

    tmp.language = HMENU
    tmp.language {
        wrap = <ul>|</ul>

        special = language
        special {
            value = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        }

        1 = TMENU
        1 {
            NO = 1
            NO {
                allWrap = <li>|</li>

                ATagTitle {
                    data = LLL:EXT:sitepackage/Resources/Private/Language/Frontend.xlf:languageMenu.title.{field: _PAGES_OVERLAY_LANGUAGE}
                }

                stdWrap {
                    cObject = COA
                    cObject {
                        1 = TEXT
                        1 {
                            insertData = 1
                            data < tmp.languageMenu.1.NO.ATagTitle.data
                        }
                    }
                }
            }

            ACT < .NO
            ACT {
                allWrap = <li class="active">|</li>
            }

            USERDEF1 = 1
            USERDEF1 {
                doNotShowLink = 1
            }
        }
    }

On Line 5 to 8 we define the menu as you normally would. With one exception, we add all
``sys_language_uid``'s, not only the one we want on the current site. Via ``NO`` all existing
languages that are not the current active are rendered. With ``ACT`` the current active language is
rendered and via ``USERDEF1`` we define to not show links to language not available.

By Using ``USERDEF1`` we don't have to adjust the set of languages for each page.

Inside of ``data`` ``_PAGES_OVERLAY_LANGUAGE`` contains the uid of the current sys_language to
render.

Using the ``data`` we can render the content of a language file, which can be different for each
language. This way we can adjust the labels for each language depending on the language.

The language file for above example might look like the following:

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>
    <xliff version="1.0">
        <file source-language="en" datatype="plaintext" original="messages" date="2016-02-02T11:59:19Z" product-name="wv_site">
            <header/>
            <body>
                <trans-unit id="languageMenu.currentLanguage" xml:space="preserve">
                    <source>English</source>
                </trans-unit>
                <trans-unit id="languageMenu.title." xml:space="preserve">
                    <source>English</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.1" xml:space="preserve">
                    <source>Deutsch</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.2" xml:space="preserve">
                    <source>Français</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.3" xml:space="preserve">
                    <source>Español</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.4" xml:space="preserve">
                    <source>Português</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.5" xml:space="preserve">
                    <source>Polski</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.6" xml:space="preserve">
                    <source>Русский</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.7" xml:space="preserve">
                    <source>Italiano</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.8" xml:space="preserve">
                    <source>العربية</source>
                </trans-unit>
                <trans-unit id="languageMenu.title.9" xml:space="preserve">
                    <source>English</source>
                </trans-unit>
            </body>
        </file>
    </xliff>

Credits
-------

This solution was "invented" by `Justus Moroni`_ and myself during one project, as we thought that
option split and adjusting the setting for each site is not the best way.

Further reading
---------------

Here is jut one example how it's done through option split:
https://typo3.org/documentation/snippets/sd/64/

.. _Justus Moroni: https://twitter.com/Leonmrni
