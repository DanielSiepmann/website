.. highlight:: php
.. post:: Jul 21, 2016
   :tags: typo3, hooks
   :excerpt: 2

How to find Hooks in TYPO3
==========================

Hooks inside of TYPO3 CMS allow you to hook into existing processes of the core or extensions to
manipulate the processes.

This post will explain in more depth what hooks are and how you can find and use them.

What are Hooks in TYPO3?
------------------------

TYPO3 has a lot of processes like evaluating data, authenticating users, ... . All of this processes
are handled inside of TYPO3. In some use cases you want to hook into the process and manipulate the
process. E.g. you want to modify data inserted into the backend, before they get persisted into the
database.

This can be achieved by using a hook to modify the process. The hook allows you to include your
custom PHP into the process, which will get executed.

Hooks are typically implemented like::

    if (is_array($GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_div.php']['devLog'])) {
        $params = array('msg' => $msg, 'extKey' => $extKey, 'severity' => $severity, 'dataVar' => $dataVar);
        $fakeThis = false;
        foreach ($GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_div.php']['devLog'] as $hookMethod) {
            self::callUserFunction($hookMethod, $params, $fakeThis);
        }
    }

So your configured method will be called with some arguments. Most of the time the arguments will be
references enabling you to modify them.

They differ in two ways:

Some hooks need your class to implement a specific interface, or method. Others, like above will
just call the function or method you have provided, like a :ref:`userfunc <t3tsref:cobj-user-examples>`.

Also some hooks will provide arguments via reference and others as copy.

A simple example
----------------

Let's assume the following example: You want to provide latitude and longitude to frontend users,
auto generated based on their address. That can be achieved by using a hook inside of
:ref:`t3api:TYPO3\\CMS\\Core\\DataHandling\\DataHandler`.

Configure the hook in :file:`ext_localconf.php` of your extension like::

    $GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_tcemain.php']['processDatamapClass'][$_EXTKEY]
        = 'WebVision\WvFeuserLocations\Hook\DataMapHook';

This will register our class ``WebVision\WvFeuserLocations\Hook\DataMapHook`` to be processed.
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
        $action, $table, $uid, array &$modifiedFields
    ) {
        if(!$this->processGeocoding($table, $action, $modifiedFields)) {
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

How to find hooks
-----------------

Hooks are always configured through ``$GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']``, so finding hooks
is as easy as a search for ``SC_OPTIONS``. Of course you need to understand the surrounding code and
where your hook should be executed to find the right place.

E.g. execute the following in your shell:

.. code-block:: bash

    grep -n -C 5 "SC_OPTIONS" -r vendor/typo3/cms

Beside the core, also extension might provide hooks, so adjust the path to search inside an
extension.

Also all registered hooks can be found inside the backend "Configuration" module. Just select the
``TYPO3_CONF_VARS`` in dropdown and search for ``SC_OPTIONS``.

Notice
------

Most hooks called under different circumstances and more often then others. E.g. the hooks inside
the persistence are called for many queries. Make sure to use some kind of Guard to prevent errors
and performance issues.

In above example it's the following code::

        if(!$this->processGeocoding($table, $action, $modifiedFields)) {
            return;
        }

Further reading
---------------

Checkout the official documentation at :ref:`t3coreapi:hooks`.

Also check out :ref:`examples for userfunctions <t3tsref:cobj-user-examples>`.

Also you can check how other developers make usage of hooks, e.g. in the example extension
`wv_feuser_locations <https://github.com/web-vision/wv_feuser_locations/tree/develop>`_.
