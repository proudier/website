---
layout: post
title: HTTPS with Tomcat in 2 minutes
categories:
- Administration
tags:
- Tomcat
- SSL
comments: []
---

Two minutes, really!

First, generate the certificate. Alias `tomcat` is used as the label to later identify this certificate. The certificate will be stored in the file `/opt/jks_store`.

```
keytool -keystore /opt/jks_store -genkeypair -alias tomcat -keyalg RSA -keysize 4096 -validity 99999
```

If you are still using Tomcat6, enter the same password for the `keystore password` and `key password`. Tomcat 6 does not support the case where they are different.

Now, add a new connector for HTTPS to Tomcat’s `conf/server.conf`:

```xml
<Connector
        port="443"
        protocol="org.apache.coyote.http11.Http11NioProtocol"
        SSLEnabled="true"
        scheme="https"
        secure="true"
        keystoreFile="/opt/jks_keystore"
        keystorePass="$PASSWORD"
        keyAlias="tomcat"
/>
```


Don’t forget to replace `$PASSWORD` by the one you entered in keytool. Then restart Tomcat. You're done!

Consider configuring your firewalls if you are using port-based filtering.

Technically, the call to keytool has created a new keystore, a public key, the associated private key; both wrapped in a self-signed certificate, which is saved in the keystore.

Note: the `genkeypair` command was called `genkey` in earlier releases of keytool.

If you want to use a different value for `key password` and `keystore password`, you have to add the `keyPass` attribute to the connector element and specify the value givent for `key password`. Works with Tomcat 7+.

Further reading:

*   [Tomcat SSL HowTo](http://tomcat.apache.org/tomcat-7.0-doc/ssl-howto.html)
*   [Tomcat ref. doc on HTTP connector](http://tomcat.apache.org/tomcat-7.0-doc/config/http.html)
*   [Keytool ref. page](http://docs.oracle.com/javase/7/docs/technotes/tools/solaris/keytool.html)