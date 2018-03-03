---
layout: post
title: 'iostat: How %util is computed?'
categories:
- Administration
tags:
- Linux
- Storage
- Performance
comments: []
---
I was wondering what %util precisely meant. Once again, [StackOverflow](http://stackoverflow.com/) came to the rescue! Here is a summary.

Basically, **%util is the ratio of time spent doing I/Os to the total elapsed time**.

The kernel keeps track of how many request left a device has to perform. From this measurement, the kernel is able to compute how much time the device had something to do, which is not the same as how long it is going to take.

This information are accessible from userspace via the 9th and the 10th fields of [/proc/diskstats](http://www.kernel.org/doc/Documentation/iostats.txt):

> Field  9 -- # of I/Os currently in progress […]
> Incremented as requests are given to appropriate struct request_queue and decremented as they finish.
>
> Field 10 -- # of milliseconds spent doing I/Os
> This field increases so long as field 9 is nonzero.

The elapsed time is based on the CPU time and is computed using data from `/proc/stat` according to the formula:
`cpu time = (user time + system time + idle time + iowait) / number of CPU`

Now you should be able to understand ioctl's man page:

> %util: Percentage  of  CPU  time during which I/O requests were issued to the device (bandwidth utilization for the device).

[StackOverflow thread](http://stackoverflow.com/questions/4458183/how-the-util-of-iostat-is-computed)
