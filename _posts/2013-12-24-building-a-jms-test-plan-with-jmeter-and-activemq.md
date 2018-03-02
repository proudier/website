---
layout: post
title: Building a JMS test plan with JMeter and ActiveMQ
categories:
- Tips &amp; tricks
tags:
- JMS
- ActiveMQ
- JMeter
comments:
- id: 129429
  content: Thank you sir!
- id: 132239
  content: Thank you! It worked for me.
- id: 132773
  content: "Had to leave a comment to say that this fixed a problem I was having for
    days. And this short blog post is the only resource I found with this solution.\r\n\r\nThanks"
- id: 133177
  content: thanks for the solution, it worked
---
JMeter supports JMS test plans almost out of the box. Only a simple operation is needed before using the dedicated samplers.

JMeter supports the JMS API but does not bundle any implementation ([source](http://jmeter.apache.org/usermanual/get-started.html )). We are going to use [Apache ActiveMQ](http://activemq.apache.org/) as an implementation and make it available to JMeter.

Download the activemq-all-x.y.z.jar artefact, from say [mvnrepository.com](http://mvnrepository.com/artifact/org.apache.activemq/activemq-all ); [direct link to v5.9.0](http://repo1.maven.org/maven2/org/apache/activemq/activemq-all/5.9.0/activemq-all-5.9.0.jar ).

Move the downloaded JAR to the `JMETER_HOME/lib` folder, for this is the right place for "utility jars", according to [the doc](http://jmeter.apache.org/usermanual/get-started.html#classpath ).

If JMeter is already started, you have to restart it before going on.

Now, you can follow [the official tutorial](http://jmeter.apache.org/usermanual/build-jms-topic-test-plan.html) without getting errors such as:

```
Response message: javax.naming.NamingException: javax.naming.NoInitialContextException: Cannot instantiate class: org.apache.activemq.jndi.ActiveMQInitialContextFactory
[Root exception is java.lang.ClassNotFoundException: org.apache.activemq.jndi.ActiveMQInitialContextFactory]
```
