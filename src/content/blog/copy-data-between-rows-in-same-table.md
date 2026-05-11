---
title: "Copy data between rows in the same table"
description: "So here was my issue. I needed to copy some from one row in a table to another row. I tried using the SQL Server Managment Studio but it does not allow you to copy and past binary information."
pubDate: 2009-09-01
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2009/09/copy-data-between-rows-in-same-table.html
---

So here was my issue. I needed to copy some <binary data> from one row in a table to another row. I tried using the SQL Server Managment Studio but it does not allow you to copy and past binary information. Instead I used a UPDATE... FROM SQL statement.  
  
Here is an example:  
  

```
UPDATE LoadTestRun
SET LoadTest = b. LoadTest
FROM LoadTestRun, LoadTestRun b
WHERE LoadTestRun.LoadTestRunID = 4 AND b.LoadTestRunID = 1
```

  
Here is the generic format:  
  

```
UPDATE table
SET field = b.field
FROM table, table b
WHERE table.PirmaryKeyID = "Copy To ID" AND b.PrimaryKeyID = "Copy From ID"
```
