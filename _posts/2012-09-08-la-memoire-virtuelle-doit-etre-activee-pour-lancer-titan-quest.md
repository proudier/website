---
layout: post
title: La m&eacute;moire virtuelle doit &ecirc;tre activ&eacute;e pour lancer Titan
  Quest
categories:
- Tips &amp; tricks
tags:
- TitanQuest
- Steam
comments: []
---
Problème: en lançant la démo de Titan Quest depuis Steam sur Windows 7 64bit, le message suivant apparait et le jeu ne se lance pas:

> "Fatal Error" > "La mémoire virtuelle doit être activée pour lancer Titan Quest."

Je suppose que par _mémoire virtuelle_, ils entendent _fichier d'échange_; voir [Wikipedia](http://fr.wikipedia.org/wiki/M%C3%A9moire_virtuelle)  pour ceux que le raccourci choque.
Après vérification, je confirme que le fichier d'échange est bien en place et est suffisement gros (8G en plus des 8G de RAM).

C'est parti pour une seance de Google...

Contrairement à ce qu'on peut lire dans les forums, ajouter la ligne `skipCompatibilityChecks = true` dans le fichier `C:Program Files (x86)\Steam\SteamApps\common\Titan Quest Demo\Settings\defaults.txt` ne régle pas le problème.

Par contre, il m'a suffit d'activer le mode de compatibilité `Windows XP (Service Pack 3)` sur l'exécutable
`C:Program Files (x86)\Steam\SteamApps\common\Titan Quest Demo\Titan Quest Demo.exe` pour que je puisse lancer le jeu avec succès.