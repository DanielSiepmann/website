.. highlight:: php
.. post:: Jul 11, 2011
   :tags: typo3, debugging

TYPO3 Debug last SQL Statement
==============================

You often need to debug your SQL-Statements. That isn't difficult, because TYPO3 give you easy to
use functions for this situation::

        $GLOBALS['TYPO3_DB']->store_lastBuiltQuery = 1;
        // Execute your code and query.
        echo $GLOBALS['TYPO3_DB']->debug_lastBuiltQuery;

Just add the first line before you execute your SQL-Statement. Then echo the Query with the second
line after you executed it.

Of course this only will work if you execute the queries with the TYPO3 functions.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 versions 4.7 up to 7 LTS.
