.. highlight:: bash

.. post:: Jun 11, 2016
   :tags: docs, sphinx, plantuml

.. _post-readthedocs-sphinx-plantuml:

Workflow for: Read the docs, Sphinx and Plantuml
================================================

Documentation was never easier, with a Framework like `Sphinx`_ and a hoster like `Read the docs`_.
All you need is a repository containing your Documentation written with Sphinx and an account at
Read the docs. `Plantuml`_ can be used in addition to generate UML-Diagrams using plain text. The
result can be SVG files in the same color as your Documentation.  The whole setup and workflow for
that will be explained in this Blog post. After reading the post, you are able to kickstart a new
documentation and host it at Read the docs. You then can dig deeper and adjust it to your needs.

All instructions are tested on OS X, I'll not document for Windows. Unix systems should be the same
as OS X and you probably already know how to do it yourself.

Sphinx
------

First let's start with Sphinx to get a first documentation rendered on the local machine.

Install
^^^^^^^

To use Sphinx, we need to install it. Up to date instructions can be found at `Installing Sphinx`_.

Basically you can install via::

    pip install -U Sphinx

Start documenting
^^^^^^^^^^^^^^^^^

To start your documentation sphinx provides a CLI tool to create a new project::

    sphinx-quickstart

It's interactive and will ask all necessary information.

An example setup will look like:

.. code-block:: text

    Welcome to the Sphinx 1.4.3 quickstart utility.

    Please enter values for the following settings (just press Enter to
    accept a default value, if one is given in brackets).

    Enter the root path for documentation.
    > Root path for the documentation [.]: example-documentation

    You have two options for placing the build directory for Sphinx output.
    Either, you use a directory "_build" within the root path, or you separate
    "source" and "build" directories within the root path.
    > Separate source and build directories (y/n) [n]: y

    Inside the root directory, two more directories will be created; "_templates"
    for custom HTML templates and "_static" for custom stylesheets and other static
    files. You can enter another prefix (such as ".") to replace the underscore.
    > Name prefix for templates and static dir [_]: 

    The project name will occur in several places in the built documentation.
    > Project name: Example for Blogpost
    > Author name(s): Daniel Siepmann

    Sphinx has the notion of a "version" and a "release" for the
    software. Each version can have multiple releases. For example, for
    Python the version is something like 2.5 or 3.0, while the release is
    something like 2.5.1 or 3.0a1.  If you don't need this dual structure,
    just set both to the same value.
    > Project version: 1.0.0
    > Project release [1.0.0]: 

    If the documents are to be written in a language other than English,
    you can select a language here by its language code. Sphinx will then
    translate text that it generates into that language.

    For a list of supported codes, see
    http://sphinx-doc.org/config.html#confval-language.
    > Project language [en]: 

    The file name suffix for source files. Commonly, this is either ".txt"
    or ".rst".  Only files with this suffix are considered documents.
    > Source file suffix [.rst]: 

    One document is special in that it is considered the top node of the
    "contents tree", that is, it is the root of the hierarchical structure
    of the documents. Normally, this is "index", but if your "index"
    document is a custom template, you can also set this to another filename.
    > Name of your master document (without suffix) [index]: 

    Sphinx can also add configuration for epub output:
    > Do you want to use the epub builder (y/n) [n]: n

    Please indicate if you want to use one of the following Sphinx extensions:
    > autodoc: automatically insert docstrings from modules (y/n) [n]: n
    > doctest: automatically test code snippets in doctest blocks (y/n) [n]: n
    > intersphinx: link between Sphinx documentation of different projects (y/n) [n]: y
    > todo: write "todo" entries that can be shown or hidden on build (y/n) [n]: y
    > coverage: checks for documentation coverage (y/n) [n]: n
    > imgmath: include math, rendered as PNG or SVG images (y/n) [n]: n
    > mathjax: include math, rendered in the browser by MathJax (y/n) [n]: n
    > ifconfig: conditional inclusion of content based on config values (y/n) [n]: n
    > viewcode: include links to the source code of documented Python objects (y/n) [n]: n
    > githubpages: create .nojekyll file to publish the document on GitHub pages (y/n) [n]: n

    A Makefile and a Windows command file can be generated for you so that you
    only have to run e.g. `make html' instead of invoking sphinx-build
    directly.
    > Create Makefile? (y/n) [y]: y
    > Create Windows command file? (y/n) [y]: n

    Creating file example-documentation/source/conf.py.
    Creating file example-documentation/source/index.rst.
    Creating file example-documentation/Makefile.

    Finished: An initial directory structure has been created.

    You should now populate your master file example-documentation/source/index.rst and create other documentation
    source files. Use the Makefile to build the docs, like so:
    make builder
    where "builder" is one of the supported builders, e.g. html, latex or linkcheck.


As Sphinx is written in Python and used to document Python modules, most extensions can be omitted
for your documentation, until you are working with Python code.

I definitely recommend to enable ``todo`` and ``intersphinx`` all the time. Also ``ifconfig`` can be
helpful. But it's just the kickstart and you can add extensions later on inside the configuration.

Also do yourself a favour and create the :file:`Makefile` for easier usage.

Sphinx will setup a structure like:

.. code-block:: text

    .
    └── example-documentation
        ├── Makefile
        ├── build
        └── source
            ├── _static
            ├── _templates
            ├── conf.py
            └── index.rst

    5 directories, 3 files

You now can render the documentation by calling::

    make html

Sphinx will generate the full HTML and write it to :file:`build/html`. You can open the
documentation using::

    open ./build/html/index.html

The first output will look like:

.. image:: /images/2016/06-11-read-the-docs-sphinx-plantuml-workflow/FirstResult.png
   :alt: A first result after kickstart and first generation.

You can now start writing the documentation, following the `Sphinx Documentation`_, and adjust the
look and feel, e.g. change the theme using one of the `builtin Themes`_.

Github
------

To make integration with Read the docs easier, we will publish our documentation as a Git repository
to Github.

First of all you need to initialize a new Git-Repository, of course you can also use Mercurial or
something else. Do so by running::

    echo "build" > .gitignore && git init && git add . && git commit -m "First version"

Next sign up at `Github`_ if you don't have an account yet. `Create a repository
<https://github.com/new>`_, which is only possible if you are logged in. Github should redirect you
to your new repository with a URL scheme like ``<UserName>/<RepositoryName>``.  Add the repository
at Github to your local repository by running::

    git remote add origin https://github.com/<UserName>/<RepositoryName>.git && git push --mirror

If you reload the web Gui of Github you should see a first commit.

Github provides full documentation at https://help.github.com/ if something is not clear or you need
further help setting everything up.

Read the docs
-------------

To host our documentation without the need to setup the rendering or web space, we will use Read the
docs.

Therefore `register at Read the docs`_, and `connect
<https://readthedocs.org/accounts/social/connections/>`_ the account to your Github account. You can
now see all your Github repositories and `select <https://readthedocs.org/dashboard/import/?>`_ the
created one to automatically render the documentation on new commits.

.. image:: /images/2016/06-11-read-the-docs-sphinx-plantuml-workflow/ReadTheDocs-Connection.png
   :alt: Read the docs interface to connect with Github and Bitbucket.

.. image:: /images/2016/06-11-read-the-docs-sphinx-plantuml-workflow/ReadTheDocs-Import.png
   :alt: Read the docs interface to import repositories from Github.

You are now ready to go, Read the docs should already render your documentation. You have an
overview at https://readthedocs.org/dashboard/ where your project should appear. Navigate to the
project by clicking the title and you should the *Last Built* on the right mentioning whether
everything worked. Also at top you have a navigation. Go to *Builds* and you can get an detailed
view what was going on and where something broke.

To setup further branches in your repository to render, head to *Versions* and set them up.

The green Button *View Docs* will bring you to your generated documentation. It's already online and
all you have to do in the future is to do a::

    git commit -m "Made changes" && git push

Read the docs will detect the changes and render your documentation.

Plantuml
--------

Everything is working now. Let's add some sugar with nice looking UML diagrams to explain the
structure of our project, or some complex workflows.

To provide nice looking UML diagrams like:

.. image:: /images/2016/06-11-read-the-docs-sphinx-plantuml-workflow/Example.png
   :alt: Example documentation, rendered ad Read the docs, with PlantUml image.

We will use PlantUml. As it's not available as a Debian package yet, Read the docs doesn't provide
rendering for it. So you have to render the images on your local machine and provide them to Read
the docs.

Install
^^^^^^^

First of all you need to install Java and Graphviz to draw the diagrams. Head over to
http://plantuml.com/starting and http://plantuml.com/faq-install to follow the
installation.

Provide wrapper
^^^^^^^^^^^^^^^

After PlantUml is on your local system, make your live easier by providing the following shell
script inside your ``$PATH`` to just call ``plantuml`` in the future anywhere on your CLI::

    #!/usr/bin/env sh -e
    java -Djava.awt.headless=true -jar $HOME/Applications/plantuml.jar -tsvg -failfast2 "$@"

Adjust the path according to your location of :file:`plantuml.jar`. This wrapper will run PlantUml
without the GUI, and generate SVGs as default for all provided PlantUml source files.

Integration into Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To integrate PlantUml into your Sphinx documentation, you can setup the following structure:

.. code-block:: text

    .
    └── example-documentation
        ├── Makefile
        ├── build
        └── source
            ├── uml
            │   └── example.uml
            ├── _static
            ├── _templates
            ├── conf.py
            └── index.rst

    6 directories, 4 files

And adjust your :file:`Makefile` to render all PlantUml files for you.

Add the following entry to your :file:`Makefile`:

.. code-block:: makefile

    plantuml:
        plantuml -psvg -o ../images/uml/ ./source/uml/*.uml

You now can call::

    make plantuml

That will create a new folder with generated images:

.. code-block:: text

    .
    └── example-documentation
        ├── Makefile
        ├── build
        └── source
            ├── images
            │   └── uml
            │       └── example.svg
            ├── uml
            │   └── example.uml
            ├── _static
            ├── _templates
            ├── conf.py
            └── index.rst

    8 directories, 5 files

To include the diagram into your documentation, use the ``image`` or ``figure`` directive of rst.

To ease workflow, adjust your :file:`Makefile` further to run ``plantuml`` also for ``html`` and
such by using:

.. code-block:: makefile

    html: plantuml

Adjust look
^^^^^^^^^^^

At the moment we will get the default styling of PlantUML which is not nice in our Template. You can
adjust the styling by providing the a file called :file:`plantuml.cfg` with the following content:

.. code-block:: text


    skinparam backgroundColor white

    skinparam note {
        BackgroundColor #F1FFFF
        BorderColor #2980B9
    }

    skinparam activity {
        BackgroundColor #BDE3FF
        ArrowColor #2980B9
        BorderColor #2980B9
        StartColor #227BC6
        EndColor #227BC6
        BarColor #227BC6
    }

    skinparam sequence {
        ArrowColor  #2980B9
        DividerBackgroundColor  #BDE3FF
        GroupBackgroundColor    #BDE3FF
        LifeLineBackgroundColor white
        LifeLineBorderColor #2980B9
        ParticipantBackgroundColor  #BDE3FF
        ParticipantBorderColor  #2980B9
        BoxLineColor    #2980B9
        BoxBackgroundColor  #DDDDDD
    }

    skinparam actorBackgroundColor #FEFECE
    skinparam actorBorderColor    #A80036

    skinparam usecaseArrowColor   #A80036
    skinparam usecaseBackgroundColor  #FEFECE
    skinparam usecaseBorderColor  #A80036

    skinparam classArrowColor #A80036
    skinparam classBackgroundColor    #FEFECE
    skinparam classBorderColor    #A80036

    skinparam objectArrowColor    #A80036
    skinparam objectBackgroundColor   #FEFECE
    skinparam objectBorderColor   #A80036

    skinparam packageBackgroundColor  #FEFECE
    skinparam packageBorderColor  #A80036

    skinparam stereotypeCBackgroundColor  #ADD1B2
    skinparam stereotypeABackgroundColor  #A9DCDF
    skinparam stereotypeIBackgroundColor  #B4A7E5
    skinparam stereotypeEBackgroundColor  #EB937F

    skinparam componentArrowColor #A80036
    skinparam componentBackgroundColor    #FEFECE
    skinparam componentBorderColor    #A80036
    skinparam componentInterfaceBackgroundColor   #FEFECE
    skinparam componentInterfaceBorderColor   #A80036

    skinparam stateBackgroundColor #BDE3FF
    skinparam stateBorderColor #2980B9
    skinparam stateArrowColor #2980B9
    skinparam stateStartColor black
    skinparam stateEndColor   black

More about styling can be found at http://plantuml.com/skinparam ,
http://plantuml.com/sequence-diagram .

And adjust your :file:`Makefile` to provide this file to PlantUML:

.. code-block:: makefile

    plantuml:
        plantuml -config plantuml.cfg -psvg -o ../Images/Uml/ ./Uml/*.uml

Questions or issues
-------------------

Make sure to check the help for `Read the docs`_, `Github help <https://help.github.com/>`_, `Sphinx
<http://www.sphinx-doc.org/en/stable/>`_ and `PlantUml <http://plantuml.com/>`_.  If you still have questions
or issues just leave a comment.

Further reading
---------------

You should now be able to write basic documentation with hosting at Read the docs. The following
links can be startpoints to get further:

* `Sphinx autobuild <https://pypi.org/project/sphinx-autobuild/0.2.3/>`_ will detect changes and
  autogenerate documentation. Also comes with server and autoreload.

* `Sphinx intersphinx <http://www.sphinx-doc.org/en/stable/ext/intersphinx.html>`_ allow linking
  between sphinx projects without need to know urls.

* Sphinx `builtin Themes`_

Also the following links as a collection:

* `Sphinx`_

* `Github`_

* `Read the docs`_

* `Plantuml`_

.. _Github: https://github.com/
.. _Installing Sphinx: http://www.sphinx-doc.org/en/stable/install.html
.. _Plantuml: http://plantuml.com/
.. _Read the Docs: https://readthedocs.org/
.. _Sphinx Documentation: http://www.sphinx-doc.org/en/stable/contents.html
.. _Sphinx: http://www.sphinx-doc.org/en/stable/
.. _builtin Themes: http://www.sphinx-doc.org/en/stable/theming.html#builtin-themes
.. _register at Read the docs: https://readthedocs.org/accounts/signup/
