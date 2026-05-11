---
title: "Deletion State Codes Fields Preventing Solution Import"
description: "If you have upgraded a CRM database from 4.0. to 2011 you may have some leftover fields that end in dsc.…"
pubDate: 2013-01-31
category: power-apps
tags:
  - "crm-2011"
  - "crm-4"
draft: false
originalBloggerUrl: /2013/01/deletion-state-codes-fields-preventing.html
---

If you have upgraded a CRM database from 4.0. to 2011 you may have some leftover fields that end in dsc.  These fields can later on come back to haunt you by showing up as missing components when import a solution into 2011. The fields will always end in “dsc” as you can see in the image below.  
[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgVUEKn4XHxMAlNA4nlw2zm7XaI1R8vsPkRx6zKN_59a32WUrBpNuTKDH0r6ANNsdjNIS7_AXxXSdNe0iElQK_pg2keeonEtpAIiv_XFmDT8BNIutk-p-pUV5xZwHPVFZb5SEvj7EflneU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjaasK7M3QkqNgNnhmvYmbtMP2ZKXMxp0C0KJ_jOmDQq0VxTIHZEkDIqiomCbL1cBBJ5Jd7v_yfhIYvPaAD2WzZeAoEjkpk6ICoAMZGUtTxQ9Gxv0MvSzW3zrqQMwJyOR4NT5i-BFlKvNs/s1600-h/image%25255B3%25255D.png)  
  
[John Hoven](http://hovenj.blogspot.com/2012/03/deletion-state-code-attribute-leftovers.html) has written a SQL script which will remove these attributes from the database.  After removing them re-export the solution and attempt the import again.  

*-- Delete the custom DSC attributes from the database.*

   
DELETE a   
*--select A.LogicalName*    
FROM   metadataschema.attribute a   
       INNER JOIN metadataschema.entity e   
         ON e.entityid = a.entityid   
WHERE  a.attributeof IS NOT NULL   
       AND a.attributetypeid = '00000000-0000-0000-00AA-110000000019'   
       AND a.logicalname LIKE '%dsc'   
       AND a.iscustomfield = 1   
*-- Delete the dsc attribute map columns*  
DELETE am   
*--select AM.\**    
FROM   dependencybase db   
       INNER JOIN dependencynodebase dnb   
         ON db.dependentcomponentnodeid = dnb.dependencynodeid   
       INNER JOIN attributemapbase am   
         ON am.attributemapid = dnb.objectid   
WHERE  db.requiredcomponentnodeid IN (SELECT dnb.dependencynodeid   
                                      FROM   dependencynodebase dnb   
                                             LEFT JOIN metadataschema.attribute   
                                                       a   
                                               ON dnb.objectid = a.attributeid   
                                      WHERE  dnb.componenttype = 2   
                                             AND a.logicalname IS NULL)   
*-- delete attribute map required dependencies on dsc columns*   
DELETE db   
FROM   dependencybase db   
       INNER JOIN dependencynodebase dnb   
         ON db.dependentcomponentnodeid = dnb.dependencynodeid   
WHERE  db.dependentcomponentnodeid IN (SELECT dnb.dependencynodeid   
                                       FROM   dependencynodebase dnb   
                                              LEFT JOIN metadataschema.attribute   
                                                        a   
                                                ON dnb.objectid = a.attributeid   
                                       WHERE  dnb.componenttype = 2   
                                              AND a.logicalname IS NULL)   
*-- Delete the attribute dependencies on dsc columns*   
DELETE db   
FROM   dependencybase db   
       INNER JOIN dependencynodebase dnb   
         ON db.dependentcomponentnodeid = dnb.dependencynodeid   
WHERE  db.requiredcomponentnodeid IN (SELECT dnb.dependencynodeid   
                                      FROM   dependencynodebase dnb   
                                             LEFT JOIN metadataschema.attribute   
                                                       a   
                                               ON dnb.objectid = a.attributeid   
                                      WHERE  dnb.componenttype = 2   
                                             AND a.logicalname IS NULL)   
*-- Delete the dependency nodes*   
DELETE dnb   
*-- select A.LogicalName*    
FROM   dependencynodebase dnb   
       LEFT JOIN metadataschema.attribute a   
         ON dnb.objectid = a.attributeid   
WHERE  dnb.componenttype = 2   
       AND a.logicalname IS NULL
