---
layout: post
title: "#mysql50#lost+found"
categories:
- Tips &amp; tricks
tags:
- ExtFS
- MySQL
comments:
- id: 128107
  content: "Ce conseil est affreusement contraire &agrave; FHS !! Selon la Bible http://www.pathname.com/fhs/pub/fhs-2.3.html#MNTMOUNTPOINTFORATEMPORARILYMOUNT\r\n\"The
    content of this directory is a local issue and should not affect the manner in
    which any program is run.\"\r\n&Agrave; moins de faire des bases de donn&eacute;es
    temporaires, ne vaudrait-il pas mettre tout cela dans /var/lib/mysql/data\r\navec
    /var/lib/mysql comme point de montage ?\r\n\r\nMerci quand m&ecirc;me d'avoir
    r&eacute;pondu &agrave; ma requ&ecirc;te google :-)"
---

Vous installâtes MySQL et le configurâtes rigoureusement. Vous déplaçâtes même le tablespace sur une partition dédiée, pour des raisons de performance et de maintenance. Vous démarriez alors le service, rempli par le sentiment du travail bien fait. Par professionnalisme, vous vérifiâtes les logs; et là horreur!

```
120710 10:14:40 [ERROR] Invalid (old?) table or database name 'lost+found'
```

“Mais what the f¤#k?!” vous exclamâtes vous! A force d’observation, vous découvrîtes un autre symptôme: la présence d’une base de donnée `#mysql50#lost+found`

```sql
SHOW DATABASES;
+---------------------+
| Database            |
+---------------------+
| information_schema  |
| #mysql50#lost+found |
| mysql               |
| performance_schema  |
+---------------------+
4 rows in set (0.00 sec)
 ```

C'est pas très joli tout ça et ça peut faire planter les scripts de sauvegarde écrit un peu trop vite…

Dans un élan de logique primitive, vous essayâtes de supprimer la base de données:
```sql
DROP DATABASE '#mysql50#lost+found';
ERROR 1008 (HY000): Can't drop database '#mysql50#lost+found'; database doesn't exist
```

Vous comprîtes bien vite l’origine de cette base de donnée: la présence du dossier lost+found sous le point de montage de votre partition. Avouez-le, l’idée de supprimer le dossier `lost+found` vous a même traversé l’esprit. Mais non, ça, c’était trop mal!

`lost+found` étant une caractéristique de l’extFS, il était toujours possible de changer de système de fichier; mais il vous semblât que ce fusse un peu extrême comme solution, d’autant plus que le choix du FS était le résultat d’une étude.

Vous vous dîtes alors qu’une petite recherche Google s’imposait. Ainsi, vous découvrîtes que le bug est connu de la communauté: [ticket #22615](http://bugs.mysql.com/bug.php?id=22615); et qu’il est même déjà résolu: à partir de la 5.6.3, avec le paramètre [ignore-db-dir](http://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_ignore-db-dir). Malheureusement, vous n’aviez pas la liberté de monter en version...

En conséquence, une seule solution s’offrait à vous: déplacer le tablespace vers un sous-dossier de la partition et reconfigurer votre MySQL avec l'option [datadir](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_datadir).