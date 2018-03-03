---
layout: post
title: New index not improving performance with 389DS
categories:
- Administration
tags:
- LDAP
- Performance
- 389DS
comments: []
---

If you are wondering why the brand new index you've just created on your 389DS / RedHat DirectoryServer does not improve performance then read on!

This post assume you have already checked that the index actually exists.  It can be done by checking if there is `db4` file with the name of the indexed attribute under the `$instanceName/db/$dbName/` folder.

With the default settings, the DS will stop using the index if more than 4000 entries belong to it. In this case, it will fall back to an "unindexed search" mode, and will read all the entries from the database.

From "[§9.1.3 - Overview of the Searching Algorithm](https://access.redhat.com/site/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Managing_Indexes.html#About_Indexes-Overview_of_the_Searching_Algorithm)":

> The Directory Server examines the search filter to see what indexes apply, and it attempts to load the list of entry IDs from each index that satisfies the filter. The ID lists are combined based on whether the filter used AND or OR joins.
> If the list of entry IDs is larger than the configured ID list scan limit or if there is no index, then the Directory Server searches every entry in the database. This is an unindexed search.

The server-level parameter for "ID list scan limit" is called `nsslapd-idlistscanlimit`. You'll find it under `cn=config,cn=ldbm database,cn=plugins,cn=config`. Its default value is 4000\. [Source](https://access.redhat.com/site/documentation//en-US/Red_Hat_Directory_Server/9.0/html/Configuration_Command_and_File_Reference/Database_Plug_in_Attributes.html#Database_Attributes_under_cnconfig_cnldbm_database_cnplugins_cnconfig) (browse to "§4.4.1.21\. nsslapd-idlistscanlimit").

You can also set on a per-user basis with `nsIDListScanLimit`.

Though the doc states that "it is advisable to keep the default value", tweaking it can bring important and desirable performance improvements. Real life example achieved this morning: searching a 55000 entries OU from a 180MiB database:

*   With nsslapd-idlistscanlimit=4000: 721 entries returned in 14241ms.
*   With nsslapd-idlistscanlimit=10000: 721 entries returned in 118ms.

=> Performance gain: **99,17%** (!!)

That's why I allow myself changing this setting. But in order to prevent any side-effect, I only set it on a per-user basis.