---
layout: post
title: How to move swap back to RAM
tags:
- Linux
---

This post explains how to move the data stored on the swap device/file back to RAM.

Let's consider the following situation:

```bash
shell> free -m
             total       used       free     shared    buffers     cached
Mem:          7872       5938       1934          0        194        367
-/+ buffers/cache:       5376       2496
Swap:         3070       1318       1752
```
Here we have 1318M of data in the swap and 1934M of unused memory so moving back the data to RAM won't affect the cached data.


```bash
shell> swapoff -a
shell> swapon -a
shell> free -m
             total       used       free     shared    buffers     cached
Mem:          7872       7122        750          0        194        370
-/+ buffers/cache:       6557       1315
Swap:         3070          0       3070
```
The amount of swap space used is now 0.

If you think your kernel is swapping too aggressively, you should look at the [vm.swappiness](https://www.kernel.org/doc/Documentation/sysctl/vm.txt) kernel parameter. The [Ubuntu FAQ](https://help.ubuntu.com/community/SwapFaq#What_is_swappiness_and_how_do_I_change_it.3F) has an interesting piece about it.




First, check you have enough free memory. This is very important because without the necessary amout of free memory, some running applications may encounter the wrath of the [OOM Killer](http://linux-mm.org/OOM_Killer).



The amount of free RAM (1934M) is bigger than the concent of the swap space (1318) therefore the system will be able to swap out without triggering the OOM Killer and without trashing the cache.
It is also correct to consider the amount free RAM “-/+ buffers/cache” but, in this case, you have to evaluate the impact of lowering the available cache on your system, before continuing.

Now here is the trick: disabling the swap space will force the kernel to move the content back to RAM. It can take some time, depending on the amount of data to read from the swap device. Once it is done, turn the swap back on.




