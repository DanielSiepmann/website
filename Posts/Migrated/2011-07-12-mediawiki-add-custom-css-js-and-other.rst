.. highlight:: php
.. post:: Jul 12, 2011
   :tags: docs, media wiki

MediaWiki: Add SyntaxHighlighter (custom css and js)
====================================================

| I set up my own MediaWiki for Brainstorming and as a storage for
  informations (like Snippets).
| For the Snippets I need a SyntaxHighlighter and choose my favorite
  `alexgorbatchev.com <http://alexgorbatchev.com/SyntaxHighlighter/>`__

Therefore I had to add the CSS- and JS-Files to the Theme. This is done by adding the following
lines of code to the method "*initPage*" of the theme-file::

    // Adding the syntaxhighlighter:
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shCore.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushJScript.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushCss.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushJava.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushPhp.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushPlain.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushSql.js" );
    $out->addScriptFile( "/wiki/resources/syntaxhighlighter/scripts/shBrushXml.js" );
    $out->addInlineScript( "SyntaxHighlighter.all();" );
    $out->addStyle( "/wiki/resources/syntaxhighlighter/styles/shCoreDefault.css" );
    $out->addStyle( "/wiki/resources/syntaxhighlighter/styles/shThemeRDark.css" );

Please change the paths for your purposes.

For a better look I added the following styles to the file :file:`shCoreDefault.css`.

.. code:: css

    /* Custom CSS: */
    .syntaxhighlighter {
        padding-top: 10px;
        padding-bottom: 10px;
    }

For more informations how you can add custom files and header data, take a look at the official
MediaWiki-Wiki manual: `Manual:Hooks/BeforePageDisplay
<http://www.mediawiki.org/wiki/Manual:Hooks/BeforePageDisplay>`__
