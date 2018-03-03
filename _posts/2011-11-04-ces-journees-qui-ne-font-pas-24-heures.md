---
layout: post
title: Ces journéees qui ne font pas 24 heures
categories:
- Development
tags:
- JavaScript
- PHP
- Time
comments:
- id: 132000
  content: "Merci pour cet article (ancien maintenant !).\r\nVous proposez des fonctions
    pour js et pour PHP... et en MySQL par exemple ?? \r\nCar  \r\n\r\nADDDATE( CURDATE(),
    INTERVAL 1 DAY ) \r\n\r\najoute 24h , mais cela ne fonctionne pas les jours de
    changements d'heure ..."
---

Profitons du récent passage à l'heure d'hiver pour rappeler que toutes les journées ne font pas 24 heures!

En effet, entre le dimanche 30 octobre minuit et le lundi 31 minuit, il ne s'est pas écoulé 24 mais 25 heures! Voici le décompte, en prenant en compte la règle du changement d'heure: ("à 3h du matin il sera 2h")

*   de 00h00 à 01h59: 2h
*   de 02h00 à 2h59: 1h - premier 'passage'
*   de 02h00 à 2h59: 1h - second 'passage'
*   de 03h00 à 23h59: 22h

=> Total: 25 heures

L'une des conséquences est qu'il ne suffit pas d'ajouter 24 heures à une date pour obtenir la date du jour suivant. Ceci est particulièrement important lorsque l'on travail avec des timestamps Unix, car il est tellement simple et plus rapide (à coder et à exécuter) de faire un `timestamp += 24*60*60` !

Or le paragraphe précédent vous montre bien que cette pratique va induire un comportement erratique dans votre application.

Il faut donc systématiquement faire appel à une bibliothèque de haut niveau qui offre une méthode add() prenant en compte les changements d'heure.

Exemple en PHP, avec [DateTime](http://www.php.net/manual/en/class.datetime.php "DateTime"):

```php
$date = new Datetime('@'.$timestamp);
$date->add(new DateInterval('P1D'));
$newTimestamp = $date->getTimestamp();
```

Exemple en JavaScript, avec [date.js](http://www.datejs.com "DateJS"): 

```javascript
var date = new Date(timestamp*1000); // JS travail en nombre de millisecondes
date.add({ days: 1 })
```

Pour mémoire:

*   L'heure légale en France est, durant l'hiver, "l'Heure normale d'Europe centrale", en anglais: "Central European Time", notée CET, qui correspond à une avance d'une heure par rapport à temps de Greenwich. En été, il s'agit de "l'Heure d'été d'Europe centrale" ou "Central European Summer Time" (CEST), qui correspond à une avance de deux heures.
*   Le passage à l'heure d'hiver à lieu le dernier dimanche d'octobre. A 3h du matin, il sera 2h.: on 'gagne' une heure.
*   Le passage à l'heure d'été à lieu le dernier dimanche de mars. A 2h du matin, il sera 3h: on 'perd' une heure.
*   Le principe de changement d'heure se dit "daylight saving time" en anglais.