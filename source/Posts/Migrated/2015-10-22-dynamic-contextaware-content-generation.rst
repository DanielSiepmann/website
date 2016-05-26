.. post:: Oct 22, 2015
   :tags: typo3, events
   :location: Amsterdam, Netherlands

.. _dynamic-context-aware:

Dynamic, context aware, content generation
==========================================

There was one talk at the TYPO3 conference this year, with the name "*Semantic Annotations within
TYPO3 CMS*" by *Johannes Goslar*. The main goal is to prepare content inside TYPO3 CMS with semantic
information, so you can deliver it with rich snippets to improve SEO.  Beside that, the solution
developed offers a way to query all your content by the semantic understanding. Most of us heard
about Graphs nowadays, whether from Facebook or Google. They aim to make information understandable
by computer and enable users to query information like they normally would in the real world.

This will become possible with the solution for your own. You don't need a big company with efforts
like Google. You can grab the open source solution, annotate your content with information about
People, Nations, Cities, Animals and such and query your Content by semantic information.  This
enables you to generate new pages rapidly without the need to generate the content, as it's already
there.

One customer I worked for, had the need to generate pages for SEO to gather traffic from search
engines for specific keywords like "Summer", "Barbecue" or such. What they did was to ask the web
agency to make a new design, a text provider to write some texts, another company to create recipes
and one more for images. Every single company got a lot of many for this single page. And it took
time to generate everything and put it together.

Now image that you had generate content like images, articles, products and such over three years.
It's already there and if you have the possibility to query the "content repository" by semantics
like "give me recipes for summer barbecue", "give me articles about barbecue" and "show some pics
from barbecue", you have all you need if you created it once. You can look up where it's currently
in use and check whether it's worth to generate even more. And with one plugin, enabling you to
query the content, you can rapidly build the pages in CMS like TYPO3.

Hopefully some day this becomes truth and we are able to generate a good UX from existing sources.

If you wanna dig deeper into the topic, check out the `repository on github
<https://github.com/dkd/php-cmis-client>`__ or the `wikipedia article
<https://en.wikipedia.org/wiki/Content_Management_Interoperability_Services>`__ about CMIS.

Also you might be interested in this newer blog post: :ref:`everything-is-content`.
