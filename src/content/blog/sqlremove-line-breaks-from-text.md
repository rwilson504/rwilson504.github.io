---
title: "SQL - Remove Line Breaks From Text"
description: "This function will attempt to remove line breaks from text in SQL."
pubDate: 2013-11-04
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/11/sqlremove-line-breaks-from-text.html
---

This function will attempt to remove line breaks from text in SQL.  

```
USE MIGRATION_DB  
GO  
IF OBJECT_ID (N'dbo.RemoveLineBreak', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.RemoveLineBreak;  
GO  
CREATE FUNCTION dbo.RemoveLineBreak  
    (@TEXT    VARCHAR(MAX))  
    RETURNS    VARCHAR(MAX)  
AS  
BEGIN  
  
DECLARE @fixedTEXT VARCHAR(MAX) = @TEXT  
  
SET @fixedTEXT = REPLACE(REPLACE(REPLACE(REPLACE(@TEXT, CHAR(10), ''), CHAR(13), ''), '\r', ' '), '\n', ' ')  
  
RETURN    @fixedTEXT  
END  
GO
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }
