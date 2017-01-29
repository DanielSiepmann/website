.. highlight:: vim
.. _project-vim-jira-wrapper:

Vim Jira Wrapper
================

About
-----

Inspired by existing Vim plugin `vim-jira`_ I forked the plugin and first tried to extend the
plugin. While still awesome command line wrapper for Jira exist, like `Ruby Gem JIRA CLI`_ it made
more sense to build a wrapper for the existing solution.

Dependencies
------------

Therefore the plugin is a plain wrapper to integrate `Ruby Gem JIRA CLI`_ into Vim. You need to
install the gem first and can use it from within Vim afterwards.

Usage
-----

You can interact with ruby gem by using the command::

    :Jira issue jql assignee = 'your shortcut'

The command ``:Jira`` wraps the system call and opens the output as vertical split. This way all
provided commands are available.

Also the command ``:JiraIssue`` exists which takes one argument, the Jira Issue ID. E.g. you
triggered a query before, you can browse to an issue by moving the cursor over the issue ID and
use::

    :JiraIssue <C-R><C-A>

to autocomplete the WORD under cursor, the issue id.

See `CTRL-R CTRL-A`_ from official Vim Help.

Project home
------------

The repository / project can be found on Github: https://github.com/DanielSiepmann/vim-jira-wrapper

.. _vim-jira: https://github.com/cdonnellytx/vim-jira
.. _Ruby Gem JIRA CLI: https://github.com/ruby-jira/jira-cli
.. _CTRL-R CTRL-A: http://vimdoc.sourceforge.net/htmldoc/cmdline.html#c_CTRL-R_CTRL-A
