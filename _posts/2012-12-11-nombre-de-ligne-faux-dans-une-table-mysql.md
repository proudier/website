---
layout: post
title: Nombre de ligne faux dans une table MySQL
categories:
- Tips &amp; tricks
tags:
- HeidiSQL
- MySQL
comments: []
---

Petite surprise tout à l'heure, alors que j'utilisais [HeidiSQL](http://www.heidisql.com/): le nombre d'enregistrement dans la table changeait à chaque fois que j'appuyais sur refresh. Mais pas de quelques enregistrements, non, non! A coup de 250 000 enregistrements, sur une table de 1.4 millions.

Je cru d'abord à un bug de HeidiSQL; j'ai vraiment une confiance limitée dans ce genre d'outil  . Mais un collègue me fit remarquer que ça venait de MySQL.

> The number of rows. Some storage engines, such as `MyISAM`, store the exact count. For other storage engines, such as `InnoDB`, this value is an approximation, and may vary from the actual value by as much as 40 to 50%.

Il faut utiliser `SELECT COUNT(*)` pour avoir la vraie valeur.