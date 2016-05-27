.. post:: May 27, 2016
   :tags: typo3, debugging, docs

.. highlight:: php

.. _customDevlog:

TYPO3 Custom DevLog
===================

TYPO3 ships with a debugging process called *DevLog*. It's a function provided by the core and used
by many extensions. The main purpose is to log information for debugging.
Beside the new Core feature :ref:`t3coreapi:logging`, it's older and therefore used in more
extensions.
TYPO3 doesn't ship with a handler for this function, it's possible to provide handler via TYPO3's
:ref:`t3coreapi:hooks` mechanism and the popular `devlog extension
<https://typo3.org/extensions/repository/view/devlog>`_ is installed on many TYPO3 installations to
have a handler which logs everything to the database and provide a backend module to see the entries.
But that's not necessary, you can register your own, very small handler in your
:file:`AdditionalConfiguration.php` or your distribution.

The example code
----------------

To do so, the following code can be used to kick start your own implementation:

.. code-block:: php

    $GLOBALS['TYPO3_CONF_VARS']['LOG']['writerConfiguration'] = [
        \TYPO3\CMS\Core\Log\LogLevel::ERROR => [
            'TYPO3\\CMS\\Core\\Log\\Writer\\FileWriter' => [
                'logFile' => 'typo3temp/logs/typo3_error.log'
            ]
        ],
        \TYPO3\CMS\Core\Log\LogLevel::DEBUG => [
            'TYPO3\\CMS\\Core\\Log\\Writer\\FileWriter' => [
                'logFile' => 'typo3temp/logs/typo3_debug.log'
            ]
        ],
    ];

    // Log devLog entries to console and files
    $GLOBALS['TYPO3_CONF_VARS']['SC_OPTIONS']['t3lib/class.t3lib_div.php']['devLog']['danielsiepmann-console']
    = function ($parameters) {
        \TYPO3\CMS\Core\Utility\DebugUtility::debug(
            $parameters['msg'],
            $parameters['extKey'],
            'devLog - daniel'
        );
        \TYPO3\CMS\Core\Utility\GeneralUtility::makeInstance(
            'TYPO3\CMS\Core\Log\LogManager'
        )
        ->getLogger('Ds\DevLog')
        ->log(
            \TYPO3\CMS\Core\Log\LogLevel::DEBUG,
            $parameters['extKey'] . ' - ' . $parameters['msg'],
            (array) $parameters['dataVar']
        );
    };

The above example will first :ref:`t3coreapi:logging-configuration` to configure the logging to file
system. Next the handler is registered to handle all
:ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::devLog` calls.  The handler will display all
entries directly in frontend using :ref:`t3api:TYPO3\\CMS\\Core\\Utility\\DebugUtility::debug`.
Then he will send all logs to the TYPO3 logging mechanism using severity ``DEBUG``.

The result
----------

The result in backend will look like:

.. image:: /images/2016-05-27-typo3-custom-devlog/example-output.png

The log files are available under :file:`/typo3temp/logs/*.log`. Depending on your naming. In the
above example the files are called :file:`typo3_error.log` and :file:`typo3_debug.log`.

The content of the files will look like:

.. code-block:: text

    Fri, 27 May 2016 09:44:29 +0200 [DEBUG] request="9326cefcd323f" component="Ds.DevLog": solr - Querying Solr using GET - {"query url":"http:\/\/192.168.99.100:8282\/solr\/core_en\/schema","response":{"\u0000*\u0000_response":{},"\u0000*\u0000_isParsed":false,"\u0.... 
    Fri, 27 May 2016 09:44:29 +0200 [DEBUG] request="9326cefcd323f" component="Ds.DevLog": solr - adding filter - ["siteHash:\"1316f93ad4d0b2b01594b6d28fe81339af1cad9e\""]
    Fri, 27 May 2016 09:44:29 +0200 [DEBUG] request="9326cefcd323f" component="Ds.DevLog": solr - adding filter - ["{!typo3access}-1,0"]
    Fri, 27 May 2016 09:44:29 +0200 [DEBUG] request="9326cefcd323f" component="Ds.DevLog": solr - Querying Solr using GET - {"query url":"http:\/\/192.168.99.100:8282\/solr\/core_en\/select?fl=%2A%2Cscore&fq=siteHash%3A%221316f93ad4d0b2b01594b6d28fe81339af1cad9e.... 
    Fri, 27 May 2016 09:44:29 +0200 [DEBUG] request="9326cefcd323f" component="Ds.DevLog": solr - Querying Solr, getting result - {"query string":"","query parameters":{"fl":"*,score","fq":["siteHash:\"1316f93ad4d0b2b01594b6d28fe81339af1cad9e\"","{!typo3access}-.... 

Of course the content is not cut, just here to keep the blog small.
One nice thing about the log is the ``request``. It allows you to see whether some parts are done in
further requests, like AJAX.

The benefit
-----------

With this starting point, you can wrap it for different *ApplicationContexts*. Now you don't have to
disable an extension on production but can handle all by yourself, no more dependencies, easier
migrations and more control.

Further reading
---------------

* :ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::devLog`

* :ref:`t3api:TYPO3\\CMS\\Core\\Utility\\DebugUtility::debug`

* :ref:`t3coreapi:hooks`

* :ref:`t3coreapi:logging`
