---
layout: post
title: Paginate results within MySQL command line tool
categories:
- Tips &amp; tricks
tags:
- MySQL
comments: []
---

Did you know it is possible to use a standard pager, such as `less`, within the MySQL command line tool?
Using the pager, you can scroll throught the result of your queries more easilly.

To set the pager:

```
mysql> pager less
PAGER set to 'less'
```

Testing:

```
mysql> use mysql
mysql> show tables
+---------------------------+
| Tables_in_mysql           |
+---------------------------+
| columns_priv              |
| db                        |
| event                     |
| func                      |
:

_Reminder_: press the 'q' key to escape from the pager.
```

To disable the pager:

```
mysql> nopager
PAGER set to stdout
```

These features are only available on GNU/Linux [Reference](http://dev.mysql.com/doc/refman/5.5/en/mysql-commands.html).
