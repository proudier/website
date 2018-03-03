---
layout: post
title: StringBuilder vs StringBuffer vs String.concat
categories:
- Development
tags:
- Java
comments: []
---
Je viens de lire un [article très intéressant](http://kaioa.com/node/59) comparant 3 méthodes pour construire des chaines de texte en Java.

Personnellement, je retiendrai que:

- `concat` est très lent devant les trois autres (22 secondes pour 65536 concaténation avec String.concat contre <0,24 secondes pour les deux autres).

- le compilateur transforme les expression comme
```java
System.out.println("x:"+x+" y:"+y);
```
en
```java
System.out.println((new StringBuilder()).append("x:").append(x).append(" y:").append(y).toString());
```
En conséquence, on n'utilisera pas l'opérateur + dans une boucle, car cela cause la création d'autant de StringBuilder que d'itération de la boucle.

-  le compilateur concatène automatiquement, à la compilation les expressions du genre
```java
String text=
"line 1n"+
"line 2n"+
"line 3";
```

- Enfin, on se souviendra que StringBuilder n'est pas synchronisé alors que StringBuffer l'est.
