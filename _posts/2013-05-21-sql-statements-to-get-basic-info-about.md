---
layout: post
title: SQL Statements to Get Basic Info About Tables
date: '2013-05-21T12:40:00.001-04:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2013-11-04T19:27:27.721-05:00'
thumbnail: http://lh4.ggpht.com/-kxGb2jtIxG0/UZujkEXEnJI/AAAAAAAAHTA/5oU83cXALmo/s72-c/image_thumb.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1487417879084735389
blogger_orig_url: https://www.richardawilson.com/2013/05/sql-statements-to-get-basic-info-about.html
---

Here are two scripts I found that will help you generate basic info about your database.  This data can be useful when beginning the level of effort for a data migration.
**NUMBER OF COLUMNS PER TABLE**

    SELECT TABLE_NAME, COUNT(*) AS COLUMN_COUNT
    FROM INFORMATION_SCHEMA.COLUMNS 
    GROUPBY TABLE_NAME

[![image](http://lh4.ggpht.com/-kxGb2jtIxG0/UZujkEXEnJI/AAAAAAAAHTA/5oU83cXALmo/image_thumb.png?imgmax=800)](http://lh6.ggpht.com/-YTEDZ01duqc/UZujj_IHgBI/AAAAAAAAHS8/_lk7H957_e4/s1600-h/image%25255B2%25255D.png)
.csharpcode, .csharpcode pre<br />{<br />	font-size: small;<br />	color: black;<br />	font-family: consolas, "Courier New", courier, monospace;<br />	background-color: #ffffff;<br />	/*white-space: pre;*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br />	background-color: #f4f4f4;<br />	width: 100%;<br />	margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />

**RECORD COUNT FOR TABLE**

    SELECT sc.name +'.'+ ta.name TableName
    ,SUM(pa.rows) RowCnt
    FROM sys.tables ta
    INNERJOIN sys.partitions pa
    ON pa.OBJECT_ID = ta.OBJECT_ID
    INNERJOIN sys.schemas sc
    ON ta.schema_id = sc.schema_id
    WHERE ta.is_ms_shipped = 0 AND pa.index_id IN (1,0)
    GROUPBY sc.name,ta.name
    ORDERBYSUM(pa.rows) DESC

.csharpcode, .csharpcode pre<br />{<br />	font-size: small;<br />	color: black;<br />	font-family: consolas, "Courier New", courier, monospace;<br />	background-color: #ffffff;<br />	/*white-space: pre;*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br />	background-color: #f4f4f4;<br />	width: 100%;<br />	margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />

[![image](http://lh6.ggpht.com/-VGARfD2zqgw/UZujlFQWSmI/AAAAAAAAHTQ/Sh4Hlg7E-yU/image_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.ggpht.com/-zu8U3-6Pzlo/UZujkhN5FaI/AAAAAAAAHTI/oWHhKR0Gk_g/s1600-h/image%25255B5%25255D.png)

**FOREIGN KEY CONSTRAINTS (Relationships)**

    SELECT TABLE_NAME, CONSTRAINT_NAME
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
    ORDERBY TABLE_NAME

[![image](http://lh6.ggpht.com/-FunxKSwNiBM/UZuqsG9GlII/AAAAAAAAHTs/fWafoZW8r-g/image_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.ggpht.com/-JCUtKK2E8_c/UZuqrpKVOoI/AAAAAAAAHTk/3S3sOVLEemI/s1600-h/image%25255B3%25255D.png)
.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

