---
title: "Fragmented indexes were detected in the Microsoft Dynamics CRM database"
description: "Re-index your CRM Org database if you receive this error."
pubDate: 2013-03-22
updatedDate: 2014-03-24
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/03/fragmented-indexes-were-detected-in.html
---

Re-index your CRM Org database if you receive this error.  
  
`USE``Org_MSCRM`  
`GO`  
`EXEC``sp_MSforeachtable``@command1``=``"print '?' DBCC DBREINDEX ('?', ' ', 80)"`  
`GO`  
`EXEC``sp_updatestats`  
`GO`
