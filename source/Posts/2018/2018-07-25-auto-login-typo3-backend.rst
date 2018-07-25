.. post:: Jul 25, 2018
   :tags: 
   :excerpt: 2

Auto login for TYPO3 Backend during development
===============================================

As an TYPO3 integrator or developer you will login into the same TYPO3 installations
multiple times during the same day. There are different ways to prevent the need to
login over and over again. One is to add a bit of PHP to the installation, e.g.
inside :file:`AdditionalConfiguration.php` to prevent any login. This should save a
lot of time during development.

In this blog post this solution will be shown and explained. You will never ever have
to login on your local installation anymore.

.. note::

  This approach is only for a local development environment. Do never use this in a
  production environment!

Background knowledge
--------------------

To implement the feature we need to understand how TYPO3 processes the login, so we
can provide our auto login. The process and implementation is documented at
:ref:`t3coreapi:authentication` section in TYPO3 Core API Reference.

TYPO3 will fetch all registered services to detect authentications in TYPO3 backend.
By default the registered services will only be called if certain conditions are met,
e.g. credentials were submitted in the current request. As we do **not** want to submit
anything, we have to configure TYPO3 to try authentication all the time.

Once we have configured TYPO3 to process authentication all the time, we have to
register a new service for authentication to automatically login the specified user.

With these information we can check the example implementation which will to both.

Implementation
--------------

This is the working implementation, which is explained afterwards:

.. literalinclude:: /Code/TYPO3/Autologin/AdditionalConfiguration.php
   :language: php
   :linenos:
   :lines: 1-2,22-

The first thing you might see is the **namespace** declaration using curly braces. This
feature was introduced in PHP 5.3.0 to enable multiple namespace declarations in one
file. This is a **bad practice** as already mentioned in official php docs. We still
use it here, to define a new scoped namespace for our code. This way we can separate
the code from the global namespace, without the need of an additional file.

Inside of the namespace we define **the service** as a class. This class extends the
``AbstractAuthenticationService`` class of TYPO3. Thanks to the namespace we can
import the namespace of the extended class. The service itself is very small, as we
do not have any logic.

We just define that our service had **authenticated** the user and no further checks
should be processed. This is the return value of ``200`` inside of the method
``authUser``.

The service also returns **the user** which was logged in. In our case the username has
to be placed in the method call ``fetchUserRecord``.

Once the service exists, we can **register the service**. The registration is done
using the ``addService`` method of ``ExtensionManagementUtility``. The important part
is that the service is available and has a higher priority to be called first. Also
the quality has to be equal or higher then the required quality. The configured
subtype defines which features are provided by the service. In the above example the
service authenticates the user, which was the ``200``, and provides the user, which
was done inside ``getUser`` method.

All registered services are added to ``$GLOBALS['T3_SERVICES']`` which can be inspected
using the *Configuration* module inside of TYPO3 backend. This way you can fetch the
necessary information for the registration of the service.

Last but not least we have to **force the authentication process** even if no credentials
were provided. This is done with this configuration:

.. code-block:: php

   $GLOBALS['TYPO3_CONF_VARS']['SVCONF']['auth']['setup']['BE_alwaysFetchUser'] = true;
   $GLOBALS['TYPO3_CONF_VARS']['SVCONF']['auth']['setup']['BE_alwaysAuthUser'] = true;

For further information about the above configuration refer to
:ref:`t3coreapi:authentication-advanced-options` section of the TYPO3 Core Reference.

Usage
-----

The above implementation can be pasted into :file:`AdditionalConfiguration.php`. Only
the username has to be inserted on line 15.

Multiple php namespaces in one file
-----------------------------------

You should read the `official documentation
<https://secure.php.net/manual/en/language.namespaces.definitionmultiple.php>`_ about
multiple php namespaces in one file, otherwise you might run into issues with above
implementation, depending on your :file:`AdditionalConfiguration.php`.

If you already have code inside of your :file:`AdditionalConfiguration.php` you
should wrap that code with:

.. code-block:: php
   :linenos:

   namespace {
      // Existing code ...
   }

   // Above implementation

As the ``namsepace`` has to be the first statement after any ``declare`` statements in a
PHP file. Without the global namespace-scope you would receive a fatal error.

Simple "Solution"
-----------------

Instead of a "full blown" auto login, you could also just raise the session timout.
This way your session lasts longer and you do not have to login so often.
Add the following configuration to :file:`AdditionalConfiguration.php`:

.. code-block:: php

   $GLOBALS['TYPO3_CONF_VARS']['BE']['sessionTimeout'] = 60 * 60 * 24;

The value is in seconds, so ``60 * 60 * 24`` is a whole day. You could also add
``*7`` for a week.

Further reading
---------------

- `PHP documentation about multiple namespaces in one file <https://secure.php.net/manual/en/language.namespaces.definitionmultiple.php>`_.

- :ref:`t3coreapi:authentication` in TYPO3 Core API Reference.

- :ref:`t3coreapi:authentication-advanced-options` section of the TYPO3 Core Reference.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8 LTS.
It should work with previous versions and PHP >= 5.3.0.
