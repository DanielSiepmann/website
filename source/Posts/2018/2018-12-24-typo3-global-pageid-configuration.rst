.. post:: Dec 24, 2018
   :tags: typo3, typoscript
   :excerpt: 2

.. highlight:: typoscript

Configure page UIDs for all content elements in TYPO3
=====================================================

TYPO3 uses pages to organise the structure of a website. This leads to situations
where you have a specific page for a feature, e.g. a page "Search" containing the
plugin to display search results. Or a page containing the profile of the currently
logged in user. Typically links to these pages are scattered all over the website,
e.g. within some content elements, inside the page layout like header and within some
plugins.

This Blog post explains how to provide the page uid for a specific page, to all three
kinds of "content", where you typically need this information, with three lines of
TypoScript.

Assumptions
-----------

This Blog post makes the following assumptions about the TYPO3 installation,
otherwise the solution might not work.

#. Page layout is rendered using :ref:`t3tsref:cobj-fluidtemplate`.

#. EXT:fluid_styled_content is used to render content elements.

#. Plugins are always using Extbase.

Page Layout
-----------

:ref:`t3tsref:cobj-fluidtemplate` provides two ways to provide information to the
template. One can use ``variables`` or ``settings``. As the page uid does not need
TypoScript ``stdWrap`` but is a fix value, and fits more into "settings", we will use
``settings`` here::

   page {
      10 {
         settings {
            cdx {
               pageUids {
                  search = 10
               }
            }
         }
      }
   }

The above example assumes that ``page.10`` is of type ``FLUIDTEMPLATE`` and contains
the existing setup to render page layout. We now add ``settings`` which is a plain
PHP Array passed to the template.

As good practice namespaces are introduces, in above example ``cdx.pageUids`` where
``cdx`` is the company vendor, also used within PHP classes. ``pageUids`` is just a
grouping, as we might also provide ``paths`` or further information.

With above example we could access the page uid using
``{settings.cdx.pageUids.search}`` within the template, layout and any partial, as
``settings`` are always passed to all further template files within Fluid.

One could now use the uid like:

.. code-block:: html

   <f:form pageUid="{settings.cdx.pageUids.search}" action="search">
      <!-- search form -->
   </f:form>


Content Elements
----------------

All content elements are rendered by inheriting ``lib.contentElement``, which is an
``FLUIDTEMPLATE``. Knowing this, we can re use the above knowledge from page layout,
to add the necessary information to all content elements::

   lib.contentElement {
      settings {
         cdx {
            pageUids {
               search = 10
            }
         }
      }
   }

This way all content elements have the same information available and links can be
created to important pages.

Thanks to the namespacing, there is no risk that an setting already in use might be
replaced.

Plugins
-------

Plugins using Extbase are working nearly the same as content elements, all inherit an
global "environment" from ``config.tx_extbase``. This "environment" is merged with
more specific further "environments" from TypoScript and Flexforms.

Knowing this, the general information can be added like this::

   config.tx_extbase {
      settings {
         cdx {
            pageUids {
               search = 10
            }
         }
      }
   }

Cleanup
-------

Right now the page uid for page "search" is defined three times, which is a bad
practice. Therefore a constant can be used instead::

   pageUids {
      search = 10
   }

Which is then used in all three places::

   page {
      10 {
         settings {
            cdx {
               pageUids {
                  search = {$pageUids.search}
               }
            }
         }
      }
   }

   lib.contentElement {
      settings {
         cdx {
            pageUids {
               search = {$pageUids.search}
            }
         }
      }
   }

   config.tx_extbase {
      settings {
         cdx {
            pageUids {
               search = {$pageUids.search}
            }
         }
      }
   }

The benefits
------------

Using the above approach, a new site can easily be added to the TYPO3 installation.
To make the new site work, the constant has to be adjusted, that's all one has to do.

Also replacing parts of the site is more easy to achieve. E.g. a single part of page
tree is relaunched, one only has to change the constant again.

There is no need for "search and replace".

Further reading
---------------

* :ref:`t3tsref:cobj-fluidtemplate` especially
  :ref:`t3tsref:cobj-fluidtemplate-properties-settings`.

* Right now there is no documentation about ``config.tx_extbase``.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8, 9 LTS.
