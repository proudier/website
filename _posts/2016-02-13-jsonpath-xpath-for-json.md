---
layout: post
title:  "Navigate JSON content with ease in JavaScript (aka XPath for JSON)"
tags:
- Dev
- JSON
- XPath
---

If your familiar with XML files, you’ve probably heard of/used [XPath](https://en.wikipedia.org/wiki/XPath) to select nodes from a XML document without implementing a custom parser. Did you know there was a similar tool for JSON, called JSONPath? This post shows how to get you started with JSONPath.

A good yet concise presentation is available on [Stefan Goessner’s blog](http://goessner.net/articles/JsonPath/). It offers an introduction to JSONPath, defines the syntax and comes with many examples. A JavaScript implementation is also available but it seems unmaintained.

Subbu Allamaraju forked this implementation to modernize/improve it. It seems actively maintained and is available [on GitHub](https://github.com/s3u/JSONPath). Examples are available at [the test files](https://github.com/s3u/JSONPath/blob/master/test/test.examples.js).

To test your queries, an online JSONPath evaluator is always a convenient tool. I find [jsonpath.com](http://jsonpath.com/) to be the best. You can paste your JSON content and your JSONPath expression and it will immediately show you the matching content.

Edit: link is dead ~~There is an interesting alternative to JSONPath: [json:select()](http://jsonselect.org/), CSS-like selectors for JSON. I never took the time to play with it but it could be worth a shot.~~
