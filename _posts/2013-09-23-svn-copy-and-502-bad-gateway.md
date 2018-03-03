---
layout: post
title: SVN, COPY and '502 Bad Gateway'
categories:
- Development
tags:
- HTTPd
- SVN
comments: []
---

I recently moved a SVN server behind a reverse proxy. Check-outing and committing new or edited files worked fine; but moving a resource did not:

```
svn commit -m "blabla"
# (edited)
Adding (bin) cas-server-webapp/src/main/resources-ppr/cas.keytab
svn: E175002: Commit failed (details follow):
svn: E175002: COPY request on '/restricted/svn/cas-server_merge/.keytab' failed: 502 Bad Gateway`
```

The connection to the reverse-proxy is made over HTTPS. The connection from the reverse-proxy to the SVN is over HTTP. I'm not using the SVN protocol but the DAV extensions of the HTTP protocol. Both the reserve-proxy and the SVN are instances of Apache HTTPd.

A quick solution is to add the following piece of configuration to the SVN instance of HTTPd:
```
RequestHeader edit Destination ^https: http: early
```

Don't forget to load mod_headers. It's done by default on RHEL (RedHat)
```
LoadModule headers_module modules/mod_headers.so
```

[That blog story](http://www.dscentral.in/2013/04/04/502-bad-gateway-svn-copy-reverse-proxy/) goes into more details.