.. post:: Jan 04, 2019
   :tags: typo3, caching
   :excerpt: 2

.. highlight:: typoscript

TYPO3 content caching
=====================

TYPO3 provides a comprehensive caching implementation. Built into all parts of TYPO3.
By default TYPO3 tries hard to provide a working caching solution for Websites. This
way all generated content is cached whenever possible and delivered right from cache
without rendering. This leads to some issues if dynamic content is added. Some bypass
this issue by deactivating caching partly or for whole pages.

This post explains how to configure TYPO3 to make caching work without
deactivating it. One place where caching does not work out of the box is changing
files via Filelist module, changes there will not be reflected in content elements
using a file reference. This example is used to explain how caching works in TYPO3
and how to adjust caching.

As caching is a huge topic, this post will only cover the mentioned small part.
Do not expect a complete explanation of all parts. The caching framework itself,
useful in custom PHP Code is already explained in
:ref:`t3coreapi:caching-architecture`. Also Plugins are not part of this post.
Instead this post will focuses on content elements and proper cache invalidation.

The example
-----------

This post will use the following example:

A page using a file reference, e.g. an Textmedia or Uploads content element where an
image is rendered. This image does not have any property set in the reference, e.g.
no title or description. Also the original file which is referenced does not contain
any information yet.

Still the template will render those information if available. Now the editor will
add those information to the file via Filelist. Still the information is not
displayed in frontend, until the cache is cleared.

This is default TYPO3 behaviour, which might be "fixed" in the future. Till now, this
works as an example how to adjust TYPO3 to clear cache for all pages using this file,
to display the new information immediately.

Understanding existing caching
------------------------------

At the end of serving a rendered page, TYPO3 will cache the rendered markup. Some
parts might be replaced with a marker, but those are not part of this post. If
anything on the page is changed, e.g. the editor is saving a content element, TYPO3
will clear the cache for this page. This way the next visitor will trigger a new
rendering and see the results. Also the new generated markup is added to the cache
again.

How does TYPO3 invalidate, aka clear, the cache?

Two PHP Classes are involved here, one is the
``\TYPO3\CMS\Core\DataHandling\DataHandler`` which is *THE* API to change any data
inside of TYPO3. The second class is ``TYPO3\CMS\Core\Cache\CacheManager``, which is
the API to all caches. The ``DataHandler`` receives the call to update a certain
content element and will generate some Cache Tags out of that record. These tags are
then send for clearing to the ``CacheManager``.

TYPO3 already assigns necessary cache tags like ``pageId_6`` to each rendered page
cache entry. This way it's possible to clear cache entries for a single page by
clearing the accordingly cache tag.

``DataHandler`` also generates these cache tag, e.g. for each record that is updated,
the ``DataHandler`` will look up the page where the record is persisted, which is the
``pid`` column of each record. This cache tags are then cleared, leading to an
invalidated generated page markup.

This way TYPO3 works out of the box. But not all circumstances are handled yet. E.g.
the above example with file references does not work.

Concrete cache clearing example
-------------------------------

Let's follow a concrete example:

There is one page with uid ``10`` and a single Textmedia content element with uid
``20`` on page ``10``. This content element displays some text and an image. The image
is a ``sys_file_reference`` with uid ``30`` referencing ``sys_file`` with uid ``40``.

Once the content element is updated, ``DataHandler`` will generate the following
cache tags:

* pageId_10

* tt_content

* tt_content_20

* sys_file_reference

* sys_file_reference_30

Everything is working as expected. But as an editor updates the file itself, the
record ``sys_file_metadata`` with uid ``40``, the following cache tags will be
generated:

* pageId_0

* sys_file_metadata

* sys_file_metadata_40

There is no connection to page with uid ``10``, leading to a non updated page, not
displaying the updated title, which is inherited by ``sys_file_reference`` with uid
``30`` if no title is defined there.

Some more notes about the tags for ``sys_file_metadata``: Saving the file updates not
the file itself, but only the associated ``sys_file_metadata`` which are relevant
through out the system. The file itself will only be changed if it's replaced, e.g.
by new upload. Also ``pageId_0`` is generated, as most ``sys_`` records are stored on
the non existing page ``0``.

Possible approaches
-------------------

One now has to associate either cache tag ``sys_file_metadata_40`` when rendering the
page, or to add ``sys_file_reference_30`` cache tag when updating the
``sys_file_metadata_40``.

Both approaches are completely valid and the latter might look easier first. As we
can use a Hook to extend the generated cache tags to clear, check for the already
available cache tags, fetch all associated references, and add them.

Still, this approach will not work, as this cache tag is not associated to the stored
page. The page does not know about the internals of rendered content elements. It
does not know or understand that Textmedia fetches ``sys_file_reference`` with uid
``30`` which in turn is based on ``sys_file_metadata`` with uid ``40``. These might
be added through a ``DataProcessor``, which does not add any cache tags to the
rendered page. Maybe this might change in the future.

Adding further cache tags to generated page
-------------------------------------------

Adding further cache tags to pages is possible via TypoScript, and PHP. This way one
can collect information and attach further tags based on this information. TYPO3
itself will already generate necessary tags when records are updated, leading to auto
clearing of necessary pages.

Those tags can be added via :ref:`t3tsref:stdwrap-addpagecachetags` property of
:ref:`t3tsref:stdwrap`.

This property can either add static strings, e.g.::

   addPageCacheTags = pagetag1, pagetag2, pagetag3

This property also implements :ref:`t3tsref:stdwrap` again, adding the possibility to
use a :ref:`t3tsref:stdwrap-preuserfunc` or :ref:`t3tsref:stdwrap-postUserFunc`::

   tt_content.uploads.stdWrap {
       addPageCacheTags {
           postUserFunc = Codappix\CdxSite\Caching\ContentElementCaching->generateTags
       }
   }

Now it's up to the PHP implementation to add further tags.

Example PHP solution
--------------------

The concrete implementation depends on the concrete use case. For the above example
the following implementation would be one working solution:

#. Extend existing ``FilesProcessor`` to "save" provided file references.

#. Make this processor a singleton. The processor is state less but becomes state full
   as all file references need to be remembered until cache tags are added to the
   page.

#. Replace existing processor in TypoScript with custom one.

#. Add custom processor also as ``postUserFunc`` via ``stdWrap``

The TypoScript might look like::

   tt_content.uploads {
       dataProcessing {
           10 = Codappix\CdxSite\Caching\FilesProcessorAddingCacheTagsToPage
       }
       stdWrap {
           addPageCacheTags {
               postUserFunc = Codappix\CdxSite\Caching\FilesProcessorAddingCacheTagsToPage->generateTags
           }
       }
   }

While :file:`EXT:cdx_site/Classes/Caching/FilesProcessorAddingCacheTagsToPage.php` might look like:

.. code-block:: php

   <?php

   namespace Codappix\CdxSite\Caching;

   use TYPO3\CMS\Core\Resource\FileReference;
   use TYPO3\CMS\Core\SingletonInterface;
   use TYPO3\CMS\Core\Utility\GeneralUtility;
   use TYPO3\CMS\Frontend\ContentObject\ContentObjectRenderer;
   use TYPO3\CMS\Frontend\DataProcessing\FilesProcessor;

   /**
    * Singleton, in order to keep instance between filling in information and accessing information.
    *
    * Use as data processor replacement to add file references for content element.
    * Then add as userfunc to content element within TypoScript, to add cache tags.
    *
    * Example usage within TypoScript:
    *
    *   stdWrap.addPageCacheTags {
    *       postUserFunc = Codappix\CdxSite\Caching\FilesProcessorAddingCacheTagsToPage->generateTags
    *   }
    *
    */
   class FilesProcessorAddingCacheTagsToPage extends FilesProcessor implements SingletonInterface
   {
       private $tags = [];

       public function process(
           ContentObjectRenderer $cObj,
           array $contentObjectConfiguration,
           array $processorConfiguration,
           array $processedData
       ) {
           if (isset($processorConfiguration['if.']) && !$cObj->checkIf($processorConfiguration['if.'])) {
               return $processedData;
           }

           $processedData = parent::process(
               $cObj,
               $contentObjectConfiguration,
               $processorConfiguration,
               $processedData
           );

           $targetVariableName = $cObj->stdWrapValue('as', $processorConfiguration, 'files');
           foreach ($processedData[$targetVariableName] as $fileReference) {
               $this->tags[] = 'sys_file_metadata_'
                   . $fileReference->getOriginalFile()->_getMetaData()['uid'];
               $this->tags[] = 'sys_file_reference_'
                   . $fileReference->getUid();
           }

           return $processedData;
       }

       public function generateTags(string $content = '', array $configuration = null)
       {
           return implode(',', array_unique(array_filter(array_merge(
               GeneralUtility::trimExplode(',', $content),
               $this->tags
           ))));
       }
   }

Acknowledgements
----------------

Acknowledgements to `pietzpluswild GmbH <https://www.ppw.de/>`_ who allowed me to
dive into the topic and to implement a solution for their customer `Stadtwerke Bonn
<https://www.stadtwerke-bonn.de/>`_.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8, 9 LTS.

Further reading
---------------

* TypoScript reference about adding cache tags to rendered page:
  :ref:`t3tsref:stdwrap-addpagecachetags`

* TypoScript reference about using and defining user functions:
  :ref:`t3tsref:stdwrap-postUserFunc`
