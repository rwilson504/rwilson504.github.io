---
layout: post
title: SQL - Remove Non-Alpha Characters
date: '2013-11-04T18:27:00.001-05:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2013-11-04T19:26:13.766-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3306489782548004794
blogger_orig_url: https://www.richardawilson.com/2013/11/sql-remove-non-alpha-characters.html
---

This function will remove all non-alphanumeric characters.

    USE MIGRATION_DB
    SET ANSI_NULLS ON
    GO
    SET QUOTED_IDENTIFIER ON
    GO
    IF OBJECT_ID (N'dbo.RemoveNonAlphaCharacters', N'FN') IS NOT NULL
        DROP FUNCTION dbo.RemoveNonAlphaCharacters;
    GO
    Create Function [dbo].[RemoveNonAlphaCharacters](@Temp VarChar(max))
    Returns VarChar(max)
    AS
    BEGIN
    
        DECLARE @KeepValues as varchar(50) = '%[^a-z]%'
        WHILE PatIndex(@KeepValues, @Temp) > 0
        SET @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')
    
        RETURN @Temp
    END
    GO

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: consolas, "Courier New", courier, monospace;background-color: #ffffff;/*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt {background-color: #f4f4f4;width: 100%;margin: 0em;}.csharpcode .lnum { color: #606060; }

