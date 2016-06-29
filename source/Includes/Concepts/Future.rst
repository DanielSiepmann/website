.. note::
    This can't be a promise. I will not promise to write these concepts, but this are some ideas
    I've in my mind and perhaps they will make it to a concept one day:

AtomicKitten
^^^^^^^^^^^^

At `web-vision`_ we have worked with `Patternlab`_. The idea behind this piece of PHP Software was
`atomic design`_.

AtomicKitten can be a new implementation based on atomic design. The reason to write a new
implementation is to have a more modern and proven source code. The following requirements should be
met:

- Exchange template engine

- Make extensions and modifications easy

- Easy usage of developed template with TYPO3 CMS, Flow and Neos

The current state of the project and concept can be found at
https://atomickittenframework.readthedocs.io/en/master/.

CodeMonitoring
^^^^^^^^^^^^^^

At `web-vision`_ we have also worked with `Sonarqube`_. Sonarqube is Java Software to monitor code
quality of a software project. The project itself can be of any supported language.

Most web developers are not into Java, but as Sonarqube is in Java, all rules have to be implemented
in Java.

Also we had some issues of incompatible ideas between software and us. The idea is to write the same
idea in PHP but more open and easy to extend. The software itself should no longer parse the source
and identify issues, but consists of parser for different formats like checkstyle.  Following *do
one thing and do it well* there is already software to analyse other software.  Output is e.g.
checkstyle or PHPUnit, PHPLoc, ... Just to name some of `phpqatools`_.  Like any Editor, the
software should provide an API and other editors can provide parser and importer to provide the
information.

Further packages should make use of the gathered information to show them as graphs, publish them in
chats or deliver e-mails. Also integrations in Github and other Code-Review tools should be
possible.

The current state of the project and concept can be found at
https://codemonitoring.readthedocs.io/en/feature-first-import-mechanism/.

Introducing agile working in web agencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All web agencies I've worked at, tried to introduce agile working. In my very personal opinion, that
didn't work well. Most likely because most people didn't really want to invest time to get into it.
Most people just didn't get the real point what it's all about.

They thought of agile like: Ok, we will do it agile now, then everything will be better and work.

But the same way of thinking didn't work with software before. Introducing something like a Wiki or
project management like Jira will not solve your issues. It's just a tool. You have to think about
your requirements and the current workflows. You need a tool that will be easy to adopt to your
needs and flows.

Also it's never done. You will evolve everyday, also your customers, technologies and workflows will
do. So should *your* agile do.

In the end to often old workflows not very compatible with agile, and showing they just didn't get
it are still there. Like micro management, time estimates instead of story points. Fix planned
projects that don't scale, or a team that has no scrum master and is left alone with all the new
things.

The idea would be to write down all the gathered experience, together with ideas how to overcome it
and make agile working in a German web agency. Why *German* web agency? I think most problems are
specific to Germany, but I also don't have any experience with web agencies outside of Germany.

Change your life with Kanban and Kaizen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After reading:

- `Spirit of Kaizen: Creating Lasting Excellence One Small Step at a Time
  <https://www.amazon.de/gp/product/0071796177/>`_,

- `One Small Step Can Change Your Life: The Kaizen Way
  <https://www.amazon.de/gp/product/0761129235/>`_,

- `Kanban: Evolutionäres Change Management für IT-Organisationen
  <https://www.amazon.de/gp/product/3898647307/>`_

- `Japanische Erfolgskonzepte: KAIZEN, KVP, Lean Production Management, Total Productive Maintenance
  Shopfloor Management, Toyota Production Management, GD³ - Lean Development
  <https://www.amazon.de/gp/product/3446418830/>`_

You will see that Kanban and Kaizen are not only for car manufactures, American industry and modern
software development, but also for you personal.

The idea is to write down the ideas mentioned in the books and concrete usages for you personally.
So beside what this methods can do for a company, what can they do for you? How, why and when can
you apply them to your personal live? Where can they help and what can you achieve with them?

.. _web-vision: https://web-vision.de/
.. _Patternlab: http://patternlab.io/
.. _Sonarqube: http://www.sonarqube.org/
.. _atomic design: http://bradfrost.com/blog/post/the-part-and-the-whole/
.. _phpqatools: http://phpqatools.org/
