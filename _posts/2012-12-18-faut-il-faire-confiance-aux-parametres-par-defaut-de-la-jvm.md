---
layout: post
title: Faut-il faire confiance aux param&egrave;tres par d&eacute;faut de la JVM?
categories:
- Development
tags:
- Java
- JVM
comments: []
---

D'après [cet article de Nikita Salnikov Tarnovski](http://plumbr.eu/blog/should-you-trust-the-default-settings-in-jvm), la réponse est non.

Et pour cause, il a fait l'expérience d'une JVM qui sélectionnait le `SerialGC` sur un OS 64bits!

> The GC used by our JVM was in fact Serial GC. Which, if you have carefully followed our post should not be the case – 64-bit Linux machines should always be considered server-class machines and the GC used should be Parallel GC.

Dans son cas, il semble que le nombre de CPU a pris le pas sur la plateforme.

Bonne lecture!