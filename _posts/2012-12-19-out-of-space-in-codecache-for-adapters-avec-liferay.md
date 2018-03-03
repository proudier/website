---
layout: post
title: '"out of space in CodeCache for adapters" avec Liferay'
categories:
- Administration
tags:
- JVM
- Liferay
comments: []
---
Si vous rencontrez les exceptions `java.lang.VirtualMachineError: out of space in CodeCache for adapters` puis `Illegal constant pool index` avec Liferay, sachez qu'il suffit de d'ajouter le paramètre `-XX:ReservedCodeCacheSize=96m` au démarrage de la JVM pour régler le problème.

Voici le stack trace complet:
```
SEVERE: Servlet.service() for servlet PdfSingleServlet threw exception
java.lang.VirtualMachineError: out of space in CodeCache for adapters
at com.lowagie.text.pdf.PdfWriter.(Unknown Source)
at com.lowagie.text.pdf.PdfWriter.getInstance(Unknown Source)
at QaB.PdfSingleServlet.doGet(Unknown Source)
at javax.servlet.http.HttpServlet.service(HttpServlet.java:617)
at javax.servlet.http.HttpServlet.service(HttpServlet.java:717)
at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:290)
at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:206)
at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilterChain.doFilter(InvokerFilterChain.java:72)
at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilterChain.doFilter(InvokerFilterChain.java:116)
at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilter.doFilter(InvokerFilter.java:71)
at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:235)
at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:206)
at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:233)
at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:191)
at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:127)
at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:102)
at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:109)
at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:293)
at org.apache.jk.server.JkCoyoteHandler.invoke(JkCoyoteHandler.java:190)
at org.apache.jk.common.HandlerRequest.invoke(HandlerRequest.java:291)
at org.apache.jk.common.ChannelSocket.invoke(ChannelSocket.java:776)
at org.apache.jk.common.ChannelSocket.processConnection(ChannelSocket.java:705)
at org.apache.jk.common.ChannelSocket$SocketConnection.runIt(ChannelSocket.java:898)
at org.apache.tomcat.util.threads.ThreadPool$ControlRunnable.run(ThreadPool.java:690)
at java.lang.Thread.run(Thread.java:679)
```

Suite à cette exception, des erreurs "`Illegal constant pool index`" pullulaient dans les logs:

```
SEVERE: Servlet.service() for servlet PdfSingleServlet threw exception
java.lang.VerifyError: (class: com/lowagie/text/pdf/PdfContentByte, method: variableRectangle signature: (Lcom/lowagie/text/Rectangle;)V) Illegal constant pool index
at com.lowagie.text.pdf.PdfWriter.<init>(Unknown Source)
    at com.lowagie.text.pdf.PdfWriter.getInstance(Unknown Source)
    at QaB.PdfSingleServlet.doGet(Unknown Source)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:617)
    at javax.servlet.http.HttpServlet.service(HttpServlet.java:717)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:290)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:206)
    at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilterChain.doFilter(InvokerFilterChain.java:72)
    at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilterChain.doFilter(InvokerFilterChain.java:116)
    at com.liferay.portal.kernel.servlet.filters.invoker.InvokerFilter.doFilter(InvokerFilter.java:71)
    at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:235)
    at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:206)
    at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:233)
    at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:191)
    at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:127)
    at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:102)
    at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:109)
    at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:293)
    at org.apache.jk.server.JkCoyoteHandler.invoke(JkCoyoteHandler.java:190)
    at org.apache.jk.common.HandlerRequest.invoke(HandlerRequest.java:291)
    at org.apache.jk.common.ChannelSocket.invoke(ChannelSocket.java:776)
    at org.apache.jk.common.ChannelSocket.processConnection(ChannelSocket.java:705)
    at org.apache.jk.common.ChannelSocket$SocketConnection.runIt(ChannelSocket.java:898)
    at org.apache.tomcat.util.threads.ThreadPool$ControlRunnable.run(ThreadPool.java:690)
    at java.lang.Thread.run(Thread.java:679)
```

Pendant ce temps, les parties très utilisées du portail étaient normalement accessibles, aucun problème de performance. Par contre, toute requête concernant le reste se terminaient en HTTP 500.

L'erreur a eu lieu sur un Liferay 6.1.10 EE contenant un certain nombre de modifications "in-house". 239 porlets différentes sont déployées, donc les ~110 porlets officielles. Runtime OpenJDK 6.0_22-b22 sur CentOS 6.2.