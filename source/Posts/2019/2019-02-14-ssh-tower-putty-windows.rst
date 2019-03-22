.. post:: Feb 14, 2019
   :tags: windows, ssh, git, ddev
   :excerpt: 2

Setting up SSH on Windows 10, using PuTTY, Tower and ddev
=========================================================

One of our web agency customers has a Windows only setup. So every developer is using
Windows, nothing else. To setup a working environment, including git push and pull,
and deployments via php `Deployer`__, I needed to setup SSH for the developers.

As I didn't find any single source that guided me through all the steps, that were
necessary in our case, this Blog post will try to be this source. It will describe
the steps I took to setup SSH under Windows 10, together with Git client `Tower`__
and drud `ddev`__ as docker development environment. Last one is involved due to git
clone, e.g. via composer, and for deployments, via Deployer.

.. danger::

   I'm not working with Windows since years. There might be better ways than
   described in this blog post, e.g. someone told me about a native Windows ssh
   agent. So this guide "works for me" at the Laptop of my customer.

   Do not take anything as best practice. If you know a better way, just send me an
   mail.

This Blog post will not go into detail on each aspect, e.g. it will not be explained
what SSH Keys are, its just about the process to setup everything.

Goal
----

The goal is to allow ``git push`` and ``git pull`` via Tower using ssh for
authentication. Also ddev should be able to run Composer commands which need to
clone some packages via ssh. In addition ddev should be able to run software like
Deployer to deploy our software, or fetch database and assets from an staging
environment. To access servers ssh is used again.

Necessary software
------------------

The following software needs to be installed:

PuTTY

   https://putty.org/

   Software bundle which allows to:

   * Create new SSH Keys

   * Connect to servers via SSH

   * Convert SSH Keys between formats

Tower

   https://www.git-tower.com/

   A GUI client for Git, which provides all typical tasks like:

   * Clone

   * Commit (also partial)

   * Push

   * Pull

Ddev

   https://github.com/drud/ddev

   Wrapper around Docker Compose to make web development easier. Especially for
   `TYPO3`__.

Generate Keys
-------------

First of all SSH Keys have to be generated. PuTTYgen is the tool to use, which is
packed in PuTTY. PuTTYgen will generate a single file with extension
``ppk`` which is a Putty Private Key. This file can be saved somewhere. I would
recommend to save this file within ``C:\Users\<username>\.ssh\id_rsa.ppk``.

In addition to the Putty Private Key, another format is necessary. In order to create
this file, the created ppk can be exported via "Conversions > Export OpenSSH key",
within PuTTYgen. This file should be saved at ``C:\Users\<username>\.ssh\id_rsa``.
Create another file ``C:\Users\<username>\.ssh\id_rsa.pub`` next to it and paste in
the "public key" from PuTTYgen UI.

The Keys are now available in two different formats.

Add keys
--------

In order to allow software to use those keys, Pageant has to be started (which is
delivered by PuTTY). Open the software and add ``C:\Users\<username>\.ssh\id_rsa``.

Next Plink (which is delivered by PuTTY) has to be added to the autostart. Therefore
create a new shortcut inside the autostart folder, edit this shortcut to not only
point to ``plink.exe`` but also add the argument to load the Putty Private Key. The
whole shortcut should look like this:
``"C:\Program Files\PuTTY\plink.exe" -i "C:\Users\<username>\.ssh\id_rsa.ppk"``.
This way the key will be loaded during startup and is available.

Use keys within Tower
---------------------

Activate "Use local SSH settings" flag in Tower's preferences.

Use keys within ddev
--------------------

This is one of the easiest parts, run ``ddev auth ssh`` inside the ddev project. The
ssh keys available in ``~/.ssh`` which is ``C:\Users\<username>\.ssh`` on Windows
systems, are exposed to ddev and get used. This allows software like composer or
Deployer to use those keys. Therefore the keys had to be exported to OpenSSH, as most
likely Unix containers are used within ddev. At least this is the default.

Further reading
---------------

* https://www.ssh.com/ssh/putty/windows/puttygen

* https://www.simplified.guide/putty/convert-ppk-to-ssh-key

* https://www.ssh.com/ssh/putty/putty-manuals/0.68/Chapter9.html

* https://www.rz.uni-wuerzburg.de/dienste/it-sicherheit/sshlinux/ssh-key-agent/

* https://practical-admin.com/blog/glutton-for-punishment-using-plink-to-do-key-based-authentication/

* https://www.git-tower.com/help/win/remote-repositories/connect-authenticate

* https://ddev.readthedocs.io/en/stable/users/cli-usage/#ssh-into-containers

__ Tower: https://www.git-tower.com/mac
__ TYPO3: https://typo3.org.com/
__ Deployer: https://deployer.org/
__ ddev: https://ddev.readthedocs.io/
