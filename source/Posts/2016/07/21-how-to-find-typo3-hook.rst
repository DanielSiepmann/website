.. highlight:: php
.. post:: Jul 21, 2016
   :tags: typo3, hooks
   :excerpt: 2

.. _how-to-find-hooks-in-typo3:

How to find Hooks in TYPO3
==========================

Hooks inside of TYPO3 CMS allow you to hook into existing processes of the core, or of extensions,
to manipulate the processes.

This post will explain in more depth what hooks are and how you can find and use them.

.. _what-are-hooks-in-typo3:

What are Hooks in TYPO3?
------------------------

TYPO3 has a lot of processes like evaluating data, authenticating users, displaying content and so
on. All of this processes are handled inside of TYPO3. In some use cases you want to hook into the
process and manipulate the process. E.g. you want to modify data inserted into the backend, before
they get persisted into the database.

This can be achieved by using a hook to modify the process. The hook allows you to include your
custom PHP into the process, which will get executed.

The execution of Hooks is typically implemented like the following:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5

    if (is_array($GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_div.php']['devLog'])) {
        $params = array('msg' => $msg, 'extKey' => $extKey, 'severity' => $severity, 'dataVar' => $dataVar);
        $fakeThis = false;
        foreach ($GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_div.php']['devLog'] as $hookMethod) {
            self::callUserFunction($hookMethod, $params, $fakeThis);
        }
    }

So your configured method will be called with some arguments, on line 5 in above example. Most of
the time the arguments will be references enabling you to modify them.

Hooks differ in two ways:

#. Some hooks need your class to implement a specific interface, or method. Others, like above will
   just call the function or method you have provided, like a :ref:`userfunc
   <t3tsref:cobj-user-examples>`.

#. Also some hooks will provide arguments via reference and others via copy.

.. _hooks-typo3-example:

A simple example
----------------

Let's assume the following example: You want to provide latitude and longitude to frontend users,
auto generated based on their address. That can be achieved by using a hook inside of
:ref:`t3api:TYPO3\\CMS\\Core\\DataHandling\\DataHandler`.

Configure the hook in :file:`ext_localconf.php` of your extension like::

    $GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_tcemain.php']['processDatamapClass'][$_EXTKEY]
        = 'DanielSiepmann\FeuserLocations\Hook\DataMapHook';

This will register the class ``DanielSiepmann\FeuserLocations\Hook\DataMapHook`` to be processed.
Inside of the class we have the following method, called during the process::

    /**
     * Hook to add latitude and longitude to locations.
     *
     * @param string $action The action to perform, e.g. 'update'.
     * @param string $table The table affected by action, e.g. 'fe_users'.
     * @param int $uid The uid of the record affected by action.
     * @param array $modifiedFields The modified fields of the record.
     *
     * @return void
     */
    public function processDatamap_postProcessFieldArray( // @codingStandardsIgnoreLine
        $action,
        $table,
        $uid,
        array &$modifiedFields
    ) {
        if(! $this->processGeocoding($table, $action, $modifiedFields)) {
            return;
        }

        $geoInformation = $this->getGeoinformation(
            $this->getAddress($modifiedFields, $uid)
        );

        $modifiedFields['lat'] = $geoInformation['geometry']['location']['lat'];
        $modifiedFields['lng'] = $geoInformation['geometry']['location']['lng'];
    }

This method will get called for all data changed through ``DataHandler`` before they are processed
by the ``DataHandler``.

.. caution::

   As this method get called for *all* data, you should check whether to execute the method. Same is
   true for some other hooks like database queries. Your system will slow down without these checks
   called `guards <https://en.wikipedia.org/wiki/Guard_(computer_science)>`_.

.. _finding-hooks-in-typo3:

How to find hooks
-----------------

Hooks are always configured through ``$GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']``, so finding hooks
is as easy as a search for ``SC_OPTIONS``. Of course you need to understand the surrounding code and
where your hook should be executed to find the right place.

E.g. execute the following in your shell:

.. code-block:: bash

    grep -n -C 5 "SC_OPTIONS" -r vendor/typo3/cms

Beside the core, also extensions might provide hooks, so adjust the path, ``vendor/typo3/cms``, to
search inside an extension.

Also all registered hooks can be found inside the backend "Configuration" module. Just select the
``TYPO3_CONF_VARS`` in dropdown and search for ``SC_OPTIONS``. By *registed* I mean hooks that are
already in use, it's not a full list of available hooks.

.. _signal-slots-typo3:

Signal Slots
------------

Beside the concept of hooks, TYPO3 also provides the concept of Signal Slots. I will not document
that concept here, there are already some blog posts about the topic:

- `English blog post by Felix Oertel <http://blog.foertel.com/2011/10/using-signalslots-in-extbase/>`_

- `English blog post at usetypo3.com <https://usetypo3.com/signals-and-hooks-in-typo3.html#c210>`_

- `German blog post at typo3blogger.de <https://typo3blogger.de/signal-slot-pattern/>`_

- `Official Documentation of Signal Slots in Flow Framework
  <https://flowframework.readthedocs.io/en/stable/TheDefinitiveGuide/PartIII/SignalsAndSlots.html#signals-and-slots>`_

In general it's the same idea, just implemented in an object oriented way.

.. _further-reading-typo3-hooks:

Further reading
---------------

Checkout the official documentation at :ref:`t3coreapi:hooks`.

Also check out :ref:`examples for userfunctions <t3tsref:cobj-user-examples>`.

Also you can check how other developers make usage of hooks, e.g. in the example extension
`wv_feuser_locations <https://github.com/web-vision/wv_feuser_locations/tree/develop>`_.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 versions 4.5 up to 8 LTS.
