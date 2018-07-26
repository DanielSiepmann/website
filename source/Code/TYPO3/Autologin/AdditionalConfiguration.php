<?php

namespace {
    \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addUserTSConfig('
        options {
            clearCache {
                system = 1
            }
            pageTree {
                showPageIdWithTitle = 1
                showDomainNameWithTitle = 1
                showPathAboveMounts = 1
                searchInAlias = 1
            }
        }
        ADMPANEL {
            enable.all = 1
        }
    ');
}

namespace Codappix\CdxAutoLogin {

    use TYPO3\CMS\Core\Utility\ExtensionManagementUtility;
    use TYPO3\CMS\Sv\AbstractAuthenticationService;

    /**
     * Auto login the configured user.
     */
    class AutoAuthenticationTypo3Service extends AbstractAuthenticationService
    {
        public function getUser()
        {
            return $this->fetchUserRecord('place your username here');
        }

        public function authUser(array $user)
        {
            return 200;
        }
    }

    if ((TYPO3_REQUESTTYPE & TYPO3_REQUESTTYPE_CLI) === 0) {
        ExtensionManagementUtility::addService(
            'sv',
            'auth',
            AutoAuthenticationTypo3Service::class,
            [
                'title' => 'Auto User authentication',
                'description' => 'Auto authenticate user with configured username',
                'subtype' => 'authUserBE,getUserBE',
                'available' => true,
                'priority' => 100,
                'quality' => 50,
                'className' => AutoAuthenticationTypo3Service::class,
            ]
        );

        $GLOBALS['TYPO3_CONF_VARS']['SVCONF']['auth']['setup']['BE_alwaysFetchUser'] = true;
        $GLOBALS['TYPO3_CONF_VARS']['SVCONF']['auth']['setup']['BE_alwaysAuthUser'] = true;
    }
}
