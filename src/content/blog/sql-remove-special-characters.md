---
title: "SQL - Remove Special Characters"
description: "Removes all special characters from an input string."
pubDate: 2013-11-04
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/11/sql-remove-special-characters.html
---

Removes all special characters from an input string.

```
USE MIGRATION_DB  
SET ANSI_NULLS ON  
GO  
SET QUOTED_IDENTIFIER ON  
GO  
IF OBJECT_ID (N'dbo.RemoveSpecialChars', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.RemoveSpecialChars;  
GO  
CREATE FUNCTION dbo.RemoveSpecialChars   
( @InputString VARCHAR(max)   
)  
RETURNS VARCHAR(8000)  BEGIN      
IF @InputString IS NULL RETURN NULL      
  
DECLARE @OutputString VARCHAR(max)      
SET @OutputString = ''      
DECLARE @l INT      
SET @l = LEN(@InputString)      
DECLARE @p INT      
SET @p = 1  
    WHILE @p <= @l  
        BEGIN              
        DECLARE @c INT              
        SET @c = ASCII(SUBSTRING(@InputString, @p, 1))              
        IF @c BETWEEN 48 AND 57  
                OR @c BETWEEN 65 AND 90  
                OR @c BETWEEN 97 AND 122  
                  --OR @c = 32                  
                  SET @OutputString = @OutputString + CHAR(@c)              
                  SET @p = @p + 1  
        END    IF LEN(@OutputString) = 0  RETURN NULL      
RETURN @OutputString  
END  
GO
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }
