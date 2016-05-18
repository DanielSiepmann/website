.. post:: May 18, 2012
   :tags: typo3, docs, xliff

TYPO3 XLIFF for Extension Development
=====================================

Since *TYPO3* 4.5 it's possible to use the new `XLIFF-Format
<https://en.wikipedia.org/wiki/Xliff>`__ for translation.  There is a very nice article about the
differences and usage in the internet. `Take a look at it
<http://xavier.perseguers.ch/tutoriels/typo3/articles/managing-localization-files.html>`__.  After
reading I had some more question. I'll try to answer them now in this post.

TCA
---

Without *XLIFF* you just wrote the following line to use an label from the old *locallang-files*:
``'title' => 'LLL:EXT:' . $_EXTKEY . '/Resources/Language/locallang.xml:label',``.  But what do you
need to write now? It's the same line with one change: ``'title' => 'LLL:EXT:' . $_EXTKEY .
'/Resources/Private/Language/locallang.xlf:label',``.  You just have to change the format from
*xml*, or *php*, to *xlf*.  That's it. Fine, you now should see your label in the default language,
but what's with the other languages?

Each language has to be in it's own file like described `in the blogpost
<http://xavier.perseguers.ch/tutoriels/typo3/articles/managing-localization-files.html#c943>`__.
But how do you reference to them? You don't. It's that easy, you just have to name the files in the
right way and you're done. For example if you want to provide a german translation for your english
default language, you just have to add a file called *de.locallanx.xlf* inside the same folder you
created your *locallang.xlf*. *TYPO3* will fetch this file. You don't have to change anything inside
your *php*-code.

Caching
-------

If you are ever wondering why your changes aren't applied, just clear
the cache. Your *locallang-files* are cached!
