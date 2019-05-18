.. post:: May 18, 2019
   :tags: composer, typo3
   :excerpt: 2

Composer Project setup
======================

This Blog post will explain how a typical Composer based PHP project setup can look
like. This uses a TYPO3 project as example, but the principles can be applied to any
project.

The main focus will be on using local packages that can be installed. Also advantages
of that approach will be explained. E.g. how to split a project specific package into
a standalone, once this becomes necessary.

The setup
---------

This is also documented at :ref:`t3installguide:mig-composer-best-practices` within
TYPO3 installation guide.

The setup looks like this:

.. code-block:: text

   .
   ├── composer.json
   ├── composer.lock
   ├── localPackages
   │   ├── cdx_site
   │   └── testing
   ├── phpcs.xml.dist
   ├── phpunit.xml.dist
   └── readme.rst

The project root contains only files for this project. E.g. :file:`composer.json` and
:file:`composer.lock`, describing project dependencies. Also further files like a
:file:`.travis.yml` or :file:`.gitlab-ci.yml` are placed in the root directory.

It's always a good idea to add an :file:`readme.rst` or :file:`readme.md`. One does
never know when some new developer has to join the project, and it's a good place to
describe typical use cases, e.g. setting up the project.

Beside those files, there is a folder :file:`localPackages` containing Composer
packages which are only relevant for this specific project. Each package has his own
sub folder with the necessary setup. The only mandatory file inside the folder, e.g.
:file:`localPackages/testing` is :file:`composer.json`. This way the folder becomes a
Composer package.

Adding the folder :file:`localPackages` via `Path
<https://getcomposer.org/doc/05-repositories.md#path>`_ allows to require those
packages, e.g. for above setup.

The project :file:`composer.json` could be:

.. code-block:: json

   {
       "repositories": [
           { "type": "path", "url": "localPackages/*" }
       ],
       "name": "website/example",
       "description" : "TYPO3 Website for presentations.",
       "license": "GPL-2.0-or-later",
       "require": {
           "typo3/cms-core": "^9.5.0",
           "typo3/cms-extbase": "*",
           "typo3/cms-fluid": "*",
           "typo3/cms-frontend": "*",
           "typo3/cms-fluid-styled-content": "*",
           "typo3/cms-extensionmanager": "*",
           "typo3/cms-setup": "*",
           "typo3/cms-backend": "*",
           "typo3/cms-beuser": "*",
           "typo3/cms-install": "*",
           "typo3/cms-recordlist": "*",
           "helhum/typo3-console": "^5.5.5",
           "codappix/testing": "dev-master"
       },
       "extra": {
           "typo3/cms": {
               "cms-package-dir": "{$vendor-dir}/typo3/cms",
               "web-dir": "web",
               "app-dir": "app"
           }
       }
   }

By adding the folder as repository for Composer packages, composer will install
packages from this location.

.. tip::

   This can also be usefull when cloning a library and playing around. This version
   can be stored locally and installed within an exampel project by adding the parent
   folder to :file:`composer.json`.

While the package :file:`composer.json` could be:

.. code-block:: json

   {
       "name": "codappix/testing",
       "description": "Example Extension to show phpunit.",
       "type": "typo3-cms-extension",
       "license": "GPL-2.0-or-later",
       "version": "v1.0.0",
       "authors": [
           {
               "name": "Daniel Siepmann",
               "email": "coding@daniel-siepmann.de"
           }
       ],
       "autoload": {
           "psr-4": {
               "Codappix\\Testing\\": "Classes"
           }
       },
       "autoload-dev": {
           "psr-4": {
               "Codappix\\Testing\\Tests\\": "Tests/"
           }
       },
       "require": {
           "typo3/cms-extbase": "^9.5"
       },
       "require-dev": {
           "phpunit/phpunit": "^7.1.4"
       }
   }

By providing a version within :file:`composer.json`, the local package is stable and
be required. Also further packages can place dependencies on that package.

Benefits
--------

By following this approach, one gets the following benefits:

* Easier project setup, all project files are on top level and inside
  :file:`localPackages`.

  This makes it easier to configure tools like PHP_CodeSniffer or Git. This makes it
  also easier to setup a Continuous Integration.

* :ref:`replacing-3rd-party-package`.

* :ref:`splitting-local-package`.

.. _replacing-3rd-party-package:

Replacing 3rd party package
---------------------------

Composer will lookup packages in a defined order. Therefore it's possible to replace
a 3rd party package by placing a corresponding package inside :file:`localPackages`.

The output during installation will look like (on Unix systems)::

   - Installing typo3/cms-recordlist (v9.5.7): Symlinking from localPackages/own-recordlist

Patching 3rd party package
--------------------------

This is also documented at `typo3worx.eu Blog Post
<https://typo3worx.eu/2017/08/patch-typo3-using-composer/>`_.

Replacing packages is not recommended, instead these can be patched by using a
composer plugin: :composerpackage:`cweagans/composer-patches`. The setup can be
extended to provide project specific patches for 3rd party packages. This can look
like:

.. code-block:: text
   :emphasize-lines: 9-14

   .
   ├── composer.json
   ├── composer.lock
   ├── localPackages
   │   ├── cdx_site
   │   └── testing
   ├── phpcs.xml.dist
   │   └── testing
   ├── patches
   │   ├── composer.patches.json
   │   ├── filelist_performance.patch
   │   ├── indent-prefix-comment-with-spaces.patch
   │   └── testing_use_fe_mode.patch
   ├── phpcs.xml.dist
   ├── phpunit.xml.dist
   └── readme.rst

In order to apply those patches, the :file:`patches/composer.patches.json` has to be
configured within :file:`composer.json`:

.. code-block:: json

   {
       "extra": {
           "enable-patching": true,
           "patches-file": "patches/composer.patches.json"
       }
   }

The contents of the file look like:

.. code-block:: json

   {
       "patches": {
           "typo3/cms": {
               "Disable file count in file list module": "patches/filelist_performance.patch",
               "Indent TypoScript prefixComment with spaces": "patches/indent-prefix-comment-with-spaces.patch"
           },
           "nimut/testing-framework": {
               "Use FE TYPO3 Mode": "patches/testing_use_fe_mode.patch"
           }
       }
   }

The output during installation will look like (on Unix systems):

.. code-block:: text

  - Installing typo3/cms (v8.7.26): Loading from cache
  - Applying patches for typo3/cms
    patches/filelist_performance.patch (Disable file count in file list module)
    patches/indent-prefix-comment-with-spaces.patch (Indent TypoScript prefixComment with spaces)

This way it's configured which patches should be applied. These patches can be put
into VCS. There is no need to fork projects and manage this forks.

.. _splitting-local-package:

Splitting local package
-----------------------

Once you decide that a local package would be useful within another project, this can
split into it's own repository and be published and required by multiple projects.
During this process, the whole Git history can be kept.

A new Git branch can be created, containing only commits and information for this
single package:

.. code-block:: bash

   export PACKAGE=package_folder
   git subtree split --prefix=localPackages/$PACKAGE -b package/$PACKAGE
   git push ../../packages/$PACKAGE package/$PACKAGE
   git branch -D package/$PACKAGE;

The above example assumes that we have the new Git repository for the package is
located relatively to the project location. The path is defined on line 3 of the
script.

What's happing in this small script? First the folder name is defined, containing the
package to split. Afterwards ``git subtree split`` is used to create a new Git branch
holding only relevant information for this path. This branch is then pushed to the
new repository and deleted afterwards.

The folder can now be removed within the project, and the package can be required via
composer from VCS or Packagist, etc.

Further reading
---------------

* Composer repository `Path <https://getcomposer.org/doc/05-repositories.md#path>`_

* :ref:`t3installguide:composer-working-with` within TYPO3 installation guide

* :ref:`t3installguide:mig-composer-best-practices` within TYPO3 installation guide

* :composerpackage:`helhum/typo3-secure-web` for TYPO3 projects

*  `typo3worx.eu Blog Post <https://typo3worx.eu/2017/08/patch-typo3-using-composer/>`_
