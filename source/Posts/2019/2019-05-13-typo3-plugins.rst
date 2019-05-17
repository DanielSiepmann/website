.. post:: May 14, 2019
   :tags: typo3, extbase, typoscript
   :excerpt: 3

TYPO3 plugins
=============

You might think "I know what plugins, within TYPO3, are". Maybe that's true, maybe
you still will learn something new.

This Blog post will first explain what TYPO3 plugins are. But he will also explain
how to define site specific plugins for existing installed 3rd Party extensions, and
why this might be useful.

This will only cover Extbase plugins, as most Extensions only provide Extbase
nowadays. But it also works, partly, for pibase extensions. The basic idea dates back
to 2018, when I first started to work on this. We now make use of this concept within
an actual project, so this covers not only abstract concepts, but real world examples.

.. todo:: Explain the prerequisites (knowledge of the integrator/developer for this blog post.

What is a TYPO3 plugin?
-----------------------

To understand the whole Blog post, one needs to understand the basics of plugins
within TYPO3.

TYPO3 itself it nothing then a collection of so called "Extensions". An Extension is
something that extends TYPO3 in any way. This can either be done by providing Plugins
and custom PHP code, or by providing CSS, JS, Fluid Templates, Hooks, or anything
else. Within this post, we will only cover a specific aspect of Plugins.

Plugins are a way to integrate custom PHP logic into TYPO3 for frontend websites. An
editor is able to insert a new content element of type "Insert Plugin", where he can
select the specific plugin. This plugin can be something like "List news" or "List
events". A plugin can also be an search form or search result or some other kind of
form. In the end, a plugin can be anything.

Most extensions provide plugins out of the box. Most likely you will have a single
plugin per extension. The extension author allows the editor to select further
configuration options through the content element, via so called FlexForms. E.g. the
editor can select the "mode", e.g. "list" or "detail" for something like news.

Within TYPO3 Extbase, an plugin consists of the following:

* A title for the editor within the TYPO3 backend

* An optional icon within TYPO3 backend

* TypoScript defining the rendering of the plugin

* A combination of callable controller and actions

* A combination of non cached callable controller and actions

* An identifier, so called "plugin signature"

* An optional FlexForm for further configuration via editors

* An optional New Content Element Wizard entry for new content elements

Why adding plugins for existing extensions?
-------------------------------------------

So extensions already provide plugins, why should one add further plugins to existing
3rd party extensions?

Example 1 EXT:solr + news
~~~~~~~~~~~~~~~~~~~~~~~~~

.. todo:: Explain the approach and reason / combination / usage more.

Let's assume there is a TYPO3 installation with a search, provided by EXT:solr, and
news, using the "Custom Page Type approach™", see (Blog Post:
:ref:`everything-is-content` and TYPO3 Documentation :ref:`t3coreapi:page-types`).
Everything is working, all news are searchable.

Now the customer want an index of all news within the "News" page. Maybe he also
needs some pre filtered news on sub pages, e.g. only news regarding new products or
news regarding the company.

Of course one could now add TypoScript to these pages to configure EXT:solr to start
in filter mode instead of search mode. Also filter can be added to only show news
records from these categories. This is not that flexible. The editor is not able to
add new "News listings" to further pages, as TypoScript is involved.

Instead the integrator can add a new plugin "news" within the "Sitepackage™" of the
installation. This plugin duplicates the existing plugin, provided by EXT:solr.
Instead of keeping the result action none cacheable, it can define that this action
should be cacheable. Also a new plugin allows to add a different FlexForm to this
plugin. These FlexForm can provide a drop down with possible categories, or allow an
editor to define how many news should be displayed. Thanks to Extbase conventions,
all options available within TypoScript ``settings`` section can be used within
FlexForms. Due to a different plugin signature, the plugin can be configured
differently via TypoScript.

This new Plugin speeds up the delivery of the page, as it's fully cached. Also an
editor can now add a "news" content element and select the specific category and
number of news to display. He does not need to understand that solr is used.

Example 2 - EXT:news
~~~~~~~~~~~~~~~~~~~~

In case of EXT:news, one might to add "recent news" to the pages. This might contain
a configurable number of news entries and different layouts, like "list" or "slider".
This is another example where custom plugins for existing 3rd party extensions might
be useful. One can create those content elements and plugins.

Another benefit of this example: One can add "recent news" on news detail page
without thinking about any limitations. Due to being another plugin with a different
signature, no arguments might create trouble. Also links created between those
plugins can make use of the Extbase setting:

.. code-block:: typoscript

   plugin.tx_news_recentnews {
       features {
           skipDefaultArguments = 1
       }
   }

This can also be enabled for the whole extension:

.. code-block:: typoscript

   plugin.tx_news {
       features {
           skipDefaultArguments = 1
       }
   }

Or whole installation / page:

.. code-block:: typoscript

   config.tx_extbase {
       features {
           skipDefaultArguments = 1
       }
   }

A link between those plugins can look like this, assuming to link from "Recent News"
to "Detail News" custom plugin:

.. code-block:: html

   <f:link.action pageUid="11"
      pluginName="Details"
      arguments="{news: news}"
   >
      <h4>{news.title}</h4>
   </f:link.action>

As each plugins has his own default Controller-Action-Combination, there is no need
to add them to the URL generation. Also thanks to the configuration of
``skipDefaultArguments``, these will not be added to the url, resulting in an URL
like this with CMS v9:

.. code-block:: text

   /?news_details%5Bnews%5D=1785&cHash=1f740d5404dddcf84b2c8bebc985deb9

How to add a new TYPO3 plugin
-----------------------------

To add a new plugin, first of one API call is necessary. After this was done,
the plugin is already available to the frontend. Next the content element can be
created in the preferred way, which depends on the agency and developer.

Afterwards the optional FlexForm and TypoScript configuration can be added.

For further information, take a look at :ref:`typo3-custom-plugin-real-world-example`.

Conclusion for Extbase controller
---------------------------------

Each controller within an Extbase extension should consist of actions, which only do
a single task. By providing fine grained actions for single tasks, the Integrator is
able to configure installation specific plugins.

A contrary example was developed by myself and our team during my training.  There we
created a single controller with nearly 10 actions, all doing the same. Just to
provide 10 different template variants. Today one could use ten custom plugins, or
even better use a setting like the ``layout`` field within content element, together
with an ``f:render`` call within Fluid to switch the rendering.

.. _typo3-custom-plugin-real-world-example:

Real world example
------------------

The following example demonstrates the concept based on EXT:news and a new content
element to display recent news. The editor can configure how many news should be
displayed.

#. Register plugin within :file:`ext_localconf.php`:

   .. code-block:: php

      \TYPO3\CMS\Extbase\Utility\ExtensionUtility::configurePlugin(
          'GeorgRinger.news',
          'Recent',
          [
              'News' => 'list',
          ]
      );

#. Configure TCA for content element within
   :file:`Configuration/TCA/Overrides/tt_content_recent_news.php`:

   .. code-block:: php
      :linenos:

      (function ($tablename = 'tt_content', $contentType = 'recent_news') {
          \TYPO3\CMS\Core\Utility\ArrayUtility::mergeRecursiveWithOverrule($GLOBALS['TCA'][$tablename], [
              'ctrl' => [
                  'typeicon_classes' => [
                      $contentType => 'content-recent-news',
                  ],
              ],
              'types' => [
                  $contentType => [
                      'showitem' => implode(',', [
                          '--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general',
                              '--palette--;;general',
                              'pi_flexform',
                          '--div--;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:tabs.appearance,--palette--;;frames,--palette--;;appearanceLinks,',
                          '--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:language,--palette--;;language,',
                          '--div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,
                            --palette--;;hidden,
                            --palette--;;access,
                          --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:categories,
                               categories,
                          --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:notes,
                               rowDescription,
                          --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:extended,'
                      ]),
                  ],
              ],
              'columns' => [
                  'pi_flexform' => [
                      'config' => [
                          'ds' => [
                              '*,' . $contentType => 'FILE:EXT:sitepackage/Configuration/FlexForms/ContentElements/RecentNews.xml',
                          ],
                      ],
                  ],
              ],
          ]);

          \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
              $tablename,
              'CType',
              [
                  'Recent News',
                  $contentType,
                  'content-recent-news',
              ],
              'textmedia',
              'after'
          );
      })();

#. Optional, add and register FlexForm.

   Registration is happening in TCA, see above example, line 27-35.

   The FlexForm itself can be like the following
   :file:`Configuration/FlexForms/ContentElements/RecentNews.xml`.:

   .. code-block:: xml

      <T3DataStructure>
         <sheets>
            <sDEF>
                  <ROOT>
                     <TCEforms>
                        <sheetTitle>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_tab.settings</sheetTitle>
                     </TCEforms>
                     <type>array</type>
                     <el>
                        <!-- Limit Start -->
                        <settings.limit>
                              <TCEforms>
                                 <label>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_additional.limit</label>
                                 <config>
                                    <type>input</type>
                                    <size>5</size>
                                    <eval>num</eval>
                                 </config>
                              </TCEforms>
                        </settings.limit>

                        <!-- Offset -->
                        <settings.offset>
                              <TCEforms>
                                 <label>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_additional.offset</label>
                                 <config>
                                    <type>input</type>
                                    <size>5</size>
                                    <eval>num</eval>
                                 </config>
                              </TCEforms>
                        </settings.offset>

                        <!-- Category Mode -->
                        <settings.categoryConjunction>
                              <TCEforms>
                                 <label>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction</label>
                                 <config>
                                    <type>select</type>
                                    <renderType>selectSingle</renderType>
                                    <items>
                                          <numIndex index="0" type="array">
                                             <numIndex index="0">LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction.all</numIndex>
                                             <numIndex index="1"></numIndex>
                                          </numIndex>
                                          <numIndex index="1">
                                             <numIndex index="0">LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction.or</numIndex>
                                             <numIndex index="1">or</numIndex>
                                          </numIndex>
                                          <numIndex index="2">
                                             <numIndex index="0">LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction.and</numIndex>
                                             <numIndex index="1">and</numIndex>
                                          </numIndex>
                                          <numIndex index="3">
                                             <numIndex index="0">LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction.notor</numIndex>
                                             <numIndex index="1">notor</numIndex>
                                          </numIndex>
                                          <numIndex index="4">
                                             <numIndex index="0">LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categoryConjunction.notand</numIndex>
                                             <numIndex index="1">notand</numIndex>
                                          </numIndex>
                                    </items>
                                 </config>
                              </TCEforms>
                        </settings.categoryConjunction>

                        <!-- Category -->
                        <settings.categories>
                              <TCEforms>
                                 <label>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.categories</label>
                                 <config>
                                    <type>select</type>
                                    <renderMode>tree</renderMode>
                                    <renderType>selectTree</renderType>
                                    <treeConfig>
                                          <dataProvider>GeorgRinger\News\TreeProvider\DatabaseTreeDataProvider</dataProvider>
                                          <parentField>parent</parentField>
                                          <appearance>
                                             <maxLevels>99</maxLevels>
                                             <expandAll>TRUE</expandAll>
                                             <showHeader>TRUE</showHeader>
                                          </appearance>
                                    </treeConfig>
                                    <foreign_table>sys_category</foreign_table>
                                    <foreign_table_where>AND (sys_category.sys_language_uid = 0 OR sys_category.l10n_parent = 0) ORDER BY sys_category.sorting</foreign_table_where>
                                    <size>15</size>
                                    <minitems>0</minitems>
                                    <maxitems>99</maxitems>
                                 </config>
                              </TCEforms>
                        </settings.categories>

                        <!-- Include sub categories -->
                        <settings.includeSubCategories>
                              <TCEforms>
                                 <label>LLL:EXT:news/Resources/Private/Language/locallang_be.xlf:flexforms_general.includeSubCategories</label>
                                 <config>
                                    <type>check</type>
                                 </config>
                              </TCEforms>
                        </settings.includeSubCategories>
                     </el>
                  </ROOT>
            </sDEF>
         </sheets>
      </T3DataStructure>

#. Configure PageTSconfig for content element to add it to the new content element wizard::

   .. code-block:: typoscript

      mod {
          wizards.newContentElement.wizardItems.common {
              elements {
                  recent_news {
                      iconIdentifier = content-recent-news
                      title = Recent News
                      description = Displayes recent news
                      tt_content_defValues {
                          CType = recent_news
                          pi_flexform (
                              <?xml version="1.0" encoding="utf-8" standalone="yes" ?>
                              <T3FlexForms>
                                  <data>
                                      <sheet index="sDEF">
                                          <language index="lDEF">
                                              <field index="settings.limit">
                                                  <value index="vDEF">4</value>
                                              </field>
                                          </language>
                                      </sheet>
                                  </data>
                              </T3FlexForms>
                          )
                      }
                  }
              }
              show := addToList(recent_news)
          }
          web_layout.tt_content.preview.recent_news = EXT:sitepackage/Resources/Private/Templates/ContentElementsPreview/RecentNews.html
      }

#. Configure TypoScript for rendering of content element:
   (This example assumes EXT:fluid_styled_content is used)

   .. code-block:: typoscript

      tt_content.recent_news =< tt_content.list.20.news_recent
      plugin.tx_news_recent {
          settings {
              orderBy = datetime
              orderDirection = desc
          }
          view {
              templateRootPaths {
                  10 = EXT:sitepackage/Resources/Private/Templates/Plugins/News/RecentNews/
              }
              pluginNamespace = news_recent
          }
      }

#. Add fluid template accordingly to configured paths.

#. Optional, register Icon for content element within :file:`ext_localconf.php`:

   .. code-block:: php

      $icons = [
          'content-recent-news' => 'EXT:news/Resources/Public/Icons/Extension.svg',
      ];
      $iconRegistry = \TYPO3\CMS\Core\Utility\GeneralUtility::makeInstance(\TYPO3\CMS\Core\Imaging\IconRegistry::class);
      foreach ($icons as $identifier => $path) {
          $iconRegistry->registerIcon(
              $identifier,
              \TYPO3\CMS\Core\Imaging\IconProvider\SvgIconProvider::class,
              ['source' => $path]
          );
      }

Acknowledgements
----------------

Acknowledgements to `pietzpluswild GmbH <https://www.ppw.de/>`_ and `KM2 >>
netz:innovationen.gmbh <https://km2.de/>`_ who allowed me to dive into the topic and
to implement a solution for their customers.

Checked for TYPO3 Versions
--------------------------

The post was checked against TYPO3 version 8 LTS, 9 LTS.

Further reading
---------------

* :ref:`FlexForm data structure <t3coreapi:t3ds>`

* :ref:`t3extbasebook:configuring-the-plugin`

* :ref:`t3tsconfigref:pagenewcontentelementwizard`

* :ref:`t3tcaref:start`

* :ref:`t3coreapi:icon`
