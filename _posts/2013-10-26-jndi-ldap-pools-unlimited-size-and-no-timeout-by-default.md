---
layout: post
title: 'JNDI LDAP pools: unlimited size and no timeout by default'
categories:
- Administration
tags:
- Java
- LDAP
- Liferay
- JNDI
comments: []
---

Using the default settings might put your servers' stability at risk, in case of a sudden and important peak-load.

JavaSE offers pooling of the LDAP connection since version 1.4.1, via the JNDI API. A [tutorial](http://docs.oracle.com/javase/jndi/tutorial/ldap/connect/pool.html) is available from Oracle's website.

Though some more advanced alternatives have emerged since, such as [Spring LDAP](http://www.springsource.org/ldap), which is based on [Commons Pool](http://commons.apache.org/proper/commons-pool/) ([ref.](http://static.springsource.org/spring-ldap/docs/1.3.x/reference/html/introduction.html#ldap.pool)), some applications, such as [Liferay](http://www.liferay.com),  still use the JNDI pooling mechanism.

On the overall, it does the job nicely. But there are two things everybody using it should know: using the default settings…

- there is **no maximum size to the pool**:

> com.sun.jndi.ldap.connect.pool.maxsize [...] the maximum number of connections per connection identity that can be maintained concurrently. Default: no maximum size.

- the connections **never time out**:

> com.sun.jndi.ldap.connect.pool.timeout [...] the number of milliseconds that an idle connection may remain in the pool without being closed and removed from the pool. Default: no timeout.

[source](http://docs.oracle.com/javase/jndi/tutorial/ldap/connect/config.html)

In case of a sudden peak-load on your application and in order to fulfill the requests concurrently, the pool is going to open many connections to the LDAP server. It can lead to the exhaustion of a critical resource on your LDAP (CPU, RAM, disc I/O, …) and prevents the LDAP from answering in time, thus freezing your app.

Moreover, as there is no timeout, once a connection is opened, it is never removed from the pool. Consequently, the resources might never be released on your LDAP server and your application might never recover. In this case, you can either kill the connections from the LDAP or restart your JVM, which would destroy the pool and close the connections.

Solution: add the following parameters when starting the JVM:

```
-Dcom.sun.jndi.ldap.connect.pool.maxsize=125
-Dcom.sun.jndi.ldap.connect.pool.timeout=300000
```