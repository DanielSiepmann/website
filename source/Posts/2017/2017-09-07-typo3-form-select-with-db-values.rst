.. post:: Sep 07, 2017
   :tags: typo3, form
   :excerpt: 2

How to create TYPO3 Form select element with options selected from database
===========================================================================

TYPO3s new form framework allows to write custom form elements. This way you are able to define a
new select element, based on the existing one, but filled with options fetched from database.

E.g. you want your user to select from ``sys_category`` or some other custom records. In this blog
post I will show how to provide the necessary logic in a custom PHP class, how to register a new
element extending the existing one and how to use this new element in your forms.

The following steps are necessary:

#. Write custom element as PHP Class, extending base element.

#. Define custom element as prototype in yaml-Configuration, which inherits existing configuration
   of a select.

#. Use the new element in the form.

The PHP Class
-------------

As we want to provide custom functionality, we need to create a PHP Class which will contain this
functionality. In our example we want to provide ``sys_category`` records based on a parent
``sys_category`` as possible options. Therefore we need to provide one option, the ``uid`` of the
parent system category. Also we need to fetch the records from database using Doctrine and provide
them as options for the element, e.g. select in our case.

The implementation is done with the following class:

.. literalinclude:: /Code/TYPO3/example/Classes/Domain/Model/FormElements/SystemCategoryOptions.php
   :language: php
   :linenos:
   :lines: 1-3,23-

First of all we extend the ``setProperty`` method, which receives all options. If the current option
is the configured ``systemCategoryUid``, we hook into and add the options. In all other situations
we just call the original method.

Based on the configured ``uid``, we fetch the records from database in our ``getCategoriesForUid``
method.

Afterwards we iterate over the results and prepare them to be used by the select, therefore we need
a label and identifier. We use the saved ``title`` and ``uid``.
The result is set as the ``options`` for select element.

The class itself does not contain any relation to the specifics of a select-element. It should also
be possible to use the same code for radio or checkboxes, as long as they make use of the
``options`` property.


.. hint::
    Therefore it should be possible to separate logic from the elements themselves and to build the
    concrete elements via yaml. But I didn't try that yet.

Define custom element
-----------------------

Once our functionality is provided, we need to create a new form element to be available to our
forms. Therefore we define the new element:

.. literalinclude:: /Code/TYPO3/example/Configuration/Forms/Base.yaml
   :language: yaml
   :linenos:
   :lines: 1-3,7-8,13-19
   :emphasize-lines: 7

On line 7 we define the identifier of our new element, under which we can use the element in our
forms. We inherit the existing configuration of the select element and exchange the concrete php
class for implementation.
As the path of fluid template is generated from the name, we define to use the same template as for
the select element.

That's all we have to do, to define a new select with different implementation.

Use element
-----------

We are now able to use the defined element in our forms:

.. literalinclude:: /Code/TYPO3/example/Resources/Private/Form/Example.yaml
   :language: yaml
   :linenos:
   :emphasize-lines: 16,20

We define our own ``SingleSelectWithSystemCategory`` element to be used and define our
``systemCategoryUid`` to be used. Everything else is exactly the same as for any other select, as we
use the same template.

Further reading
---------------

Check out the official doc sections:

* :ref:`t3form:concepts-frontendrendering-codecomponents-customformelementimplementations`

* :ref:`t3form:concepts-configuration-inheritances-operator`

* :ref:`t3form:concepts-configuration-prototypes`

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8 LTS.
