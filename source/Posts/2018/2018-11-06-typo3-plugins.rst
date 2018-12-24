.. post:: Nov 06, 2018
   :tags: typo3, extbase
   :excerpt: 2

TYPO3 plugins
=============

You might think "I know what plugins, within TYPO3, are". Maybe that's true, maybe
you still will learn something through this blog post.

This blog post will first explain what TYPO3 plugins are, how to define custom
plugins for existing 3rd Party extensions, and why this might be helpful.

This will only cover Extbase plugins, as most Extensions only provide Extbase
nowadays.

What is a TYPO3 plugin?
-----------------------

Within TYPO3 Extbase, an plugin consists of the following:

* An identifier, so called "plugin signature"

* A title for the editor within the TYPO3 backend

* An optional icon within TYPO3 backend

* An combination of callable controller and actions

* An combination of non cached callable controller and actions

* TypoScript defining the rendering of the plugin

* An optional Flexform for further configuration via editors

Why adding plugins for existing extensions?
-------------------------------------------

Let's assume there is a TYPO3 installation with a search, provided by EXT:solr, and
news, using the "Custom Page Type approach™". Everything is working, all news are
searchable.

Now the customer want an index of all news within the "News" page. Maybe he also
needs some pre filtered news on sub pages, e.g. only news regarding new products or
news regarding the company.

Of course one could now add TypoScript to these pages to configure EXT:solr to start
in filter mode instead of search mode. Also filter can be added to only show news
records from these categories. This is not that flexible. The editor is not able to
add new "News listings" to further pages, as TypoScript is involved.

Instead the integrator can add a new plugin "news" within the "Sitepackage™" of the
installation. These plugin is just a duplication of the existing plugin of EXT:solr,
but the result is cacheable. Also a new plugin allows to add a different Flexform to
this plugin. These Flexform can provide a drop down with possible categories.

This speeds up the delivery of the page, as it's fully cached. Also an editor can now
add a "news" content element and select the specific category.

How to add a new TYPO3 plugin
-----------------------------

To add a new plugin, first of all two API calls are necessary. After those were made,
the plugin is already available to the editor and will be rendered in frontend.

Afterwards the optional Flexform and TypoScript can be added.

Conclusion for Extbase controller
---------------------------------

Each controller within an Extbase extension should consist of actions, which only do
one single thing. No functionality should be duplicate because there is a need for
another display variant.

By providing fine grained actions for single tasks, the integration is able to
configure installation specific plugins.

E.g. during my TODO, insert "training" here!!!, I've developed a single controller
with nearly 10 actions, all doing the same. Just to provide 10 different template
variants. Today one could use ten plugins, or even better use a setting like the
``layout`` field within content element, together with an ``f:render`` call within
Fluid to switch the rendering.

Further reading
---------------

* TODO: Insert link to flexform

* TODO: Insert link to plugin API
