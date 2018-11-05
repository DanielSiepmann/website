.. post:: Nov 05, 2018
   :tags: typo3, camp, testing, gitlab-ci, events
   :excerpt: 2

TYPO3 Camp Rhein Ruhr 2018 - Recap
==================================

This is my personal recap of this years TYPO3 Camp Rhein. Especially as this is a
German speaking camp.

I'll publish the recap in English, so everyone not capable of understanding the
Youtube videos or slides, has a chance to at least know what happened.

Personal pre event two days before
----------------------------------

Right the day before official start of work shops, `@Jens_der_Denker`_,
`@spooner_web`_ and myself met. Jens and me set up a basic TYPO3 deployment at
`bitbucket.org`_ using `Bitbucket Pipelines`_.

At the evening we went to some Italian restaurant for socializing.

Workshops the day before
------------------------

The official event started with workshops at Friday morning. Thanks to the awesome
location, the `Unperfekthaus`_, we had a nice Brunch.

There were in total four parallel workshops:

- TYPO3, from 0 to 100 by `Oliver Thiele`_

- TYPO3, Introduction into Extension development using Extbase by myself.
  Course material, in English, are available here:
  https://tmp.daniel-siepmann.de/events/t3crr18/workshop-extension/

- Codeception Tests in TYPO3 Extensions by `Roland Golla`_

- Continuous Integration and Deployment using GitLab by `Thomas Löffler`_

Pre event Slot-Car Race
-----------------------

Friday ended with the social event in the evening. Two slot car racing tracks with 8
slots each were available. Together with table football and dinner, this was the best
pre event I had so far.

Each player had in total 7 to 8 races, so everyone had a fair chance and used each
slot and car once. The top 4 racers from each tracks were the finalists and played a
last time.

Myself only was 7th, but had the fastest lap in the final!

Saturday
--------

The Saturday, of course, started with brunch and the opening, followed by session
planning. The session plan, in German, is available at
https://www.typo3camp-rheinruhr.de/sessions/2018/samstag.html.

As I had birthday, together with two others, everyone wished us all the best with a
short song.

I went to the following sessions. Not much, but there was time enough to meet all the
great people from the community.  Also you could use the free time to help out each
other with problems.

Deployable Records by `@ArminVieweg`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

He shared the current concepts and state of the new extension.  The main goal is
to make it easy to synchronize configured records between multiple TYPO3
installations. E.g. share a ``sys_template`` record between production,
integration, staging and local environment.

Therefore PageTS is used for configuration, yaml or json is used to store the
records, and one does not need to take care of uids anymore.

The extension will auto update constants to match the uids out of the box!

This looked very promising for agencies and freelancers that run into the problems
to keep such things in sync.

We currently prevent such issues by following this approach:

For each necessary page where the uid needs to be known, e.g. a detail page where
one would configure the uid within TypoScript, we will create this page in
production while keeping it hidden. We then will create this page in our local
environment and setup everything. Stuff that needs to be done within the database,
e.g. insert a plugin record, are done with upgrade wizards. We use them like
doctrine migrations. They have an method to check whether they need to run and an
method to execute the necessary steps.

While the extension definitely makes things easier, we will keep our workflow for
now.

TYPO3 Surf by `@t3easy_de`_ and `@schreiberten`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both took over the responsibility for TYPO3 Surf from Helmut Hummel. They showed the
current state and that Surf is nearly feature complete right now, only missing
documentation. But as this is the only missing piece, they are currently working on
the docs.

TYPO3 Surf provides the huge benefit that it comes with defaults to deploy TYPO3 out
of the box. TYPO3 Surf itself is a Symfony command line application that provides and
easy way to configure software deployments using PHP.

We will check out TYPO3 Surf and further solutions, which might replace our currently
solution using GitLab-CI, with plain bash commands. Instead we might replace this
with GitLab-CI and TYPO3 Surf, or some other solution, in the future.

This way you will get some benefits out of the box, e.g. a pre deployment where you
can run smoke tests, rollback to the latest release if something will break during
the deployment.

Accessibility by `@computerzauber`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`@computerzauber`_ allowed us to use her wheelchair to drive a round out of the room and
back. Also `@web2date`_ pushed us a round inside the wheelchair. She already helped
@computerzauber during one of the previous events.

Beside this very unique experience, @computerzauber explained us some situation a
wheelchair driver experiences and how everyone could help.

This was a very special session, quite interesting and helpful.

Sponsoring Meeting
^^^^^^^^^^^^^^^^^^

As this was the first Camp we sponsored, by we I mean our new founded company
`Codappix GmbH`_, we were invited together with all sponsors to a small session.
Everyone got his sign for sponsoring and one could exchange some information.

Hacker Jeopardy
^^^^^^^^^^^^^^^

The last session was the Hacker Jeopardy, quite funny and with categories like TYPO3
Event Shirts, or Persons and "sin in youth". Funny and educational everyone learned
some new exploits or facts regarding TYPO3.

Video recording
---------------

All sessions within room 404 were recorded, thanks to the `@joomla`_ video team, in
person `@jeha_cgn`_. This again shows how awesome OpenSource can be. Joined forces by
competitors in the CMS ecosystem, junited by one mission, like already through
CMS Garden.

Interviews
----------

Beside the sessions, the organizers asked for interviews. These will be published, in
German, at their `Youtube channel`_. And I'm proud to be asked. Some questions
contained: When did you start with TYPO3? What's the most important extension for
you? Where do you see TYPO3 be in 10 years?

Dinner and Whiskey Tasting
--------------------------

In the afternoon everyone had dinner and some went to the whiskey tasting afterwards.
As `@extcoder`_ asked me to explain how to run acceptance tests for TYPO3 extensions
within GitLab-CI, I've invested the evening by figuring out how to do this. After 6
hours I had a running setup.

Sunday
------

The Sunday, of course again, started with brunch and the session planning. The
session plan, in German, is available at
https://www.typo3camp-rheinruhr.de/sessions/2018/sonntag.html.

I went to the following sessions.

TYPO3 & agencies by `@mattLefaux`_ and `@benjaminkott`_
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This session was a discussion and outlook into TYPO3s and TYPO3 agencies future.

Current plans are to make TYPO3 CMS feature complete by the release of CMS v10. Where
feature complete doesn't mean there will be no further releases. But TYPO3 will cover
all necessary CMS features we know right now.

Everyone is invited to provide feedback to the core team. E.g. `@jweilandnet`_ had a
feature request that makes sense inside the core.

Also upgrades will be easier again, freeing up time. So agencies will no longer make
money with updates, like they do right now. It will become a much smaller part for
agencies and freelancers.

By not making money with updates anymore, one needs to find our ways, e.g.
consulting.

TYPO3 will also improve further with partners like Google Ads to provide helpful
features out of the box.

Current plans for TYPO3 CMS 10 will be:

Consistent data API
   Replacing current DataHandler, Extbase persistence, FormFinisher. See:
   https://typo3.org/community/teams/typo3-development/initiatives/persistence/

Rewritten Filemodule
   The current backend module for files is not state of the art. It will be developed
   from scratch, and `@benjaminkott` already showed some early layout ideas.

GitLab-CI TYPO3 - Functional - Acceptance Testing by myself
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As written earlier, `@extcoder`_ asked me to provide information about this topic. As
I'm not an expect with Codeception and acceptance testing, I added some information
about functional testing your TYPO3 content elements.

First of all I showed the running GitLab-CI setup, with TYPO3 and Codeception
acceptance testing. This example is available at GitHub:
https://github.com/DanielSiepmann/workshop-gitlab-acceptance As of time writing,
there is no readme or anything else provided. `@lolli42`_ might provide official
documentation in the upcoming weeks, so I did not plan to extend the information.

Just check out the :file:`.gitlab-ci.yml` for information about how to setup the
environment and how to run the tests.

Also I had some time to show how we have added functional tests for content elements
for one of our customers. Right now we have more then 200 functional tests for our
content elements covering all possible combinations of user input. As the customer is
running a CMS v7 right now, we added the tests to make update to v8 and v9 possible.
Also we need to refactor some parts in the future.

Thanks
------

The TYPO3 Camp Rhein Ruhr was my very first camp back in time, and it's always the
last camp in each year. Thanks to the huge organization team and the very unique
location with endless food and drinks, it's one of the best camps so far.

This year I've visited every single TYPO3 Camp in DACH region, together with TYPO3
Camp Venlo, the Developer Days (thanks to `@merzilla`_ who gave me his ticket) and
CertiFunCation day.

Every single camp is special and unique, you meed different people from the community
and enjoy all the talks.

I'm looking forward to the next year where my company will try to sponsor me, so I'll
be there, at every single camp, again next year. We will also sponsor TYPO3 Camp
Rhein Ruhr again next year.

.. _@Jens_der_Denker: https://twitter.com/Jens_der_Denker
.. _@spooner_web: https://twitter.com/spooner_web
.. _bitbucket.org: https://bitbucket.org/
.. _Bitbucket Pipelines: https://bitbucket.org/product/features/pipelines
.. _Unperfekthaus: https://www.unperfekthaus.de/
.. _Oliver Thiele: https://www.oliver-thiele.de/
.. _Roland Golla: https://blog.nevercodealone.de/author/rolandgolla/
.. _Thomas Löffler: https://spooner-web.de/
.. _Youtube channel: https://www.youtube.com/channel/UCf7X1_kAE3IWBLe6dyzVi9g
.. _@joomla: https://twitter.com/joomla
.. _@jeha_cgn: https://twitter.com/jeha_cgn
.. _CMS Garden: https://www.cms-garden.org/
.. _@ArminVieweg: https://twitter.com/ArminVieweg
.. _@t3easy_de: https://twitter.com/t3easy_de
.. _@schreiberten: https://twitter.com/schreiberten
.. _Codappix GmbH: https://www.codappix.com/
.. _@extcoder: https://twitter.com/extcoder
.. _@mattLefaux: https://twitter.com/mattLefaux
.. _@benjaminkott: https://twitter.com/benjaminkott
.. _@jweilandnet: https://twitter.com/jweilandnet
.. _@lolli42: https://twitter.com/lolli42
.. _@merzilla: https://twitter.com/merzilla
.. _@computerzauber: https://twitter.com/computerzauber
.. _@web2date: https://twitter.com/web2date
