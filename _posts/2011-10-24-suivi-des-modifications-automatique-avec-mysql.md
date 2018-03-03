---
layout: post
title: Suivi des modifications automatique avec MySQL
categories:
- Mod&eacute;lisation
tags:
- MySQL
- SQL
- Timestamp
comments: []
---
J'ai découvert, par hasard, un moyen très simple de mémoriser la date de création et de dernière modification d'un enregistrement. Le tout, sans alourdir la requête SQL, ni en ayant recours à du PL/SQL.

Ces informations sont très utiles pour nettoyer les bases de donnée de dev et parfois de test. En effet, les base de dev sont souvent remplies de données incohérentes, créés par des versions boggées d'une application.

Pour avoir la date de création, ajoutez une colonne:
```sql
date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

Pour avoir la date de dernière modification:
```sql
date_derniere_modif TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP
```

Notez qu'il n'est pas possible d'avoir deux colonnes utilisant `CURRENT_TIMESTAMP`, il est donc intéressant d'enregistrer les date de création et date de dernière modification dans la même colonne:

```sql
date_edition TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

Pour rappel, un `TIMESTAMP` représente le nombre de seconde depuis le 1er janvier 1970 à 00h00 UTC. N'oubliez pas que les `TIMESTAMP` sont convertis lorsqu'ils sont lus depuis la BDD.

Pour plus d'informations, voir [la page de manuel sur les TIMESTAMP](http://dev.mysql.com/doc/refman/5.1/en/timestamp.html).