---
title: "SQL - Generate Scripts to Drop Tables/Views"
description: "You can use the commands below to create SQL commands which will drop tables/views. the were clause can be used to limit which tables/views are included in the statement."
pubDate: 2013-11-04
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/11/sql-generate-scripts-to-drop-tablesviews.html
---

You can use the commands below to create SQL commands which will drop tables/views.  the were clause can be used to limit which tables/views are included in the statement.

Drop Tables

```
SELECT 'DROP TABLE [' + TABLE_NAME + ']'  
FROM INFORMATION_SCHEMA.TABLES  
WHERE TABLE_NAME NOT LIKE 'CRM%'   
AND TABLE_TYPE = 'BASE TABLE'
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }  
  

Drop Views

```
SELECT 'DROP VIEW [' + TABLE_NAME + ']'  
FROM INFORMATION_SCHEMA.VIEWS  
WHERE TABLE_NAME NOT LIKE 'CRM%'
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }
