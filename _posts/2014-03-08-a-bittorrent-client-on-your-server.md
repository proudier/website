---
layout: post
title: A BitTorrent Client on your Server
categories:
- Administration
tags:
- Linux
- CentOS
- RHEL
- Bittorent
- Transmission
comments: []
---

This post describe how to install the [Transmission BitTorrent client](http://www.transmissionbt.com) on a headless, remote server. You'll be able to add new downloads via a web interface and mobile apps, such as [Remote Transmission](https://play.google.com/store/apps/details?id=com.neogb.rtac&hl=fr).

The installation is based on RedHat Entreprise Linux, aka RHEL, and derivatives like CentOS. You need the [EPEL repository](https://fedoraproject.org/wiki/EPEL) to be configured on your system.

Installation using YUM:

```
yum install transmission-deamon
```

Just to make sure...

```
service transmission-daemon stop
```

The RPM creates a "transmission" user, whose default home is at `/var/lib/transmission`.
Let's move everything related to P2P to a dedicated partition (mounted at `/mnt/storage/`)

```
usermod -m -d /mnt/storage/transmission/ transmission
```

Edit `/etc/sysconfig/transmission-daemon` with a text editor.

Uncomment `TRANSMISSION_HOME` and set a proper value (here `/mnt/storage/transmission`)

Also, we are going to configure the logging facilities of the daemon: uncomment `DAEMON_ARGS` and append `" --logfile=/var/log/transmission.log"`

Now your `/etc/sysconfig/transmission-daemon` you should like this:

```
TRANSMISSION_HOME=/mnt/storage/transmission/
# DAEMON_USER="foo"
DAEMON_ARGS="-T --blocklist -g $TRANSMISSION_HOME/.config/transmission-daemon --logfile=/var/log/transmission.log"
```

Save the file and exit your editor.

Prepare the log file:

```
touch /var/log/transmission.log
chown transmission:transmission /var/log/transmission.log
```

Now start then stop the daemon, so that it creates a default configuration file:

```
service transmission-daemon start
service transmission-daemon stop
```

The configuration file is `/mnt/storage/transmission/.config/transmission-daemon/settings.json`. As the extension suggests, the [JavaScript Object Notation](http://en.wikipedia.org/wiki/JSON) is used.

Open the file with a text editor.

To be able to access the web interface remotly, you have to either
set `rpc-whitelist-enabled` to `false`, or or edit `rpc-whitelist`

You can tweak other parameters, such as the maximum upload speed (`speed-limit-up`).

Save the file and exit your editor.

If needed, open the required ports on your firewall. The remote interface port is TCP 9091.

Finally:

```
service transmission-daemon start
chkconfig transmission-daemon on
```

Test you setup by connecting to http://${IP}:9091 with a browser.