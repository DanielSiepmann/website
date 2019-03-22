.. highlight:: bash
.. post:: Sep 09, 2016
   :tags: git, vcs
   :category: Talk
   :location: Vimfest Berlin
   :excerpt: 2

.. _introduction-to-git-for-daily-usage:

Talk: Introduction to Git for daily usage
=========================================

This talk will be held at `Vimfest`_ 2016 in Berlin. It will introduce you to `Git`_ and provide the
minimum necessary information to get started using Git on a daily basis.

This post is about the content of the talk and a basic introduction without the hands on.

.. caution::

   It's not a full blown tutorial, or documentation, there are enough already.

   Some are referenced at the end.

What is Git?
------------

Git is a version control system (=VCS). Version control systems are used to keep track of different
versions of something, e.g. of code, documents or something else. Some operating systems  like Mac
OS already implement such a system.

Beside Git there are some other VCS like `Hg`_ or Mercurial, `SVN`_ and some more.

Some, especially older systems, are centralized solutions while Git is decentralized (=DVCS).

Decentralized in this context means you can have your system distributed, e.g. you have the
necessary information on Services like `Github`_ or `Bitbucket`_ but also on your local machine and
server.

Why should I use Git?
---------------------

With Git you can take a look back how your documents, website or code has look.

Also you can revert changes or develop multiple features at the same time.

Also Git allows you to synchronize some state between different remotes like your server, mobile
devices like laptop, and local devices like desktop computers.

Git supports collaboration as someone can see your code, e.g. at Github. He can check it out, change
some parts, and share the changes with you.

When should I use Git?
----------------------

Really just ever. There is so less overhead by using Git but so much benefit.

Here are some ideas for what kind of things you can, and should, use Git:

Website
    E.g. HTML, JS, and server side code.
    Also static websites or website generation e.g. through tools like `Jekyll`_ or `Sphinx`_.

Code
    Whether it's a small script or a huge code base for a program.
    We are keeping track of our deployment bash scripts via Git and deploy them to our `Bamboo`_.

    Also `Github`_ provides so called *Gists* which are small snippets that can consist of multiple
    files. They are available at https://gist.github.com/ .

Concepts
    Whether you write them as markdown, rst or Word and Open Office documents. They are just text or
    xml and are easy to track.

Documents
    As with concepts, most documents are saved in a text format that can be tracked.

    Did you know dropbox has builtin versioning? Take a look at Blog post
    :ref:`post-versioning-revert-old-files`.

Knowledge exchange
    There are `awsome lists`_ on Github where users collaborate on via Git. It's like Wikipedia.

The only part where tools like Git are not that helpful are binary files like images or compiled
code. As they keep track of changes and one change on a binary file will change the whole file.

But there is also some development going on to make Git used to work with large binary files.

How can I use Git?
------------------

First of all you need to install Git. On some systems Git comes pre installed, like Mac. Otherwise
use your favourite package manager to install Git or download from official source at `Git Download`_.

Then you can start using the CLI via ``git``.

Also there is a great Vim Plugin called `fugitive`_ by Tim Pope.

For GUIs take a look at the :ref:`git-clients`.

Everything else, like the commands and workflows are already summed up on so many tutorials, just
check out the section :ref:`git-daily-usage-further-reading`. Everything else will be explained
during the talks.

It's planed to record the talk, if so, you will find the video here, once the talk is published.
Also the "presentation" will be published afterwards.

Typical workflows
-----------------

Below you can find two typical workflows that are true independent on your work, whether you are
coding or working with documents. All this workflows will be covered during the talk.

Create new repository
^^^^^^^^^^^^^^^^^^^^^

#. Initialize new git repository

#. Make some changes

#. Add and commit changes

#. Create a remote somewhere like `Github`_

#. Push changes

Work on multiple things
^^^^^^^^^^^^^^^^^^^^^^^

#. Create new branch

#. Make some changes

#. Add and commit changes

#. Switch branch

Work with multiple remotes
^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Add remote

#. Push to remote

#. Fetch from remote

#. Force push

Merging / Rebasing
^^^^^^^^^^^^^^^^^^

* What is merging, what is rebasing?
  
* What's the difference?

* How to merge, using ``vimdiff`` or GUI.

* How to rebase.

Github
^^^^^^

* What is github?

* How to use github.

.. _git-daily-usage-further-reading:

Further reading
---------------

.. * `Video of the talk <>`_

.. * :ref:`Presentation <presentation-introduction-to-git-for-daily-usage>`

* `Official git website <https://git-scm.com/>`_

* `Official online interactive tutorial <https://try.github.io/levels/1/challenges/1>`_

* `Official online book <https://git-scm.com/book/en/>`_

* `List of version control software on english wikipedia
  <https://en.wikipedia.org/wiki/List_of_version_control_software>`_.

.. _git-clients:

Clients
^^^^^^^

* `tig open source (CLI, all platforms) <https://github.com/jonas/tig>`_

* `GitKraken GUI for all platforms <https://www.gitkraken.com/git-client>`_

* `Sourcetree by atlassian (GUI for Mac and Windows) <https://www.sourcetreeapp.com/>`_

* `Further official List of GUI clients <https://git-scm.com/downloads/guis>`_

Enhancements
^^^^^^^^^^^^

* `diff-highlight <https://github.com/git/git/tree/master/contrib/diff-highlight>`_ to highlight
  Inline differences on CLI.

* `Meld <http://meldmerge.org/>`_ cross platform merge UI.

Also interesting
^^^^^^^^^^^^^^^^

* Blog post: :ref:`post-readthedocs-sphinx-plantuml`

* Blog post: :ref:`post-versioning-revert-old-files`

.. _Vimfest: https://vimfest.org/
.. _Git: https://git-scm.com/
.. _Hg: https://www.mercurial-scm.org/
.. _SVN: https://subversion.apache.org/
.. _Github: https://github.com/
.. _Bitbucket: https://bitbucket.org/
.. _Git Download: https://git-scm.com/download
.. _Jekyll: https://jekyllrb.com/
.. _Sphinx: https://www.sphinx-doc.org/en/stable/
.. _Bamboo: https://www.atlassian.com/software/bamboo
.. _awsome lists: https://github.com/sindresorhus/awesome
.. _fugitive: https://github.com/tpope/vim-fugitive
