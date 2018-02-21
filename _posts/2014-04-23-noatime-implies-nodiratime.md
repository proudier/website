---
layout: post
title: noatime implies nodiratime
tags:
- Linux
- Filesystems
---

I was wondering whether the _noatime_ mount option implied the _nodiratime_ option; turned out it’s true.

Though mount’s man page (section 8) does not mention anything on the subject:

> noatime: Access timestamps are not updated when a file is read
> nodiratime: Do not update directory inode access times on this filesystem

Mount’s man page (section 2) is clearer:

> MS_NOATIME: Do not update access times for (*all types of*) files on this file system
> MS_NODIRATIME: Do not update access times for directories on this file system

As a directory is a file, setting noatime implies nodiratime consequently. 

This reasoning is confirmed in a [mail](http://permalink.gmane.org/gmane.linux.kernel/565213) by [Andrew Morton](http://en.wikipedia.org/wiki/Andrew_Morton_(computer_programmer)) on Aug 5, 2007:

> noatime is a superset of nodiratime, btw