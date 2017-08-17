.. post:: Oct 20, 2015
   :tags: typo3, extbase, dependency injection
   :excerpt: 2

.. _injectTypoScriptSettings:

Inject TypoScript Settings
==========================

Sometimes you need settings like TypoScript in a class which is not your controller. Inside a
controller, the Extbase framework already injects the settings for you, so you are able to access
them under ``$this->settings``.

In all other classes it's easy to let Extbase inject the settings for you. Just include the
following code, and make sure you instantiate the class via
:ref:`t3api:TYPO3\\CMS\\Extbase\\Object\\ObjectManager` instead of
:ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::makeInstance`.

.. literalinclude:: /Code/TYPO3/InjectTypoScriptSettings.php
   :language: php
   :linenos:
   :emphasize-lines: 40-47

This will use Extbase inject mechanism of ``ObjectManager`` to inject the ``ConfigurationManager``.
Instead of persisting this instance as a property, we just use it to fetch the settings and persist
them instead.  As most developers are used to ``$this->settings`` from Controllers, I'm using the
same convention in my classes.

This way the settings are available as a property in the class without any further work.

Just make sure you are using the :ref:`t3api:TYPO3\\CMS\\Extbase\\Object\\ObjectManager` as pointed
out above. It's really important, as only this class will process the injects.
:ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::makeInstance` doesn't support this feature.

Further reading
---------------

Check out the post about :ref:`typo3ExtbaseInjection`.
