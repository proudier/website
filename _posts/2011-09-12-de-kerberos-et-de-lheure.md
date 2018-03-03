---
layout: post
title: De Kerberos et de l'heure
categories:
- Administration
tags:
- ActiveDirectory
- Kerberos
- MacOS
comments: []
---
Note à moi-même: pour que les opérations Kerberos se déroulent comme voulu, il faut que les horloges du serveur et du client n'affichent pas plus de 5 minutes d'écart.

J'ai rencontré le problème suivant fin août: du jour au lendemain, un Mac n'arrivait plus à ouvrir de session auprès du contrôleur de domaine Active Directory. Pourtant, dans les logs du serveur, je voyais bien apparaitre la demande de connexion. Et pire que ça, elle était belle et bien acceptée par le serveur ("Ouverture de session réseau réussie"). Alors que du côté du mac, je n'avais le droit qu'à l'effet "secousse" de la fenêtre d'identification, signifiant une erreur.

Après identification avec un compte local à la machine, j'accède aux logs et tombe sur des dizaines de ligne telles que:
```
DirectoryService[15] Active Directory: Kerberos Time Skew Too Large. Check computer date and time!
```

En effet, le client avait 6 minutes de retard sur le serveur.
