.. highlight:: bash
.. post:: Nov 12, 2011
   :tags: apache, osx

Mac OS X, use the native Apache/PHP
===================================

I found out how to start the built in Apache in Mac OS X Lion (10.7.x) with standard configuration.

Just type the following in your Terminal::

    sudo apachectl -D WEBSHARING_ON -k start

help command shows the parameters::

    apachectl help
      Usage: /usr/sbin/httpd [-D name] [-d directory] [-f file]
    [-C "directive"] [-c "directive"]
    [-k start|restart|graceful|graceful-stop|stop]
    [-v] [-V] [-h] [-l] [-L] [-t] [-T] [-S]
    Options:
    -D name            : define a name for use in directives
    -d directory       : specify an alternate initial ServerRoot
    -f file            : specify an alternate ServerConfigFile
    -C "directive"     : process directive before reading config files
    -c "directive"     : process directive after reading config files
    -e level           : show startup errors of level (see LogLevel)
    -E file            : log startup errors to file
    -v                 : show version number
    -V                 : show compile settings
    -h                 : list available command line options (this page)
    -l                 : list compiled in modules
    -L                 : list available configuration directives
    -t -D DUMP_VHOSTS  : show parsed settings (currently only vhost settings)
    -S                 : a synonym for -t -D DUMP_VHOSTS
    -t -D DUMP_MODULES : show all loaded modules
    -M                 : a synonym for -t -D DUMP_MODULES
    -t                 : run syntax check for config files
    -T                 : start without DocumentRoot(s) check

If you start the Web sharing in the System Preferences, Mac will add the WEBSHARING\_ON. In the
``httpd.conf`` (``/etc/apache2/httpd.conf``) are If-Statemants looking for this parameter. So you
need to add the parameter.

Of course you can start Apache with other configurations. I'm using DANIEL\_SERVER instead of
WEBSHARING\_ON. I added the following lines to the system httpd.conf to include my custom
configuration from the user directory: ``Include /Users/daniel/Sites/apache/conf/httpd.conf``
