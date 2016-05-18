<?php
namespace DS\ExampleExtension\Service;

/*
 * This file is part of the TYPO3 CMS project.
 *
 * It is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, either version 2
 * of the License, or any later version.
 *
 * For the full copyright and license information, please read the
 * LICENSE file that was distributed with this source code.
 *
 * The TYPO3 project - inspiring people to share!
 */

use TYPO3\CMS\Extbase\Configuration\ConfigurationManagerInterface;

/**
 * Example Service to demonstrate inject of settings from tx_news.
 *
 * @author Daniel Siepmann <coding@daniel-siepmann.de>
 */
class SomeService
{
   /**
     * Inject news settings via ConfigurationManager.
     *
     * @param ConfigurationManagerInterface $configurationManager
     *
     * @return SomeService
     */
    public function injectConfigurationManager(ConfigurationManagerInterface $configurationManager)
    {
        $this->newsSettings = $configurationManager->getConfiguration(
            ConfigurationManagerInterface::CONFIGURATION_TYPE_SETTINGS,
            'News',
            'pi1'
        );

        return $this;
    }
}