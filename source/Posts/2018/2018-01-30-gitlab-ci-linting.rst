.. post:: Jan 30, 2018
   :tags: gitlab-ci, gitlab, linting, typoscript, typo3
   :excerpt: 2

Integrate TYPO3 Linting with Gitlab CI
======================================

`Gitlab`_ is the new buzzword for cloud- and self-hosted repository hosting connected to a CI. We
are using `Gitlab-CI`_ in combination with Docker for running tests, linting code and deployments.

In this post I'll explain how to setup linting TypoScript and YAML for TYPO3 projects using
Gitlab-CI.

Typoscript linting
------------------

Martin Helmich has created a Typoscript parser and `Typoscript linter`_ which already provides basic
rules. The concepts are inherited from PHP Code Sniffer with different Sniffs which can be
configured.

You can install the linter as dev dependency using `composer`_:

.. code-block:: bash

   composer require --dev helmich/typo3-typoscript-lint

The linter is pre-configured with a default configuration, which can be found at Github:
https://github.com/martin-helmich/typo3-typoscript-lint/blob/v1.4.6/tslint.dist.yml

Configuration is written as `yaml`_. You can extend the default configuration. Most linters provide
the `.dist` way to provide a distributed configuration which can be overwritten by a more specific
configuration. We are using `yaml` as file extension, which is the preferred accordingly to FAQ of
yaml. Our configuration looks like the following :file:`tslint.yaml``:

.. literalinclude:: /Code/TYPO3/tslint.yaml
   :language: yaml

We define paths containing Typoscript to check. Also we adjust the default sniffs a bit. We force
indentation of one level inside of conditions, as we do in PHP and JavaScript.
Also we disable the ``RepeatingRValue`` sniff as we check this rule ourselves.

To actually lint anything, you will call the linter with the configuration:

.. code-block:: bash

   ./vendor/bin/typoscript-lint -c tslint.yaml

Which will generate something like the following if everything is fine:

.. code-block:: bash

   ..................................................   [ 50 / 106,  47%]
   ..................................................   [100 / 106,  94%]
   ......                                               [106 / 106, 100%]

   Complete without warnings

If errors or warnings exist, the following output will be generated:

.. code-block:: bash

   ...............................W..................   [ 50 / 106,  47%]
   ........W................................W........   [100 / 106,  94%]
   ......                                               [106 / 106, 100%]

   Completed with 9 issues

   CHECKSTYLE REPORT
   => localPackages/cdx_site/Configuration/TypoScript/Setup/Plugins/SearchCore.typoscript.
      7 No whitespace after object accessor.
     10 Accessor should be followed by single space.
     11 Value of object "plugin.tx_searchcore.view.templateRootPaths.10" is overwritten in line 12.

   SUMMARY
   9 issues in total. (9 warnings)

You can also output in ``checkstyle`` format which might be useful for some CI environments and
editors.

yaml linting
------------

As we didn't find any useful yaml linter written in PHP, we use one written in Python. Most php
linters just call Symfony yaml parser and catch exceptions, which results in a single parsing error.

So we decided to use `yamllint`_, which is no problem using Docker and Gitlab-CI. I'll not describe how
to install locally, refer to Gitlab-CI in next section.

As the Typoscript linter, this linter also provides a default of rules to check, which can be found
at Github: https://github.com/adrienverge/yamllint/blob/v1.10.0/yamllint/conf/default.yaml
There is also a "relaxed" version of the configuration. You can "inherit" one of the configurations
in your own, which is provided as :file:`yamllint.yaml` in your project root:

.. literalinclude:: /Code/TYPO3/yamllint.yaml
   :language: yaml

We adjust some rules, some become more strict, some are disabled completely.

You can call the linter using the following command:

.. code-block:: bash

    yamllint -c yamllint.yaml localPackages/ yamllint.yaml .gitlab-ci.yml tslint.yaml

Nothing will be printed if everything is fine. Errors and warnings are reported like:

.. code-block:: bash

   localPackages/cdx_site/Configuration/Forms/Base.yaml
     7:21      error    duplication of key "10" in mapping  (key-duplicates)

   tslint.yaml
     10:28     error    empty value in block mapping  (empty-values)

Integrate linting in Gitlab-CI
------------------------------

As we now know how to configure the linter and how to execute them, we need to integrate them into
our Gitlab-CI through our :file:`.gitlab-ci.yml`. Poorly gitlab does not allow `yaml` as file
extension for that file.

The task for Typoscript looks like the following:

.. code-block:: yaml

   lint:typoscriptcgl:
       image: composer:1.6
       stage: lint
       script:
           - composer install --no-progress --no-ansi --no-interaction
           - ./vendor/bin/typoscript-lint -c tslint.yaml

The task for Yaml looks like the following:

.. code-block:: yaml

   lint:yaml:
       image: python:alpine3.7
       stage: lint
       before_script:
           - pip install yamllint==1.10.0
       script:
           - yamllint -c yamllint.yaml localPackages/ yamllint.yaml .gitlab-ci.yml tslint.yaml

As both linter will provide proper exit codes, we are finished. Output is generated in a human
friendly way, so everyone can take a look right into the log what goes wrong and can fix the issues.

Further reading
---------------

- `Gitlab`_

- `Gitlab-Ci`_

- `TypoScript linter`_

- `yamllint`_

- Blog post :ref:`integrate_typoscript_linter_into_vim`.

.. _Gitlab-CI: https://about.gitlab.com/features/gitlab-ci-cd/
.. _Gitlab: https://about.gitlab.com/
.. _Typoscript linter: https://github.com/martin-helmich/typo3-typoscript-lint
.. _composer: https://getcomposer.org/
.. _yaml: http://yaml.org/
.. _yamllint: https://yamllint.readthedocs.io/en/latest/
