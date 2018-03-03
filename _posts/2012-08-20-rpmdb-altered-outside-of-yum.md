---
layout: post
title: RPMDB altered outside of yum
categories:
- Administration
tags:
- Linux
- CentOS
- RedHat
- RHEL
comments: []
---
If when running YUM, you get the following message:
```
Warning: RPMDB altered outside of yum.
```

It means at least one package has been install using RPM directly. Consequently, some cache used by YUM are now out-of-sync with the RPMDB.

To sync the cache and get ride of this warning, one juste has to purge YUM's cache to force its reconstruction next time YUM is ran.

```bash
yum clean all
```

To prevent this situation, use YUM even when installing a local rpm file. Use

```bash
yum --nogpgcheck install package-4.6.3.rpm
```

Instead of
```bash
rpm --install --test package-4.6.3.rpm
```

Note that there is a `localinstall` option to YUM that is kept for compatibility reasons but really behaves like `install`.
