.. post:: Aug 26, 2017
   :tags: typo3, form
   :excerpt: 2

How to crypt submitted values using a custom finisher in TYPO3 CMS 8
====================================================================

Since TYPO3 CMS Version 8 there is a new Form framework heavily inspired by Neos Form Framework. As
most parts of Neos / Flow it's a great heavy dynamic component with great power.

In this post I will show how easy it is to write a custom finisher to crypt submitted values using
the ``SaltedPasswords`` extension. This enables you to write ``fe_user`` registration forms without
the need of 3rd party extensions.

The new form framework already provides a ``SaveToDatabase`` finisher to persist submitted
information to a database. Therefore it's easy to create a ``fe_user`` registration.
But there is one reason you can't: passwords are stored in plain text as they get no special
handling. Therefore you can write a custom finisher to crypt the password before saving to database.

The following steps are necessary:

#. Write custom finisher as PHP Class.

#. Register custom finisher as prototype in yaml-Configuration.

#. Use Finisher in your form before saving to database.

#. Use modified data by finisher instead of submitted data while saving to database.

Write custom finisher as PHP Class
""""""""""""""""""""""""""""""""""

Just create a new PHP class that extends ``\TYPO3\CMS\Form\Domain\Finishers\AbstractFinisher``,
configure the possible options with their defaults and implement the ``executeInternal`` abstract
method.

In our example we provide the option to configure a single field to crypt. Inside of our
implementation we check that this field was submitted and that salted passwords are enabled in
frontend.

If so, we crypt the password and add it as a new variable at ``Crypt.<fieldname>``. Where ``Crypt`` is the
``shortFinisherIdentifier`` and ``<fieldname>`` the configured field to crypt.

.. literalinclude:: /Code/TYPO3/example/Classes/Domain/Finishers/CryptFinisher.php
   :language: php
   :linenos:
   :lines: 1-3,23-

It's nearly the same as a Fluid ViewHelper. We configure options instead of arguments and can
provide defaults. Then we add new variables to the container, in this case the FinisherVariableProvider.

Register custom finisher
""""""""""""""""""""""""

New finishers are not registered out of the box, we have to register them manually. Therefore we add
the following to our ``yaml`` configuration which is defined in TypoScript:

.. code-block:: yaml
   :linenos:
   :emphasize-lines: 7-8

    TYPO3:
      CMS:
        Form:
          prototypes:
            standard:
              finishersDefinition:
                CryptFinisher:
                  implementationClassName: DS\ExampleExtension\Domain\Finishers\CryptFinisher

This way we can prevent naming collisions as we define the name of the finisher to use.

We just register the existing PHP class under ``CryptFinisher`` and can now use the finisher.

Use Finisher in own form
""""""""""""""""""""""""

We register the new custom finisher before other finishers, so he can crypt the plain text password
and we are able to use the crypted version while saving to database.

We just tell the form framework to run our finisher and provide the necessary options:

.. code-block:: yaml
   :linenos:

    finishers:
      -
        identifier: CryptFinisher
        options:
          field: password

Use modified data by finisher
"""""""""""""""""""""""""""""

As the finisher has added new data, we can access the new data and save this instead of the original
submitted plain text password. That's done on line 18.

We use the curly braces as already known by Fluid. Inside of the braces we use the short identifier
of the finisher, which is the class name without namespace and ``Finisher`` suffix. So for
``\DS\ExampleExtension\Domain\Finishers\CryptFinisher`` this would be ``Crypt``. Then, as already
known by Fluid, we separate the path with dots and access the added data as documented in our
finisher.

.. code-block:: yaml
   :linenos:
   :emphasize-lines: 17-18

    finishers:
      -
        identifier: SaveToDatabase
        options:
          1:
            table: 'fe_users'
            mode: insert
            databaseColumnMappings:
              pid:
                value: 140
              disable:
                value: 1
              usergroup:
                value: 1
              description:
                value: 'Registered via form'
              password:
                value: '{Crypt.password}'

That's it. We now save the crypted password instead of the original plain text submitted value.
If, for any reason, multiple fields need to be crypted we can add the same finisher with different
options multiplet times and don't need to bloat the implementation itself.

Further reading
---------------

Check out the official doc sections:

* :ref:`t3form:concepts-frontendrendering-codecomponents-customfinisherimplementations`

* :ref:`t3form:typo3.cms.form.prototypes.<prototypeIdentifier>.finishersdefinition.<finisheridentifier>.implementationClassName`

* :ref:`t3form:apireference-frontendrendering-programmatically-apimethods-abstractfinisher`
