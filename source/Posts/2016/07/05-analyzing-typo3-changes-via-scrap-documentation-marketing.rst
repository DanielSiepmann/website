.. highlight:: javascript

.. post:: Jul 05, 2016
   :tags: typo3, scrapy, python, js, coding, docs, marketing
   :excerpt: 2

Analysing TYPO3 changes via scrapy / Documentation marketing
============================================================

Reading a magazine, I was confronted with `scrapy`_ »an open source and collaborative framework for
extracting the data you need from websites. In a fast, simple, yet extensible way.« The framework is
written in python and easy to use. You can persist the information in multiple output formats like
`xml`, `json`, `csv` and some more. That makes it easy to fetch structured information like `TYPO3
Changelog`_. Also I had `highcharts`_ bookmarked for some years now. The interest in how many
changes were introduced in each TYPO3 Version, in combination with the type of change, like breaking
change or feature, were the missing idea to put everything together.

In this post you will learn a minimum setup to put `scrapy`_ and `highcharts`_ together, to
visualize information like the mentioned above. Also you will learn why this information are so
important, and what *Documentation Margeting* is about and why you should care.

If you are only interested in :ref:`section-documentation-marketing` just head over to the section.

How to start
------------

First of all you need to analyze the structure of information to gather. That's as easy as opening
the website in your browser, starting the JavaScript console and load jQuery. Then you can start
writing the "query" to fetch the necessary information.

Let's stick to the above example by using Google Chrome. Head over to `TYPO3 7.0 Changelog
<https://docs.typo3.org/typo3cms/extensions/core/7.6/Changelog/7.0/>`_. jQuery is already loaded on
this site. `Open the console
<https://developers.google.com/web/tools/chrome-devtools/debug/console/console-ui?hl=en#opening-the-console>`_.
Execute the following JavaScript inside the console::

    $('#breaking-changes a.reference.internal')

This will deliver all 62 breaking changes for version 7.0 as you can see with::

    $('#breaking-changes a.reference.internal').length

This is the "CSS" selector to get the necessary information. Same for features::

    $('#features a.reference.internal').length

This shows how important markup can be. It's not only for styling, but also for parsing.

Once we know how to get the necessary information, we can start with `scrapy`_ to fetch and store
the necessary information for each TYPO3 Version.

Fetch information
-----------------

The whole python script using `scrapy`_ to fetch all information is:

.. literalinclude:: /Code/Python/typo3Docs.py
   :language: python
   :linenos:

We will call this spider via CLI:

.. code-block:: bash

    scrapy runspider typo3Docs.py -o build/typo3Docs.json

This will run the spider and persist the gathered information in :file:`build/typo3Docs.json`.
Scrapy detects that we want to store ``json``, because of the file extension, and formats the
information for us.

Basically we run the spider against the start pages, fetch all urls for the specific versions of
branch 7 and 8, and parse the target urls. That's done inside ``parse`` for ``start_urls``. Once we
are on the "detail" views with all changes, we will fetch the necessary information in
``parse_version``. Scrapy will format the information and write them to the specified output file.

You can see the initial jQuery calls again on lines 22 to 25 to fetch the different types of
changes.

Display information
-------------------

Once all information are stored in a local file, we can start to display them in a chart, that's
done with the following JavaScript and HTML.

First of all we import all necessary source:

.. literalinclude:: /Code/HTML/typo3Docs.html
   :language: html
   :lines: 21-23
   :dedent: 8

Then we will load the persisted information:

.. literalinclude:: /Code/HTML/typo3Docs.html
   :lines: 25,27,108-109

Now we can format the information as we need them for `highcharts`_, inside the callback:

.. literalinclude:: /Code/HTML/typo3Docs.html
   :lines: 28-71
   :dedent: 8

And configure `highcharts`_ itself:

.. literalinclude:: /Code/HTML/typo3Docs.html
   :lines: 73-107
   :dedent: 8

In the end we have the following result:

.. figure:: /images/2016/07-05-analyzing-typo3-changes-via-scrap-documentation-marketing/chart.png
    :align: center

    The result, our chart with gathered information

Conclusion
----------

If data is structured, it's easy to fetch them via `scrapy`_. Once information are stored in a JSON
file, it's pretty easy to display it via something like `highcharts`_. Also I've done most of the
logic via JavaScript you can provide the necessary structure via Python of course.

And please note: It's just about getting started with both tools and to make documented changes at
TYPO3 visible, not about nice code.

.. _section-documentation-marketing:

Documentation marketing
-----------------------

During my contributions in the area of documentation it turns out most developers have so much fun
while developing new features. In the end they are proud of their new product, but don't provide
documentation for their users. Users can be further developers extending the original product via an
API, or the user interacting with the product via a GUI / CLI. Sometimes they promote their new
product, e.g. a new feature. They write a Blog post, tweet about it, talk on conferences, and so on.
But no one else can inform himself about the features and much more important if he once get
interested, how to use the product / feature.

That's why I was interested in the "real" numbers of changes in TYPO3 system. That's the reason for
gathering the information not from Github but the documentation.

One documentation you can see at some projects are "release notes". Everything that is new will be
documented beside the whole documentation. That's better then nothing, but it's incremental, you
have to know that something has changed to loop it up. Also you need to know the context around the
change.

But the most important people are the one not using your product right now, but that will make a
decision whether to use your product in the future. They will take a look at the official
documentation.

If you don't update or provide an understandable, up to date documentation, how should they know
about the features? How should they know how to use features and how hard it will be? Of course we
have tests nowadays, but that's not the same. You need much more time, that's why we have
documentation.

Documentation is like performance, you should not put it in top, but into your definition of done.
It's mandatory if someone should use your product. And in case of products like TYPO3, it's the same
as with software like Sublime Text. The software itself is not the point while selling, but the
ecosystem. And that heavily depends on the documentation.

So please do yourself, and the world a favour and provide the necessary documentation. The ecosystem
is well documented and easy to use, as you can see at my Blog post
:ref:`post-readthedocs-sphinx-plantuml`.

Further reading
---------------

You might also be interested in :ref:`post-readthedocs-sphinx-plantuml`.

Check out the used tools:

- `scrapy`_ The python framework to gather information from websites / urls.

- `highcharts`_ The JavaScript library to display charts.

.. _scrapy: http://scrapy.org/
.. _highcharts: http://www.highcharts.com/
.. _TYPO3 Changelog: https://docs.typo3.org/typo3cms/extensions/core
