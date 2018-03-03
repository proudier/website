---
layout: post
title: Liferay Wiki breaks accented characters
categories:
- Administration
tags:
- Liferay
- Tomcat
- i18n
comments:
- id: 8
  content: Youhou ! Je suis une star !
- id: 9
  content: "&ldquo;Cobaye&rdquo; me semblerait plus juste ;-)"
---

Liferay 6.1 GA1 is unable to properly display special characters (such as accented characters) inside wikis on Tomcat 6 + Java 6.

How to reproduce: edit a wiki and insert the name "Jérôme" then publish. The page is refreshed but instead of "Jérôme", "JÃ©rÃ´me" is shown.
Notice how it looks like UTF-8 being interpreted as ISO-8859-1.

An inspection of the database led me to notice that the content is already corrupted in the database. Therefore the problem does not lie in the rendering of the wiki but in the editing.

Using [HttpFox](http://code.google.com/p/httpfox/), I checked whether the content is properly sent to the server. It is, using a POST request (so far, so good).

Googling something like "UTF8 corruption POST Tomcat", I found the following in [Tomcat's FAQ](http://wiki.apache.org/tomcat/FAQ/CharacterEncoding#Q3):

> POST requests should specify the encoding of the parameters and values they send. Since many clients fail to set an explicit encoding, the default is used (ISO-8859-1).

It turns out Tomcat was the one messing with the UTF-8 content; by interpreting it as ISO-8859-1.

The solution is to use a `javax.servlet.Filter` which will take care of the conversion.
The Spring dependency `spring-web.jar`, embedded in Liferay's `WEB-INF/lib`, provides such a filter.
The class is `org.springframework.web.filter.CharacterEncodingFilter`

Edit Liferay's `web.xml` file and add the following:

```xml
<!-- Scroll to the declaration block of filters -->
<filter>
    <filter-name>characterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
        <param-name>force-encoding</param-name>
        <param-value>true</param-value>
    </init-param>
</filter>
<!-- Other filters -->
<filter-mapping>
    <filter-name>characterEncodingFilter</filter-name>
    <url-pattern>*</url-pattern>
</filter-mapping>
```

Now on, the content of POST request is passed to Liferay as UTF-8 text and accented characters are displayed as expected in wikis.

Note 1: the filter-mapping declaration should be the first of your list. Order is important. See [Tomcat's FAQ](http://wiki.apache.org/tomcat/FAQ/CharacterEncoding#Q3) for an explanation.

Note 2: I could not reproduce this issue using the non-blocking Java connector (`Http11NioProtocol`) nor the AJP original blocking Java connector (`JkCoyoteHandler`). Did not try using any APR connector.