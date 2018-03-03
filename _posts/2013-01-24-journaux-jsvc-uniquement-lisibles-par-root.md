---
layout: post
title: 'Journaux JSVC uniquement lisibles par root '
categories:
- Administration
tags:
- Linux
- JSVC
- Tomcat
comments: []
---

A l’aide des options `-outfile` et `-errfile`, [JSVC](http://commons.apache.org/daemon/jsvc.html) peut rediriger les sorties standards vers des fichiers. Les fichiers sont alors créés avec le mode 600, quel que soit le [`umask`](http://fr.wikipedia.org/wiki/Umask) en vigueur.

Pour l’équipe de JSVC, l’insensibilité au `umask` n’est pas un bogue mais une fonctionnalité ([source](https://issues.apache.org/jira/browse/DAEMON-178))

Comme JSVC est souvent lancé par `root`, les journaux se retrouvent lisibles uniquement par `root`, ce qui constitue une protection contre la fuite d'information par le biais des journaux.

Cette protection peut être très intéressante pour un serveur de production. Mais dans le cas d’un serveur de développement, elle est contre-productive. En effet, on a bien envie de laisser un accès en lecture aux développeurs afin qu'ils voient leur code s'exécuter!

Il n’existe pas d’option permettant de changer le mode des fichiers créés.
Cependant, il est possible de changer la valeur au moment de la compilation.

```bash
./configure --with-java=/usr/java
make EXTRA_CFLAGS="-DJSVC_UMASK=022"
```

Les fichiers seront alors créés avec le mode 644.