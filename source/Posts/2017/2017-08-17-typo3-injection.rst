.. post:: Aug 17, 2017
   :tags: typo3, extbase, dependency injection
   :excerpt: 2

.. highlight:: php

.. _typo3ExtbaseInjection:

TYPO3 (Extbase) Injection
=========================

TYPO3 provides a way of dependency injection. This way you do not need to resolve dependencies
inside of your code, but the framework will resolve and provide the dependencies for you. This is
provided by the framework Extbase, back ported of Flow.

The main benefit is the flexibility. Using Interfaces to define dependencies, instead of concrete
classes, it's possible to exchange injected dependencies just by configuring the framework. This way
you can exchange classes in 3rd party code and receive a huge flexibility. Same goes for testing
your code. In this Post I will show you the different ways to make use of dependency injection
inside of TYPO3 and provide help for edge cases.

Possible inject methods
-----------------------

There are three different ways to make use of dependency injection:

Via annotation
    Annotate a class property with ``@inject`` to enable Extbase to resolve the dependency through
    reflection::

        /**
         * @var \TYPO3\CMS\Extbase\Utility\ArrayUtility
         * @inject
         */
         protected $arrayUtility;

Via inject method
    You can provide a method that's reflected by the framework to inject a dependency. The main
    benefit is that you are able to initialize the dependency. A typical use case it to inject the
    logger through a method, as you inject the ``LogManager`` and fetch the concrete ``Logger``
    inside the method::

        /**
         * @var \TYPO3\CMS\Core\Log\Logger
         */
        protected $logger;

        public function injectLogger(\TYPO3\CMS\Core\Log\LogManager $logManager)
        {
            $this->logger = $logManager->getLogger(__CLASS__);
        }

    Another example is injection of settings through the ``ConfigurationManager``, see
    :ref:`injectTypoScriptSettings`.

Via constructor
    Extbase will also reflect the ``__construct`` method and inject dependencies not provided during
    construction::

        public function __construct(ConfigurationContainerInterface $configuration)
        {
            $this->configuration = $configuration;
        }

Differences for methods
-----------------------

With each method comes some difference:

With annotation
    You are not able to access the injected dependencies in your ``__construct`` but the special
    method ``initializeObject``.

    Also you have to use the FQCN (=Fully qualified class name), so import statements will not work
    here.

With inject method
    Like with annotation, you are not able to access the injected dependencies in your
    ``__construct`` but the special method ``initializeObject``.

    It's possible to use ``use`` statements. As only the signature is reflected, no comment is
    needed at all.

    The method has to be ``public`` and start with ``inject``. The special method ``injectSettings``
    is blocked and will not work.

With constructor
    It's possible to use ``use`` statements. As only the signature is reflected, no comment is
    needed at all.

When injection is not working
-----------------------------

As dependency injection is part of Extbase and not TYPO3 Core, it will not work if you instantiate
new instances through ``new`` or
:ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::makeInstance`. You have to use
:ref:`t3api:TYPO3\\CMS\\Extbase\\Object\\ObjectManager::get`. The ``ObjectManager`` will also take
care of all sub dependencies.

Therefore you should use hooks and further stuff only as proxies, connecting your logic to the
system through its API. This way you are able to load your logic through the ``ObjectManager``
resolving all dependencies, and are also able to reuse the logic in different places.

While calling ``get`` you can provide constructor arguments. You have to provide them in the way
they are defined in the method signature. All arguments left undefined will be resolved through
dependency injection. This way it's possible to create a new instance and inject different
dependencies::

    class MyOwnClass
    {
        public function __construct(
            ArrayUtilityInterface $arrayUtility,
            AnotherInterface $anotherDepdendency
        ) {
            // ...
    }

    class MyOwnArrayUtility implements ArrayUtilityInterface
    {
        // ...
    }

    $customArrayUtility = $this->objectManager->get(MyOwnArrayUtility::class);
    $this->objectManager->get(MyOwnClass::class, $customArrayUtility);

Just make sure to extend the original class or implement the expected interface.
Therefore it's much better to define interfaces and to use them in your signatures, then concrete
class implementations.

Configuring dependencies
------------------------

Once you make use of dependency injection, you might want to exchange one resolved dependency for
some reason, e.g. in a 3rd party or core Extension.

There are two ways you can configure dependencies to be resolved. One is TypoScript and the other is
PHP.

TypoScript
    You have to configure the dependencies the following way:

    .. code-block:: typoscript

        config.tx_extbase {
            object {
                TYPO3\CMS\Extbase\Persistence\Storage\BackendInterface {
                    className = DS\ExampleExtension\Persistence\Storage\Backend
                }
            }
        }

    The above example will inject our own implementation
    ``\DS\ExampleExtension\Persistence\Storage\Backend`` whenever
    ``\TYPO3\CMS\Extbase\Persistence\Storage\BackendInterface`` is required.

    The downside of this approach is, that Extbase bootstrapping has to be run to initialize the
    ``ObjectManager`` with this configuration. But in TYPO3 there are enough situation when this is
    not the case, e.g. in Hooks.

    The benefit is, you can also configure different dependencies per extension, plugin or module:

    .. code-block:: typoscript

        plugin.tx_exampleextension {
            object {
                TYPO3\CMS\Extbase\Persistence\Storage\BackendInterface {
                    className = DS\ExampleExtension\Persistence\Storage\PluginSpecificBackend
                }
            }
        }

        module.tx_exampleextension {
            object {
                TYPO3\CMS\Extbase\Persistence\Storage\BackendInterface {
                    className = DS\ExampleExtension\Persistence\Storage\ModuleSpecificBackend
                }
            }
        }

PHP
    The other way is to directly configure the ``ObjectManager``::

        \TYPO3\CMS\Core\Utility\GeneralUtility::makeInstance(\TYPO3\CMS\Extbase\Object\Container\Container::class)
            ->registerImplementation(
                \Codappix\SearchCore\Connection\ConnectionInterface::class,
                \Codappix\SearchCore\Connection\Elasticsearch::class
            );

    You should place this inside of a :file:`ext_localconf.php`.
    This way the configuration is available no matter which context is used. Therefore this should
    be preferred. Still this will always configure globally.

If nothing is configured, Extbase will remove the trailing ``Interface`` of the dependency and try
to inject the class name, so for ``Vendor\Extension\Utility\ExampleUtilityInterface`` Extbase will
try to provide ``Vendor\Extension\Utility\ExampleUtility``.

Caching
-------

As reflection is a bit expensive, Extbase will cache the information. Therefore you have to clear
cache once you add a new dependency injection, no matter which method you are using. Otherwise you
will see method calls to non objects, or non working instantiations, as they are not injected. The
used cache is ``extbase_object``.

How to use in tests
-------------------

Another big benefit of the flexibility is used inside of tests. Compare the "old way" vs. the new
way:

Old::

    class SomeClass
    {
        protected $exampleUtility;

        public function __construct()
        {
            $this->exampleUtility = GeneralUtility::makeInstance(ExampleUtility::class);
        }
    }

New::

    class SomeClass
    {
        protected $exampleUtility;

        public function __construct(ExampleUtilityInterface $exampleUtility)
        {
            $this->exampleUtility = $exampleUtility
        }
    }

The new one makes it very easy to pass a mocked version of a dependency inside of our tests, that's
true for all the methods, enabling us to mock the behaviour and create a unit test for a single
class. For annotation and method there is a helper method you might use inside of your tests to
inject the dependency.

The helper method is part of ``BaseTestCase`` and is called ``inject``::

    $testSubject = new ClassToTest();
    $this->inject($testSubject, 'exampleUtility', $this->getMockBuilder(ExampleUtilityInterface::class)->getMock());

Which method should you use?
----------------------------

I would prefer the ``_construct`` approach, as it's not only working with Extbase, but also the only
way to really define dependencies. Everyone still can create instances through ``makeInstance`` or
``new``. But they still have to provide the dependencies. Also they can not be altered once an
instance exists.

Further reading
---------------

- :ref:`t3api:TYPO3\\CMS\\Core\\Utility\\GeneralUtility::makeInstance`

- :ref:`t3api:TYPO3\\CMS\\Extbase\\Object\\ObjectManager::get`

- Also you might find the post :ref:`injectTypoScriptSettings` useful.

- Github gist in a form of a Blog post about this topic https://gist.github.com/NamelessCoder/3b2e5931a6c1af19f9c3f8b46e74f837

- German Blog post about this topic http://www.typo3tiger.de/blog/post/extbase-dependency-injection.html
