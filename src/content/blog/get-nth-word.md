---
title: "SQL - Get Nth Word"
description: "Need to find the Nth word in a sentence, try this function."
pubDate: 2013-11-04
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/11/get-nth-word.html
---

Need to find the Nth word in a sentence, try this function.  

```
USE MIGRATION_DB  
GO  
IF OBJECT_ID (N'dbo.GetNthWord', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.GetNthWord;  
GO  
SET QUOTED_IDENTIFIER ON  
GO  
CREATE FUNCTION dbo.GetNthWord  
  (  
  @string varchar(max),  
  @n int  
  )  
  RETURNS varchar(max) AS  
  BEGIN  
  DECLARE   
  @xml xml,  
  @s nvarchar(max),  
  @wd varchar(100)  
    
  set @xml = '<root><record>' + REPLACE(@string, ' ','</record><record>') +  
    '</record></root>';  
      
    With rs(id, word) AS  
    (  
    select ROW_NUMBER ()over( order by (select 1))id , * from(  
    select   
    t.value('.','varchar(150)') as [items]  
    from @xml.nodes('//root/record') as a(t)) data  
    where len([items]) > 0  
    )  
      
    select @wd=word from rs where id=@n  
    return(@wd)      
  END
```

  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }
