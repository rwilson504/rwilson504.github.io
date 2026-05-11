---
title: "Get Times for CRM Import Jobs"
description: "This script will give you the times for CRM import jobs that have been run on your system."
pubDate: 2013-10-24
updatedDate: 2015-01-06
category: power-apps
tags:
  - "crm-2011"
  - "import"
  - "sql"
draft: false
originalBloggerUrl: /2013/10/get-times-for-crm-import-jobs.html
---

This script will give you the times for CRM import jobs that have been run on your system.  
  

```
--Shows all import records and the amount of time they took  
SELECT [Name], [StartedOn], [CompletedOn],  
DATEDIFF(MINUTE, [StartedOn], [CompletedOn]) AS [Diff In Minutes]  
FROM [Default_MSCRM].[dbo].[AsyncOperationBase]   
WHERE OperationType IN (3,4,5) --OperationType 3,4,5 are the ones which relate to imports
```

  
  

```
--Shows total number of minutes for all imports  
SELECT SUM(DATEDIFF(MINUTE, [StartedOn], [CompletedOn])) AS [Total Diff In Minutes]  
FROM [Default_MSCRM].[dbo].[AsyncOperationBase]   
WHERE OperationType IN (3,4,5)
```

  
  

```
--Shows total number of hours for all imports  
SELECT SUM(DATEDIFF(MINUTE, [StartedOn], [CompletedOn])) /60 AS [Total Diff In Hours]  
FROM [Default_MSCRM].[dbo].[AsyncOperationBase]   
WHERE OperationType IN (3,4,5)
```
