.. highlight:: php
.. post:: Jul 11, 2011
   :tags: typo3, ajax, docs

Use AJAX in TYPO3 without eID
=============================

I don't like to use the *eID mechanism*, because I have to instantiate everything on my own
(db-connection, feuser,...)

So I decided to use the "*TypoScript-Way*".

First you need to create a new *PAGE*-Object:

.. code-block:: text

        tmp.ajaxConf = PAGE
        tmp.ajaxConf {
            typeNum = 1249058000
            config {
                disableAllHeaderCode = 1
                xhtml_cleaning = 0
                admPanel = 0
            }
        }

        ajax_fullPage < tmp.ajaxConf
        ajax_fullPage {
            typeNum = 1296727024
            10 < styles.content.get
        }

First I create a "blank" *PAGE*-Object with basic configuration for all AJAX-PAGE-Objects. Then I
create a *PAGE*-Object to show everything on the actual page (for example my plugin). You can easily
add your output in the Backend like Plugins, Images, HTML, Text, ... You just have to call this page
with the defined typeNum like: ``/index.php?id=605&type=1296727024&ext_piVars[ajax]=1``

Then I check the AJAX-Parameter in my extension to check whether to execute the AJAX-Part of the
plugin or the default part.

::

    // Check wether we have to execute the AJAX or the default:
    if (isset($this->piVars["ajax"]) && $this->piVars["ajax"]) {
        return $this->ajax_store();
    }

You can find a German version here: `www.typo3-tutorials.org
<http://www.typo3-tutorials.org/cms/typo3-und-ajax-wie-geht-das.html>`__.  There
are additional possibilities for AJAX and TYPO3.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 4.7.
