.. highlight:: php
.. post:: Sep 15, 2017
   :tags: facebook
   :excerpt: 2

How to get an access token to access Facebook open graph
========================================================

If you want to develop something for or with Facebook, you always need an ``access_token``. Facebook
provides different access tokens, most of them are received using OAuth. But for command line tools
and development there is another way to receive the tokens.

Example setup
-------------

For our example we have a hidden Facebook page. We want to retrieve photos of this page through a
PHP command line tool. Therefore we create an app at https://developers.facebook.com/ .

The code for PHP looks like the following::

    <?php

    require_once 'vendor/autoload.php';

    $fb = new \Facebook\Facebook([
        'app_id' => $config['app_id'],
        'app_secret' => $config['app_secret'],
        'default_graph_version' => 'v2.10',
        'default_access_token' => $config['access_token'],
    ]);

    $response = $fb->get('me/photos?type=uploaded');
    $photos = $response->getDecodedBody()['data'];
    foreach ($photos as $photo) {
        if (isset($photo['name'])) {
            echo $photo['name'] . PHP_EOL;
        }
    }

To run our code we need to fill the ``$config`` array with our *App ID* and *App Secret*. Both can
be obtained from within the dashboard of the app. Still we are missing the ``access_token``.

Retrieval of access token
-------------------------

To retrieve the ``access_token``, we head over to the `Graph API Explorer
<https://developers.facebook.com/tools/explorer/145634995501895/>`_.

At the upper right corner, you can get the access token for a page:

.. figure:: /images/2017/GraphAPIExplorer.png
    :align: center

    Figure 1-1: Retrieve access tokens through Graph API Explorer.

You can select *Get Page Access Token*. Facebook will guide you through the OAuth process to allow
*Graph API Explorer* to obtain the necessary permissions. Afterwards you will see a list of pages,
which you have access to. Select the according page and copy the *Access Token* from input.

Also the *Graph API Explorer* allows you to discover the API and check which data will be returned.


Further reading
---------------

- https://developers.facebook.com

- `Graph API Explorer <https://developers.facebook.com/tools/explorer/145634995501895/>`_
