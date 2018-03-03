---
layout: post
title: Eclipse plante au lancement
categories:
- Tips &amp; tricks
tags:
- Eclipse
comments:
- id: 6
  content: Ou installez Visual Studio ! :P
- id: 7
  content: Bof... http://ironworksblog.typepad.com/.a/6a012875706f1b970c0133efbb0406970b-800wi
---

Si votre Eclipse plante au démarrage, juste après la sélection du workspace, sachez qu'il y a un moyen simple de contourner le problème.

# Description du problème

Eclipse MDT Indigo et Helios SR2 sur OpenSUSE 11.4 x86_64 KDE 4.6; juste après la sélection du workspace, Eclipse se ferme et on peut lire sur la console:

```
./eclipse
# A fatal error has been detected by the Java Runtime Environment:
#
# SIGSEGV (0xb) at pc=0x00007f97d231a960, pid=6455, tid=140290119399168
#
# JRE version: 6.0_26-b03
# Java VM: Java HotSpot(TM) 64-Bit Server VM (20.1-b02 mixed mode linux-amd64 compressed oops)
# Problematic frame:
# C [libgobject-2.0.so.0+0x17960] __float128+0x20
```

# Solution

Il existe un moyen simple de contourner le problème. Il consiste à ne pas utiliser la fenêtre de parcours des dossiers. Si vous saisissez le chemin manuellement et que vous validez, Eclipe continuera son chargement normalement.
