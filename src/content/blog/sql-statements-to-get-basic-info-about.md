---
title: "SQL Statements to Get Basic Info About Tables"
description: "Here are two scripts I found that will help you generate basic info about your database. This data can be useful when beginning the level of effort for a data migration. NUMBER OF COLUMNS PER TABLE"
pubDate: 2013-05-21
updatedDate: 2013-11-04
heroImage: "/heroes/sql-statements-to-get-basic-info-about.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2013/05/sql-statements-to-get-basic-info-about.html
---

Here are two scripts I found that will help you generate basic info about your database.  This data can be useful when beginning the level of effort for a data migration.  
**NUMBER OF COLUMNS PER TABLE**  

```
SELECT TABLE_NAME, COUNT(*) AS COLUMN_COUNT  
  FROM INFORMATION_SCHEMA.COLUMNS   
  GROUP BY TABLE_NAME
```

  
   
.csharpcode, .csharpcode pre<br />{<br /> font-size: small;<br /> color: black;<br /> font-family: consolas, "Courier New", courier, monospace;<br /> background-color: #ffffff;<br /> /\*white-space: pre;\*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br /> background-color: #f4f4f4;<br /> width: 100%;<br /> margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />  
  
**RECORD COUNT FOR TABLE**  

```
SELECT sc.name +'.'+ ta.name TableName  
,SUM(pa.rows) RowCnt  
FROM sys.tables ta  
INNER JOIN sys.partitions pa  
ON pa.OBJECT_ID = ta.OBJECT_ID  
INNER JOIN sys.schemas sc  
ON ta.schema_id = sc.schema_id  
WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)  
GROUP BY sc.name,ta.name  
ORDER BY SUM(pa.rows) DESC
```

  
.csharpcode, .csharpcode pre<br />{<br /> font-size: small;<br /> color: black;<br /> font-family: consolas, "Courier New", courier, monospace;<br /> background-color: #ffffff;<br /> /\*white-space: pre;\*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br /> background-color: #f4f4f4;<br /> width: 100%;<br /> margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />  
  
[![image](/images/sql-statements-to-get-basic-info-about/01-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjgrF9AOzRHBZIHwGt7GG76VR4-KQenKuAsv4RnH4AnIAVYVYTki8uzylbuAs4dH_EEPOgKeLEgijWCaxt7L29UANAeWm9hatJWP2brzFG3-wwtxpqm_maLIJSKOAYIJ26k7LKYEcfXpGs/s1600-h/image%25255B5%25255D.png)  
  
**FOREIGN KEY CONSTRAINTS (Relationships)**  

```
SELECT TABLE_NAME, CONSTRAINT_NAME  
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS   
  WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'  
  ORDER BY TABLE_NAME
```

  
[![image](/images/sql-statements-to-get-basic-info-about/02-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi7Wydo8abF2OM8D4VglmK7MgKVL2dth1fY2r1cGzES2thqaxFKctL81NsPouUHk1XF8OjTot5UwouYQia-XZbgFaUL32CWdg5SX9O-vlJ7ekqZ-7ZizSf1XRY6Wu2AVj3aDFfFReNPx94/s1600-h/image%25255B3%25255D.png)  
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }
