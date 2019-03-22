.. post:: Jun 08, 2018
   :tags: typo3, testing
   :excerpt: 3

Executing TYPO3 acceptance tests
================================

TYPO3 CMS is an open source content management system with lots of contributions.
The system has a huge code base which is partially very old and therefore contains a
lot of legacy code. Therefore it's very important to cover existing features with
tests, to not break anything if you improve the system.

TYPO3 CMS was improved with a lot of unit and functional tests in the past. Since
some time, there are also acceptance tests available, which will test functionality
of the backend. All of these tests are executed by the TYPO3 CMS own Bamboo to make
sure no merge will break anything. If you want to execute the existing acceptance
tests, you already might be a developer and luckily, the repository contains all
necessary information to get started.

In this Blog post I will show how to get the necessary information out of the
source files and to execute these tests. This should also help in the future, as the
way to get there is described, not only how to execute the tests now.

Requirements
------------

All requirements are already documented at :ref:`t3contrib:setup` in the official
contribution workflow. All requirements which are specific to acceptance tests, are
already configured inside of ``composer.json`` of TYPO3 and therefore installed.
Typically the requirements for acceptance tests consist of:

WebDriver
   As acceptance tests are run inside a browser, most of the time, we need a browser
   and access to control the browser from the outside.

      WebDriver is a remote control interface that enables introspection and control
      of user agents. It provides a platform- and language-neutral wire protocol as a
      way for out-of-process programs to remotely instruct the behavior of web browsers.

      -- https://www.w3.org/TR/webdriver/

Chromedriver
   Also we need a browser that supports WebDriver, or a driver that will add the
   support. As Chrome is nowadays a browser that supports headless mode, Chrome
   is the de-facto-standard for acceptance tests nowadays. To add the capabilities
   to use WebDriver with Chrome, one has to install Chromedriver.

PHPUnit
   To write and execute tests, there is always PHPUnit as a framework. Even if you
   are using another framework it's very likely that PHPUnit is a dependency and used
   under the hood.

Codeception
   To make writing acceptance tests easier, TYPO3 CMS is using Codeception as a
   testing framework on top of PHPUnit. Codeception has much easier to use API to
   make use of WebDriver.

But all of these are installed through composer. So just take a look at the
``require-dev`` section of ``composer.json`` to get these information.

Finding the truth
-----------------

Once everything is installed, we need to know how to execute tests. There is a single
point of truth for that, its called Bamboo. As we do not have access rights to read
the configuration inside of the web UI of https://bamboo.typo3.com, we have another
way. Luckily the whole configuration is right in our hands, inside the TYPO3 CMS
repositories ``/Build/bamboo`` folder.

Don't be afraid, Bamboo is written in Java, and so are the configuration files at
time of writing this Blog post. But we do not have to change anything, we just need
to grab information, so that's not a problem, you are a developer, right?

So let's take a look at the file
``/Build/bamboo/src/main/java/core/AbstractCoreSpec.java``, which is shown with only
necessary lines and context here:

.. literalinclude:: /Code/TYPO3/Core/Build/bamboo/src/main/java/core/AbstractCoreSpec.java
   :language: java
   :linenos:
   :dedent: 4
   :lines: 165-185

If you search for the string "acceptance" in this file, you will first find line 2
from above example. It's like PHPDoc showing us that the installation procedure for
MySQL is tested as an acceptance test here. Take a deeper look and you will see that
different tasks are defined from line 12 to 20. First some basic tasks are executed
like cloning, composer install and stuff like that. Afterwards
``getTaskPrepareAcceptanceTest`` is called, which sounds interesting. Let's take a
look at this method afterwards.
Right after ``getTaskPrepareAcceptanceTest`` a command is defined, which already has
a nice description "*Execute codeception AcceptanceInstallMysql suite*". We can
see the executable and the arguments in line 18 and 19.

So we know that Codeception is used to execute the acceptance test. We also know
which reports are generated and which configuration is loaded. The configuration is
prefixed with ``this.testingFrameworkBuildPath`` which is also defined in the same
file:

.. literalinclude:: /Code/TYPO3/Core/Build/bamboo/src/main/java/core/AbstractCoreSpec.java
   :language: java
   :linenos:
   :dedent: 4
   :lines: 49-50

So our configuration is looked up in
``/vendor/typo3/testing-framework/Resources/Core/Build/AcceptanceTestsInstallMysql.yml``.

Also in line 20 some environment variables are added, which are defined in
``this.credentialsMysql``:

.. literalinclude:: /Code/TYPO3/Core/Build/bamboo/src/main/java/core/AbstractCoreSpec.java
   :language: java
   :linenos:
   :dedent: 4
   :lines: 51-58

So we know everything, except what happens inside ``getTaskPrepareAcceptanceTest``,
so let's take a look at the last piece:

.. literalinclude:: /Code/TYPO3/Core/Build/bamboo/src/main/java/core/AbstractCoreSpec.java
   :language: java
   :linenos:
   :dedent: 4
   :lines: 791-808

We can see in the description, which is in line 6, that a web server and Chromedriver
is started. Taking a look at the ``inlineBody`` we see that the local PHP server is
started with some configuration, together with a Chromedriver and some configuration.

Playing around with the truth
-----------------------------

Looks like the following is necessary to execute the tests:

#. Create a database and user with access to it, and access to create "sub database".
   See: https://wiki.typo3.org/Acceptance_testing#Acceptance_Testing_since_TYPO3_v8

#. Start a web server which listens to localhost on port 8000::

      php \
         -d memory_limit=128M \
         -d max_execution_time=240 \
         -d xdebug.max_nesting_level=400 \
         -d max_input_vars=1500 \
         -S localhost:8000

   This looks different from the Java-File. Yes, cause our local environment is
   different from Bamboos PHP environment; Once you start ``php -S localhost:8000``
   and tests, you will see typical PHP errors in install routine. This errors tell
   you to configure PHP, that's what we did in above example.

#. Start the Chromedriver which was installed via composer::

      ./bin/chromedriver --url-base=/wd/hub

#. Execute Codeception to run the test::

      typo3DatabaseName="typo3_acceptance" \
         typo3DatabaseUsername="typo3_acceptance" \
         typo3DatabasePassword="typo3_acceptance" \
         typo3DatabaseHost="localhost"
         typo3InstallToolPassword="klaus" \
         ./bin/codecept run AcceptanceInstallMysql -d \
            -c vendor/typo3/testing-framework/Resources/Core/Build/AcceptanceTestsInstallMysql.yml \
            --html reports.html

   In above example the database, user and password are ``typo3_acceptance``, because
   I liked it that way on my locale machine. Just place your values in there.

That's what I've tried locally, which worked on my Ubuntu 18.04 setup with CMS 9
commit ``bc5dcaacef26cecb29e89554e5b1775dc839a4ae``.

As above commands start long running processes, you have either to send them to
background, or to start a new shell for each of the last three commands.

Getting results
---------------

Codeception will tell you where you can find the generated reports, they are inside
``/typo3temp/var/tests/AcceptanceReportsInstallMysql/reports.html`` in our above
example. You can open the report with any web browser.

Executing further tests
-----------------------

TYPO3 does not only provide the above test, but a larger range of acceptance tests.

If you search further for "acceptance" inside the
``/Build/bamboo/src/main/java/core/AbstractCoreSpec.java``-file, you will find the
method ``getJobsAcceptanceTestsMysql``. There is a bit "magic" that will split the tests to parallelize execution inside of
Bamboo, which we can ignore for local testing for now.

To execute all further acceptance tests of TYPO3s core, run::

   ./bin/codecept run Acceptance -d \
      -c vendor/typo3/testing-framework/Resources/Core/Build/AcceptanceTests.yml \
      --html reports.html

We just exchange the argument after ``run`` and the configuration file to use. At the
moment of this Blog post, this will execute 77 acceptance tests.

Where are the tests?
--------------------

So far we covered how to execute tests, and how to find information how to execute
the tests. What's still missing is the information where to find the actual tests.
You can check out the configuration for Codeception, that's the file we provide after
the ``-c`` option in the above examples. For all acceptance tests this is
``/vendor/typo3/testing-framework/Resources/Core/Build/AcceptanceTests.yml``.

If we take a look at this file we find out all we need to know:

.. literalinclude:: /Code/TYPO3/Core/vendor/typo3/testing-framework/Resources/Core/Build/AcceptanceTests.yml
   :language: yaml
   :linenos:
   :emphasize-lines: 4

Line 4 is the important one. This tells us where tests can be found. All tests are
available at ``/typo3/sysext/core/Tests``. Also note the comment which points to
https://forge.typo3.org/issues/79097 and covers the architectural problem of
dependencies evolving from this structure.

The last two lines are for splitting up the acceptance tests for parallelization
inside Bamboo.

Further information
-------------------

Acceptance tests are known to be fragile. Currently TYPO3 is not executing the
acceptance tests inside of bamboo, as they are broken from time to time. As TYPO3 is
GPL and Codeception MIT, both are joining forces to cover this issues in the future.

The above mentioned Java-Files are the single point of truth. They are used by Bamboo
to execute the pre-merge and nightly plans.

Further reading
---------------

- https://github.com/TYPO3/TYPO3.CMS/tree/master/Build/bamboo Bamboo files inside of
  TYPO3 CMS repository.

- https://wiki.typo3.org/Acceptance_testing#Acceptance_Testing_since_TYPO3_v8 Old
  documentation for TYPO3 CMS 8.

- https://github.com/TYPO3/testing-framework The testing framework dependency which
  is used as a base in TYPO3 CMS.

- https://codeception.com/docs/modules/WebDriver WebDriver documentation of
  Codeception, covering configuration and test API.
