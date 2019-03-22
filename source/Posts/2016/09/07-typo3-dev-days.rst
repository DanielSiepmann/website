.. post:: Sep 07, 2016
   :tags: typo3, event
   :location: Nuremberg, Germany
   :excerpt: 2

TYPO3 Developer Days 2016 in Nuremberg - Recap
==============================================

The TYPO3 Developer Days 2016 in Nuremberg took place from 01. Sep to 04. Sep in the youth hostel of
Nuremberg. During these days multiple prepared talks were presented, together with a coding night of
the Core Team where everyone could jump in.

In this post I'll recap the event and some talks I've participated on. All talks that were recorded
during the event are available on Youtube as playlist `T3DD16 - TYPO3 Developer Days 2016`_.

Day 1
-----

The first day was really all about developers. With the talks about `Temporal Modelling`_ and
`Extremely defensive PHP`_ which everyone could attend as they happened one after another. Except if
you wanted to prepare for the Developer Certification on next day, as the preparation was at the
same time as Extremely defensive PHP.

While the first talk `Temporal Modelling`_ was about concepts and how you should model your
application, the second one `Extremely defensive PHP`_ was more about concrete code.

Temporal Modelling
^^^^^^^^^^^^^^^^^^

The talk was all about the way how to model your application. It was not about such concrete things
like UML and diagrams, but more about the process and way to think. The basic message was to think
more event driven. As your application reacts to events, not only if you are building an web
application using JavaScript, but also if you are using PHP. Also you should discuss the design
during the modelling inside the team.

The user always interacts through events with your application, not in a technical way, but a way of
behaviour. The user doesn't think the way as we are doing in specs right now. Most are designing the
domain by thinking of objects containing data and changing their state over time. E.g. in a web shop
you will have a model representing an order, where the state will change over time from "open" to
"payed".

But what really happens is that you create the order once. Then some events occur like the user
receives an e-mail with invoice. The user interacts and pays the invoice, which is another event. If
you are thinking in the way of events, you build a history on top of the object and the initial
state.

That will bring some benefits like:

- Collecting information for analytics.
  E.g. how many aborted the process.

- Checkout the application at any state, as you can reconstruct it through the history by
  reapplying the events on the initial state.

- While designing the application, you will detect open questions and design issues.
  As you are thinking through events like "a product will be deleted" you might easier see issues
  like "what happens to orders or baskets that have a relation to the current product?"

The full talk is available on Youtube:

:youtubevideo:`T3DD16 Temporal Modelling with Mathias Verraes - TYPO3 Developer Days 2016 Nuremberg <q2rCRhtEHZ0>`

Extremely defensive PHP
^^^^^^^^^^^^^^^^^^^^^^^

This talk was already presented at the PHP Usergroup Düsseldorf. It was about how you should code to
not allow other developers to break your application. This was mostly addressed to projects like
TYPO3 which are open source and where a large group of developers, not developing the software
itself but interacting through API. But this is also useful for large scale projects where intern
developers misuse the internal APIs and where components provide their own API.

There were many recommendations you can apply during your daily work. Most of them might look very
strange and rude at first. But you should take another look at the talk after half a year and you
will notice how different you will think about most parts. They make sense to you and you will try
to use them also in projects where no one else is working on, as most of them will show you design
issues while you try to extend your own API.

It's basically just about good design and what you *can do* with PHP, but *should not do*. It's like
"*bad Parts of PHP*" which you can, but should not do.

The full talk is available on Youtube:

:youtubevideo:`T3DD16 Extremely defensive PHP with Marco Pivetta - TYPO3 Developer Days 2016 Nuremberg <ML-lqk_Rbew>`

Day 2
-----

Second day was, of course, also about developing. It started with `Composer Composer Composer`_,
goes over to `A practical guide to vanilla web components`_ and ended with `Automated Acceptance
Testing`_ 

Composer Composer Composer
^^^^^^^^^^^^^^^^^^^^^^^^^^

Helmut Hummel gave an overview why TYPO3 is using composer, what has changed by using composer and
what are the plans for the future. Of course there were no promises, but topics the team is already
working on and the team will work on in the future. Also he explained some details and benefits of
composer, which are not only related to TYPO3.

It was also an introduction how to use composer with TYPO3.

The full talk is available on Youtube:

:youtubevideo:`T3DD16 Composer Composer Composer with Helmut Hummel - TYPO3 Developer Days 2016 Nuremberg <yJRla3UCb-s>`

A practical guide to vanilla web components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Leon Revill introduced why you should use web components, what web components are and that you can
actually use them, thanks to Polyfills, in all browsers. In his opinion they will rule the web and
are the biggest change the web has seen so far.

Mostly they are a combination of different features and standards, allowing you to build something
like a progress bar or calendar widget for inputs. This components them self encapsulate the
containing necessary HTML, JS and CSS and are mostly immutable to the outside. Only certain parts
can be made available to the public. E.g. through CSS variables or slots in HTML. Also an JS API can
be exposed for external interactions.

Some fancy stuff like mobile slide menus can be build with this techniques. The real benefit of web
components: They are reusable through all projects.

The full talk is available on Youtube:

:youtubevideo:`T3DD16 Practical guide to vanilla web comp. with Leon Revill - TYPO3 Developer Days 2016 Nuremberg<Paste> <uX06JvXmDjk>`

Automated Acceptance Testing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this talk members of the core team showed how they have integrated `Codeception`_ into TYPO3 to
automate backend UI testing. Also they told why they prefer phantom JS over Firefox.

In addition they showed the `extension styleguide`_ and how you can benefit from the extension.
Mostly the task of this extension is to provide all possible markups for automated testing. But by
providing that, you as a developer or integrator can take a look at what markup is available to keep
your modules in sync with the rest of backend design. Also it will show you which form elements are
available for TCA and how you can combine them.

Coding Night
^^^^^^^^^^^^

During the coding night, we had a nice discussion, all night long, about documentation. `Harry
Glatz`_ initiated the discussion with `Patrick Broens`_ who is part of the core team.

The mean reason for the discussion was the current state. TYPO3 already has some documentation but
not at a central place. You can find, more or less official, documentation on many places like wiki,
typo3.org, docs.typo3.org, forge and even these resources have duplicated documentation in different
states.

We will see what will change in the future. At the moment `Martin Bless`_ is working on a new
pipeline to bring the documentation even further and inform authors about deployed versions and
issues.

Day 3
-----

On third day, tired after the long discussion, I didn't participate on much talks, but still at one.
As the talks before, check out the playlist `T3DD16 - TYPO3 Developer Days 2016`_.

Pushing the limits of PHP with React PHP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Christian Lück`_ presented `React PHP`_ on the main stage reaching out for a large audience. He
could introduce everyone into what React PHP is and what you can achieve by using React PHP.

Everyone got a beer from the Redis Server implemented by React PHP and everyone talked to everyone
through the small chat via telnet. Once the demonstration was done, the workshop started. As I
already had some experience with React PHP I didn't participate.

The mean reason for React PHP is non blocking I/O, e.g. web requests through APIs or file system.

:youtubevideo:`T3DD16 Pushing the limits of PHP with React PHP with Christian Lück - TYPO3 Developer Days 2016 <giCIozOefy0>`

Social Event
^^^^^^^^^^^^

In the afternoon and during the night was the social event with a lot of alcohol, for everyone else,
and BBQ.

Day 4
-----

After the coding night and social event, I just was tired, didn't participate in any other talks and
was happy to went back home after this great event.

Lightning Talks
^^^^^^^^^^^^^^^

During the whole developer days, the speaker hat the lightning talks to present their talk and
gather attention, a really nice concept to align expecting poses.

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
.. _Codeception: https://codeception.com/
.. _official website: https://t3dd16.typo3.org/
.. _extension styleguide: https://typo3.org/extensions/repository/view/styleguide
.. _Harry Glatz: https://twitter.com/randomresult
.. _Patrick Broens: https://twitter.com/aurora_borealis
.. _Martin Bless: https://twitter.com/marantern
.. _Christian Lück: https://twitter.com/another_clue
.. _React PHP: https://reactphp.org/
