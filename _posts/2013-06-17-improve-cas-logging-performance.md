---
layout: post
title: Improve CAS logging performance
categories:
- Administration
tags:
- CAS
- Log4j
- Performance
comments: []
---

[Jasig CAS](http://www.jasig.org/cas) uses [Log4j](http://logging.apache.org/log4j/1.2/) to fulfill its logging needs.

The default configuration does not make use of Log4j buffering capabilities, generating a lot of I/O requests on a busy server.

The configuration is stored in the file `cas-server-webapp/src/main/webapp/WEB-INF/classes/log4j.xml`. It uses a [RollingFileAppender](http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/RollingFileAppender.html) by default.

In order to enable buffering, one simply has to define the following boolean attribute: [BufferedIO](http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/FileAppender.html#bufferedIO).
The default buffer size is 8k. It can be customized using the [BufferSize](http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/FileAppender.html#bufferSize) attribute.

This is what it look like, based on CAS 3.5.2 default configuration:

```xml
<appender name="cas"></appender>

<param name="File" value="cas.log"> <param name="MaxFileSize" value="512KB"> <param name="MaxBackupIndex" value="3"><layout><param name="ConversionPattern" value="%d %p [%c] - %m%n"></layout><param name="BufferedIO" value="TRUE"> <param name="BufferSize" value="32K">
```

As usual when using buffering, be aware that you might loose data, in case of a crash. So you have to carefully consider whether the trade-off is suitable for your deployment. If you need both performance and security, you might be interested in upgrading your storage unit.