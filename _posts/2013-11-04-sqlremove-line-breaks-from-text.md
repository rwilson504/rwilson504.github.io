---
layout: post
title: SQL - Remove Line Breaks From Text
date: '2013-11-04T18:23:00.001-05:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2013-11-04T19:26:39.755-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-521681224947739359
blogger_orig_url: https://www.richardawilson.com/2013/11/sqlremove-line-breaks-from-text.html
---

This function will attempt to remove line breaks from text in SQL.

    USE MIGRATION_DB
    GO
    IF OBJECT_ID (N'dbo.RemoveLineBreak', N'FN') ISNOTNULL
    DROPFUNCTION dbo.RemoveLineBreak;
    GO
    CREATEFUNCTION dbo.RemoveLineBreak
        (@TEXT    VARCHAR(MAX))
    RETURNSVARCHAR(MAX)
    AS
    BEGIN
    
    DECLARE @fixedTEXT VARCHAR(MAX) = @TEXT
    
    SET @fixedTEXT = REPLACE(REPLACE(REPLACE(REPLACE(@TEXT, CHAR(10), ''), CHAR(13), ''), '\r', ' '), '\n', ' ')
    
    RETURN    @fixedTEXT
    END
    GO

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

