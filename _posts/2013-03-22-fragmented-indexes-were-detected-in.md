---
layout: post
title: Fragmented indexes were detected in the Microsoft Dynamics CRM database
date: '2013-03-22T22:21:00.006-04:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2014-03-24T13:49:26.297-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1113569209079391365
blogger_orig_url: https://www.richardawilson.com/2013/03/fragmented-indexes-were-detected-in.html
---

Re-index your CRM Org database if you receive this error.

`USE ````Org_MSCRM```
`GO```
`EXEC ````sp_MSforeachtable ````@command1````=````"print '?' DBCC DBREINDEX ('?', ' ', 80)"```
`GO```
`EXEC ````sp_updatestats```
`GO ```````````````

