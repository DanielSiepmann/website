.. highlight:: text
.. post:: Oct 25, 2012
   :tags: typo3, extbase, typoscript, docs

Merge storagePids in TypoScript setup from multiple Extensions
==============================================================

You often have to merge some storage pids inside your static TypoScript setup of an extension.

Here is a small example.

You have an Extension serving the users and another one serving a gallery. The gallery will extend
the existing user extension and therefore need the storage pid of the user records *and* of the
images.

This is done by using the following setup and constants.

:file:`constants.ts`::

    plugin.tx_extkeyofgallery {
        persistence {
            storagePid = your storage pid
        }
    }
    plugin.tx_extkeyofusers {
        persistence {
            storagePid = another storage pid
        }
    }

:file:`setup.ts`::

    plugin.tx_extkeyofgallery {
        persistence {
            storagePid = {$plugin.tx_extkeyofgallery.persistence.storagePid}
            classes {
                Tx_ExtKeyUsers_Domain_Model_Users {
                    newRecordStoragePid = {$plugin.tx_extkeyofgallery.persistence.storagePid}
                }
            }
        }
    }

    plugin.tx_extkeyofgallery.persistence.storagePid := addToList({$plugin.tx_extkeyofusers.persistence.storagePid})

This will merge both storage pids and keep your own for new records. You don't have to define the
``newRecordStoragePid``. If this is not defined, the first storagePid would be used.

Why do we have to do this? Or in other words "How does TYPO3 / Extbase handle this".

Extbase will use the defined storagePid of the current Plugin for all repositories. Even for those
from other extensions. Therefore we have to add there storagePids to our plugin.
