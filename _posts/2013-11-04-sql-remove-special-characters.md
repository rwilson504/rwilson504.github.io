---
layout: post
title: SQL - Remove Special Characters
date: '2013-11-04T18:29:00.001-05:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2013-11-04T19:25:31.468-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8308194263269342023
blogger_orig_url: https://www.richardawilson.com/2013/11/sql-remove-special-characters.html
---


Removes all special characters from an input string.

    USE MIGRATION_DB
    SET ANSI_NULLS ON
    GO
    SET QUOTED_IDENTIFIER ON
    GO
    IF OBJECT_ID (N'dbo.RemoveSpecialChars', N'FN') ISNOTNULL
    DROPFUNCTION dbo.RemoveSpecialChars;
    GO
    CREATEFUNCTION dbo.RemoveSpecialChars 
    ( @InputString VARCHAR(max) 
    )
    RETURNSVARCHAR(8000)  BEGIN
    IF @InputString ISNULLRETURNNULL
    
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
    ENDIF LEN(@OutputString) = 0  RETURNNULL
    RETURN @OutputString
    END
    GO

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

