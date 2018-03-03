---
layout: post
title: A free virtualization platform with a web-interface
categories:
- Administration
tags:
- CentOS
- RedHat
- RHEL
- Virtualization
- VirtualBox
comments: []
---

In this post, we will put together a headless installation of VirtualBox, the VirtualBox web services and a we will install phpVirtualBox on RedHat.

# VirtualBox

Oracle provides a [repository](http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo) but the servers were so slow that I had to download directly the rpm file from the [download page](https://www.virtualbox.org/wiki/Linux_Downloads). That's a pity, i'll have to deal with the updates myself. Anyway, make sure you download the right rpm: `Oracle Linux 6 ("OL6") / Red Hat Enterprise Linux 6 ("RHEL6") / CentOS 6 *AMD64*` in my case.

```
yum install VirtualBox-4.3-4.3.2_90405_el6-1.x86_64.rpm
```

Now you have to setup the kernel module. To do so, you'll need to have some dependencies installed

```
yum install kernel-devel dkms
```

Having your system updated will help avoiding troubles.  Now for the real thing:

```
service vboxdrv setup
```

If compilation fails, make sure the kernel version your are running correspond to the latest version installed on your system. Such a discrepancy can occur if you have updated your kernel but have not restarted the server yet.

# VirtualBox Extension Pack

Given our current target, you might be interested in the features offered by the extension pack:

*   VirtualBox RDP
*   PXE boot for Intel cards

If you are not interested you can skip this section. Else, download the pack from the [download page](https://www.virtualbox.org/wiki/Linux_Downloads) and push it to your server or

```
wget http://download.virtualbox.org/virtualbox/4.3.2/Oracle_VM_VirtualBox_Extension_Pack-4.3.2-90405.vbox-extpack
```

Then install it

```
VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-4.3.2-90405.vbox-extpack
```

Note: this command will fail if an older version of the same extension pack is already installed. The optional --replace parameter can be used to uninstall the old package before the new package is installed. See [manual](https://www.virtualbox.org/manual/ch08.html#vboxmanage-extpack).

# VirtualBox Web Service

If you try to start the webservice at this point, you be very disappointed: it won't start and won't give any explanation. Looking at the startup script `/etc/init.d/vboxweb-service`, I found the source of this behavior:

```
[ -z "$VBOXWEB_USER" ] && exit 0
```

The script being fairly organized, one can easily understand this variable is supposed to be defined in `/etc/vbox/vbox.cfg`.

Create a user, set its password and edit `vbox.cfg`:

```
useradd -g vboxusers -N vboxws
passwd vboxws
mkdir /etc/vbox/
echo "VBOXWEB_USER=vboxws" >> /etc/vbox/vbox.cfg
```

Now you can (re)start the service

```
service vboxweb-service restart
```

# phpVirtualBox

I'll assume you've already set up a running web server that serves files from `/var/www/html/` and have PHP enabled.

Download the archive from [SourceForge](http://sourceforge.net/projects/phpvirtualbox/). Be careful to download the version corresponding to your version of Virtualbox.

```
mkdir /var/www/html/phpvirtualbox
cd /var/www/html/phpvirtualbox
unzip phpvirtualbox-4.3-0.zip
cp config.php-example config.php
sed -i "s/$username = 'vbox'/$username = 'vboxws'/" config.php
sed -i "s/$password= 'pass'/$password= 'my-password'/" config.php
```

phpVirtualBox required the PHP SOAP module.

```
yum install php-soap
```

Now, using your browser, you can connect to phpVirtualBox. The default login/password is admin/admin.

Enjoy!