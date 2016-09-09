.. post:: May 26, 2016
   :tags: typo3, solr, content management

.. _everything-is-content:

Everything is Content, that can be served via Solr
==================================================

TYPO3 provides some record types like *pages*, *content*, *files* and *categories*.
With this basic set of record types you can build full blown websites containing products, projects,
Blog posts, news and many more different content types without the need of any plugins, it's just
configuration in TYPO3.

To provide a search with filter to the visitor you can use *solr* as an extension. With these
combination there is no need for further custom record types like news or products and plugins or
database tables with custom search and filter implementations for all of them.

The Idea
--------

The basic idea is to reduce amount of time for programming by just using configuration, which
can be done by a programmer or integrator. Also don't include more dependencies for further
extensions. Stick to the core and as less extensions as possible to make later updates and
migrations as easy as possible. As TYPO3 already provides smooth updates, only extensions are a big
hassle.

In addition, you will get further benefits. Once everything is setup, Solr provides an API with
ready to use clients in multiple languages enabling you to serve TYPO3 content from a central place
to your mobile apps or further clients, like in store solutions.

Setup
-----

* TYPO3 CMS 7.6 LTS

* Solr 4.10.4

* TYPO3 solr-Extension 5.0.0-dev (which is current master on Github)

* TYPO3 solrfluid-Extension 1.0.0-dev (which is available for sponsors)
  The need to pay, even if it's licensed under GNU GPL-2 of course, is due to the fact that a bit
  time is needed to provide full Fluid integration. So all contributions are welcome, whether money
  or time. E.g. help to provide documentation or Fluid templates.

The configuration
-----------------

Beside the technical setup, some custom page types were defined in TYPO3, which is a core feature.
This enables many different configuration options like restriction to record types, provide
different icons in page tree, and different configuration for indexing with Solr. Let's assume we
have the following custom page types:

* *News*

* *Projects*

Beside the custom page types, *System Categories* to *tag* all pages are a nice feature. You can
setup a clean structure of categories for different kinds like the product categories, countries in
which the projects were made or news categories and areas of work. That way an editor can assign a
project or news to these categories inside the page properties. He also is able to assign images and
provide an abstract. That's all part of TYPO3 core and there is no additional work needed.

Of course you *can* improve the live of editors and configure all page types to contain only the
needed properties and exchange labels to make them work in the context of *News* or *Projects*.

If you are interested in custom page types, take a look at :ref:`t3coreapi:page-types`.

Once that's done, you need to provide the necessary configuration for Solr. Currently it's not
possible to handle different page types with Solr with different configurations as some parts are
hard coded. But an additional extension will make it possible (not released yet), or the changes will
make it back to the official extension (to reduce dependencies).

If you are interested in the needed changes, get in contact.

The result will look like the following inside the module:

.. image:: /images/2016-05-26-typo3-everything-is-content/indexing.png

Now you are able to index all different kinds when you need them. Also you can prioritize them to
index news before projects.

Once the indexing is done, you are able to filter the indexed records based on there page type to
e.g. provide an news archive or the 5 latest news chronically on your starting page.

Also you can provide an overview of the projects with all possible Solr filters provided by facets.

There is no need for extra definitions of custom records with own TCA and database tables, for custom
plugins with custom implementations for searching and filters. Everything is already there.

Still needed
------------

Okay, not everything is already there. As pointed out before, the extension *solrfluid* is currently
in early development. Also it's not possible to configure each page type on his own out of the box.

Beside all of that. The extension was used for a "normal" search. All configuration is done via
TypoScript, even if it can be done via Flexforms, but there is no documentation and an editor should
not be able to do so now as the current Flexform looks like the following:

.. image:: /images/2016-05-26-typo3-everything-is-content/flexform-old.png

But changes are already in progress to improve the UX:

.. image:: /images/2016-05-26-typo3-everything-is-content/flexform-new.png

The filter are no longer a single input field where the editor needs the knowledge of the internal
field name and a ``|`` to separate multiple filters.

You can help by improving documentation, improve the UX, help implementing fluid templates and add further features.
To do so, take a look at the `official repository of solr <https://github.com/TYPO3-Solr/ext-solr>`_
of contact the developers on `slack <https://typo3.slack.com/>`_

The detail view?
----------------

Is already there, as the records are pages, the page itself will serve as the detail view. There are
no limitations. The editor can use everything you have configured and allowed. No restrictions and
programming. All plugins are available, if you want, also all content elements. You can also setup
different layouts. No restrictions, no further "*Can you add ...*", it's already there.

Limits
------

Of course there are limits. It's not useful to apply this idea to everything. If there are really
structured data, it's better provide a custom record. But even this record can be indexed with Solr
and you can use the facets and features. There is still no need for a custom search implementation.
Same goes for galleries. Just setup different templates for search results, partials for different
result types like images, news, products, and display them differently.

Beside that, you disable some limits. Some extension authors are not aware or don't support certain
features of TYPO3. Sometimes due to the lack of support in extbase. That are:

* Workspaces

* Multi language

* Versioning

All this features are there, as you just use core TYPO3. And with *fluid_styled_content*, rendering
output and defining different templates under different circumstances, is no more pain.

How TYPO3 and the ecosystem will benefit
----------------------------------------

Yes, in my Opinion also TYPO3 will benefit from this approach. If you take it further, it will
reduce the amount of time spent by developers on developing custom records and plugins all doing the
same. The amount of outdated extensions in `TER <https://typo3.org/extensions/repository/>`_ will
decrease and only useful extensions will remain. Also more time is available to work on TYPO3
itself. Also users of TYPO3 will know TYPO3 itself better again. At the moment most people know
extensions better then the system itself. Leading to things like using an extension for news to
implement the above, projects and downloads or further custom records.

TYPO3 also provides an extension to setup forms by editors. Use it instead of 3rd party extensions.
Improve the base.

Why Solr?
---------

There can be reasons, but the idea is independent from technologies. You can use Fact-Finder,
elasticsearch or any other technology or provider for that.

The reason why I've used Solr in this post is, there is already an extension for TYPO3 providing the
indexing and searching to you. All you need to do is the configuration in TypoScript.

Further resources
-----------------

The resources that are currently available and that will help you to achieve the above:

* :ref:`t3coreapi:page-types`

* `Current official documentation of ext:solr
  <https://forge.typo3.org/projects/extension-solr/wiki>`_

Also you might be interested in this earlier blog post: :ref:`dynamic-context-aware`.
