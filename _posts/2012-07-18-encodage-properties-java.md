---
layout: post
title: Encodage .properties Java
categories:
- Development
tags:
- Java
- Encoding
comments: []
---

Faut-il, encore en 2012, enregistrer les fichiers .properties en `ISO-8859-1`? En bref, la réponse est oui; car certaine méthode de la classe Properties ne supporte que cet encodage.

La [javadoc](http://docs.oracle.com/javase/6/docs/api/java/util/Properties.html) nous indique que les méthodes `load(InputStream)` / `store(OutputStream, String)` travaillent en `ISO-8859-1`:

> « The load(Reader) / store(Writer, String) methods load and store properties from and to a character based stream in a simple line-oriented format specified below. The load(InputStream) / store(OutputStream, String) methods work the same way as the load(Reader)/store(Writer, String) pair, except the input/output stream is encoded in ISO 8859-1 character encoding. »

Comme il est [pratiquement](http://fr.wiktionary.org/wiki/pratiquement) impossible de certifier qu'un programme ne fasse jamais appel à ces méthodes, les fichiers .properties se doivent d’être en `ISO-8859-1` ou alors on courre le risque que certaines String soient mal chargées.

Pour rappel, les caractères qui ne sont pas supportés par `ISO-8859-1` sont à remplacer par une séquence d’échappement Unicode composé de la façon suivante:

1.  un backslash ‘\’
2.  un caractère ‘u’
3.  un code hexadécimal représentant le caractère.

Par exemple, le symbole euro (€) s'écrira `\u20AC`. 

Une référence des codes Unicode est disponible [ici]( http://www.ssec.wisc.edu/~tomw/java/unicode.html). Mais on préférera surement utiliser l'outil [native2ascii](http://docs.oracle.com/javase/1.4.2/docs/tooldocs/windows/native2ascii.html).

La p’tite question en plus: `ISO-8859-1` ou 15, `CP1252`? La différence entre `ISO-8859-1` et `ISO-8859-15` sont assez minimes: 8 caractères. Cependant, il convient de noter que le symbole euro (€) est absent en 8859-1 alors qu’il est présent en 8859-15. Les différences entre 8859-1 et CP1252 sont plus importantes; en plus de l'euro, on notera la présence du caractère œ et du symbole ‰. En conclusion, un texte en 8859-15 ou en CP1252 sera globalement lisible, mais ne sera pas parfait.

Pour plus d'info, n'hésitez pas à lire les pages Wikipedia sur [ISO-8859-15](http://fr.wikipedia.org/wiki/ISO_8859-15) et [CP1252](http://fr.wikipedia.org/wiki/CP1252).

Sachez, que certains programmes s’autorisent quelques largesses. Liferay, par exemple, [indique](http://www.liferay.com/community/wiki/-/wiki/Main/Translating+Liferay+to+a+New+Language) que les fichiers .properties contenant les traductions doivent être en UTF-8:

> Dealing with non-ASCII characters (Version 6.x and later)
>
> Liferay's Language_(Language code).properties files are UTF-8 encoded - this is different from the Java standard, but is an important detail to get your deployment actually working. There's no more transformation required.

Ah! Soyez sympa: pour vos futurs développements, utilisez donc des properties stockées dans du XML. Ils sont en UTF-8 par défaut, eux!