---
layout: post
title: Mass deleting spam comments in WordPress
categories:
- Tips &amp; tricks
tags:
- SQL
- WordPress
comments: []
---

Since I got this new job back in January, I took little time to post nor even maintain this blog. So this morning, when I decided it was high time to do so, I discovered no less than 110420 spam comments!

Needless to say, the Admin interface couldn't cope with such a volume. The only attempt to trash those comments ended-up in a timeout (nothing surprising). So I decided to look directly into the database. The schema being very clean, I could easily identify and remove the spam comments from the database.

Connect to the database server (MariaDB in my case) and select the database used by WordPress (WORDPRESS here):

```
SQL> USE WORPRESS;
Database changed
```

Then run the following query:

```
SQL> DELETE FROM wp_comments WHERE comment_approved='spam';
Query OK, 110240 rows affected (19.85 sec)

SQL> DELETE FROM wp_commentmeta WHERE comment_id NOT IN (SELECT comment_ID FROM wp_comments);
Query OK, 110240 rows affected (19.85 sec)
```

Quick and simple, right?!
