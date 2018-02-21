---
layout: post
title: Using a different separator than '/' with sed
tags:
- Linux
- sed
---

You probably know the _s_ "substitute" command that sed offers. But did you know you that other character could be used as separator?

```bash
shell> echo "Hello World" | sed "s/World/Neo/"
Hello Neo
```
```bash
shell> echo "Hello World" | sed "s_World_Neo_"
Hello Neo
```

That’s right, ‘_’ can be used instead of ‘/’. In this case, ‘/’ become a normal character and doesn’t have to be escaped anymore.

It is very useful when working with URLs:

```bash
shell> echo "http://hostA/pathA/" | sed "s_hostA/pathA_hostB/pathB_"
http://hostB/pathB/
```

Even the space character (‘ ’) is suitable; just don’t forget the one at the end of the command.

```bash
shell> echo "Hello World" | sed "s World Neo "
Hello Neo
```

The  [official documentation](http://www.gnu.org/software/sed/manual/sed.html#The-_0022s_0022-Command) formalises this behavior:

> The / characters may be uniformly replaced by any other single character within any given s command.
> The / character (or whatever other character is used in its stead) can appear in the regexp or replacement only if it is preceded by a \ character.