---
layout: post
title: Conflits MySQL-server et mysql-libs sur RHEL 6
categories:
- Tips &amp; tricks
tags:
- Linux
- MySQL
- RedHat
- RHEL
comments: []
---

L'installation de MySQL 5.5.25 &eacute;choue sur RedHat Enterprise Linux (RHEL) lorsque l'on utilise le RPM fourni par MySQL. Il y a un conflit entre le contenu du RPM et le package mysql-libs qui est install&eacute; pour r&eacute;soudre une d&eacute;pendance induite par postfix.

La raison est que le RPM fourni par MySQL ne respecte pas les conventions de RedHat (source: r&eacute;ponse de Joerg Bruehe dans le [ticket #63085](http://bugs.mysql.com/bug.php?id=63085)

Une solution consiste à forcer l'installation à l'aide de `--force`.

```
rpm --force MySQL-server-5.5.25-1.el6.x86_64.rpm
```

Ce n'est pas propre mais ça fonctionne. J'ai installé trois serveurs avec cette méthode (dont 2 de prod) et ils tournent sans incident depuis plusieurs mois.

Fichier rpm: `MySQL-server-5.5.25-1.el6.x86_64.rpm`

Erreur complète:

```
file /usr/share/mysql/charsets/cp1251.xml from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/czech/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/danish/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/dutch/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/english/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/estonian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/french/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/german/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/greek/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/hungarian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/italian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/japanese/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/korean/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/norwegian-ny/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/norwegian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/polish/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/portuguese/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/romanian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/russian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/serbian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/slovak/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/spanish/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/swedish/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
file /usr/share/mysql/ukrainian/errmsg.sys from install of MySQL-server-5.5.25-1.el6.x86_64 conflicts with file from package mysql-libs-5.1.52-1.el6_0.1.x86_64
```

Dépendance envers mysql-libs:

```
shell> repoquery --installed --whatrequires mysql-libs
mysql-libs-0:5.1.52-1.el6_0.1.x86_64
mysql-libs-0:5.1.52-1.el6_0.1.x86_64
postfix-2:2.6.6-2.2.el6_1.x86_64
```

