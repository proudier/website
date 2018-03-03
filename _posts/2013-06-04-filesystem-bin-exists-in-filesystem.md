---
layout: post
title: '"filesystem: /bin exists in filesystem" error on Arch'
categories:
- Administration
tags:
- ArchLinux
comments:
- id: 12
  content: "Dude, thanksssss\r\n\r\nDespite of the '--force', everything works :)"
---

I hadn't updated my HTPC running [ArchLinux](https://www.archlinux.org/) for a while. So I decided to do some housekeeping tonight.

Unfortunaly I encountered the following error: `/bin exists in filesystem`

```
# pacman -Suy
/* (edited) */
error: failed to commit transaction (conflicting files)
filesystem: /bin exists in filesystem
filesystem: /sbin exists in filesystem
filesystem: /usr/sbin exists in filesystem
Errors occurred, no packages were upgraded.
```

Well, then you shall read the following article [Binaries move to /usr/bin requiring update intervention.](https://www.archlinux.org/news/binaries-move-to-usrbin-requiring-update-intervention/)

If you're updating a simple installation, with no custom packages and nothing installed manually (ie: without pacman), then you simply have to follow this procedure:

```
# pacman -Syu --ignore filesystem,bash
# pacman -S bash
# pacman -Su
```