.. post:: Nov 17, 2017
   :tags: typo3, development, debugging
   :excerpt: 2

Use Whoops as Exception handler for TYPO3
=========================================

During development for TYPO3 you often run into Exceptions. They do not look very nice.  A much
nicer alternative might be `whoops <http://filp.github.io/whoops/>`_ which `@dk2kde
<https://twitter.com/dk2kde>`_ told me about. It will not only handle exceptions, but also PHP
Errors like syntax errors.

In this small blog post I will show you how to use *whoops* as exception handler for TYPO3 projects
during local development. The result will be:

.. figure:: /images/2017/whoops-example.png
    :align: center

    Figure 1-1: Example output of Exception in TYPO3 using whoops.

Install dependencies
--------------------

First of all you have to install the `filp/whoops <https://packagist.org/packages/filp/whoops>`_
package. Also I recommend to install `symfony/var-dumper
<https://packagist.org/packages/symfony/var-dumper>`_. Only with both packages you will see
arguments in stack traces.

To install both run the following in your terminal:

.. code-block:: bash

   composer global require filp/whoops
   composer global require symfony/var-dumper

Configure TYPO3
---------------

Afterwards you can configure TYPO3 to use the new exception handler. Therefore insert the following
in your :file:`typo3conf/AdditionalConfiguration.php`. Of course you have to update line 4 to match
your installation path:

.. code-block:: php
   :linenos:

   call_user_func(function ($exceptionHandling = 'whoops') {
       // Use whoops error handler for errors.
       if ($exceptionHandling === 'whoops') {
           require_once '/Users/siepmann/.composer/vendor/autoload.php';
           $handler = null;
           if (defined('TYPO3_cliMode') && TYPO3_cliMode) {
               // $handler = new \Whoops\Handler\PlainTextHandler();
           } else {
               $handler = new \Whoops\Handler\PrettyPageHandler();
               $handler->setApplicationPaths([
                   'web' => realpath(PATH_site . '../web'),
                   'typo3' => realpath(PATH_site . '../vendor/typo3/cms'),
                   'typo3conf' => realpath(PATH_site . 'typo3conf'),
               ]);
           }
           if ($handler !== null) {
               $whoops = new \Whoops\Run;
               $whoops->pushHandler($handler);
               $whoops->register();
           }
       }
       if ($exceptionHandling === 'xdebug' || $exceptionHandling === 'whoops') {
           // Disable original handler to use whoops or xdebug
           $GLOBALS['TYPO3_CONF_VARS']['SYS']['productionExceptionHandler'] = '';
           $GLOBALS['TYPO3_CONF_VARS']['SYS']['debugExceptionHandler'] = '';
           $GLOBALS['TYPO3_CONF_VARS']['SYS']['errorHandler'] = '';
       }
   });

With this setup you will get the new exception handler for web requests.

On CLI I recommend to use ``typo3cms`` which will use Symfony stack traces anyway.

Configuration options
---------------------

To switch to the handler of *xdebug*, exchange ``whoops`` on line 1 with ``xdebug``. To use the
original TYPO3 handler insert something else, e.g. ``TYPO3``.

Also you might want to adjust the application paths to your setup. All paths listed as values in
that array will be filterable as application in stack trace.

Further reading
---------------

- http://filp.github.io/whoops/

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8 LTS.
