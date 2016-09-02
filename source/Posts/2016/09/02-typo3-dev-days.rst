.. post:: Sep 02, 2016
   :tags: typo3, event
   :excerpt: 2

TYPO3 Developer Days 2016 in Nuremberg - Recap
==============================================

The TYPO3 Developer Days 2016 in Nuremberg took place from 01. Sep to 04. Sep in the youth hostel of
Nuremberg. During these days multiple prepared talks were presented, together with a coding night of
the Core Team where everyone could jump in.

In this post I'll recap the event and some talks I've participated on. All talks that were recorded
during the event are available on Youtube at playlist `T3DD16 - TYPO3 Developer Days 2016`_.

Day 1
-----

The first day was really all about developers. With the talks about `Temporal Modelling`_ and
`Extremely defensive PHP`_ which everyone could attend as they were in a row. Except if you wanted
you to prepare for the Developer Certification on next day, as the preparation was at the same time
as Extremely defensive PHP.

While the first talk `Temporal Modelling`_ was about concepts and how you should model your
application, the second one `Extremely defensive PHP`_ was more about concrete code.

Temporal Modelling
^^^^^^^^^^^^^^^^^^

The talk was all about the way how to model your application. It was not about such concrete things
like UML and diagrams, but more about the process and way to think. The basic message was to think
more event driven. As your application reacts to event, not only if you are building an web
application using JavaScript, but also if you are using PHP. Also you should discuss the design
during the modelling inside the team.

The user always interacts through events with your application, not in a technical way, but a way of
behaviour. The user doesn't think the way as we are doing in specs right now. Most are designing the
domain by thinking of objects containing data and changing their state over time. E.g. in a web shop
you will have a model representing an order, where the state will change over time from "open" to
"payed".

But what really happens is that you create the order once. Then some events occur like the user
receives an e-mail with invoice, the user interacts and pays the invoice. That's another event. If
you are thinking in the way of events, you build a history on top of the object and the initial
state.

That will bring some benefits like:

- Collecting information for analytics
  E.g. how many aborted the process.

- Checkout the application at any state, as you can reconstruct it through the history by reapplying
  the events on the initial state.

- While designing the application, you will detect open questions and design issues.
  As you are thinking through events like "a product will be deleted" you might easier see issues
  like "what happens to orders or baskets that have a relation to the current product?"

The full talk is available on Youtube:

.. youtube:: q2rCRhtEHZ0

Extremely defensive PHP
^^^^^^^^^^^^^^^^^^^^^^^

This talk was already presented at the PHP Usergroup Düsseldorf. It was about how you should code to
not allow other developers to break your application. This was mostly addressed to projects like
TYPO3 which are open source and where a large group of developers, no developing the software
itself but interacting through API.

Still there were many recommendations you can apply during your daily work. Most of them might look
very strange and rude at first. But you should look the talk after half a year again and you will
notice how different you will think about most parts. They make sense you then and you will try to
use them also in projects where no one else is working on.

It's basically just about good design and what you can do with PHP, but should not. It's like "*bad
Parts of PHP*" which you can, but should not do.

The full talk is available on Youtube:

.. youtube:: ML-lqk_Rbew

Day 2
-----

Second day was, of course, also about developing. It started with `Composer Composer Composer`_,
goes over to `A practical guide to vanilla web components`_ and ended with `Automated Acceptance
Testing`_ 

.. todo:: Add recap of coding night?!

Composer Composer Composer
^^^^^^^^^^^^^^^^^^^^^^^^^^

Helmut Hummel gave an overview why TYPO3 is using composer, what has changed by using composer and
what are the plans for the future. OF course there were no premisses but topics the team is and will
work on. Also he explained some details and benefits of composer, which is not only related to
TYPO3.

It was also an introduction how to use composer with TYPO3.

The full talk is available on Youtube:

.. youtube:: yJRla3UCb-s


A practical guide to vanilla web components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Leon Revill introduced why you should use web components, what web components are and that you can
actually use them, thanks to Polyfills, in all browsers. In his opinion they will rule the web and
are the biggest change the web has seen.

Mostly they are a combination of different features and standards, allowing you to build something
like a progress bar or calendar widget for inputs. This components is self encapsulated containing
the necessary HTML, JS and CSS and is mostly immutable to the outside. Only certain parts can be
made publican available through CSS variables or slots in HTML. Also an JS API can be exposed for
external interactions.

Also some fancy stuff like mobile slide menus can be build with this techniques. The real benefits
of web components is that you can reuse them through all projects.

The full talk is available on Youtube:

.. youtube:: uX06JvXmDjk

Automated Acceptance Testing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this talk members of the core team showed how they have integrated `Codeception`_ into TYPO3 to
automate backend UI testing. Also they told why they prefer phantom JS over Firefox.

In addition they showed the `extension styleguide`_ and how you can benefit from the extension.
Mostly the task of the extension is to provide all possible markups for automated testing. But by
providing that, you as a developer or integrator can take a look at what markup is available to keep
your modules in sync with the rest of backend design. Also it will show you which form elements are
available for TCA and how you can combine them.

Further reading
---------------

Check out the full play list of recorded talks at Youtube `T3DD16 - TYPO3 Developer Days 2016`_.

Also you can take a look at the `official website`_.

.. _T3DD16 - TYPO3 Developer Days 2016: https://www.youtube.com/playlist?list=PL-sDBIrOKGOZvWAW3_7RW4FWLoO-Kxuzx
.. _Temporal Modelling: https://t3dd16.typo3.org/schedule/temporal-modelling
.. _Extremely defensive PHP: https://t3dd16.typo3.org/schedule/extremely-defensive-php
.. _Composer Composer Composer: https://t3dd16.typo3.org/schedule/composer-composer-composer
.. _A practical guide to vanilla web components: https://t3dd16.typo3.org/schedule/a-practical-guide-to-vanilla-web-components
.. _Automated Acceptance Testing: https://t3dd16.typo3.org/schedule/automated-acceptance-testing
.. _Codeception: http://codeception.com/
.. _official website: https://t3dd16.typo3.org/
.. _extension styleguide: https://typo3.org/extensions/repository/view/styleguide
