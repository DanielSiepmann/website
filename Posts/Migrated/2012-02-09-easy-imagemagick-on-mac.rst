.. highlight:: bash
.. post:: Feb 09, 2012
   :tags: osx, typo3

Easy ImageMagick on Mac
=======================

I don't know why there are so many articles about installing ImageMagick on a Mac for TYPO3. All you
have to do is to install `Homebrew <http://mxcl.github.com/homebrew/>`__ (The missing package
manager for OS X). After installing (this takes 1 Minute), just run::

    brew install imagemagick

and you're done.

Just add the path (*/usr/local/bin/*) to you're TYPO3-Configuration.
