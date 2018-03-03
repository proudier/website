---
layout: post
title: Purging former kernel versions on CentOS, Fedora, RedHat
categories:
- Administration
tags:
- Linux
- CentOS
- Fedora
- RedHat
- RHEL
comments: []
---
How to purge the old, not-used-anymore versions of the Linux kernel on Fedora, CentOS and RedHat (RHEL), in one line.

```
package-cleanup --oldkernels --count=2
```

Where 2 is the number of version you want to keep, including the lastest version. In other word a value of 2 means 1 active kernel and 1 former version.

It requires the `yum-utils` package to be installed.

To make this behavior permanent, add the following line under the `[main]` section in `/etc/yum.conf`:

```
installonly_limit=2
```

Now on, old kernels are purged whenever new ones are installed by YUM.