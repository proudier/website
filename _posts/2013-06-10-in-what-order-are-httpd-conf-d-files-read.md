---
layout: post
title: In what order are HTTPd conf.d files read?
categories:
- Administration
tags:
- Apache
- HTTPd
comments: []
---

Answer is: alphabetically.

Most GNU/Linux distribution come preconfigured with a folder storing modular config files for Apache HTTPd.
On RedHat and CentOS systems, this folder is `/etc/httpd/conf.d/`

These configuration files are taken into account because of the `Include` directive found in `/etc/httpd/conf/httpd.conf`

```
#
# Load config files from the config directory "/etc/httpd/conf.d".
#
Include conf.d/*.conf
```

The doc about the Include directive states that wildcard are allowed and the replacement is assured to be alphabetically ([source](http://httpd.apache.org/docs/current/en/mod/core.html#include))

> Shell-style (fnmatch()) wildcard characters can be used in the filename or directory parts of the path to include several files at once, in alphabetical order.

Because the order is fixed, sysadmins can split `VirtualHost` configurations in different files.
I tend to have one file per vhost; each file being name after the corresponding host name. On top of that, I name `aaa_vhost.conf` the file used to define the default vhost.
