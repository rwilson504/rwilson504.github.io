---
title: "Get Solutions Containing Web Resource"
description: "Snipit to determine which solutions contain a web resource."
pubDate: 2016-08-04
category: misc
tags:
  - "web-resource"
draft: false
originalBloggerUrl: /2016/08/get-solutions-containing-web-resource.html
---

Snipit to determine which solutions contain a web resource.

```
SELECT TOP 1000 
 S.FriendlyName, 
 s.UniqueName, 
 WR.DisplayName, 
 WR.Name     
  FROM [Default_MSCRM].[dbo].[SolutionComponentBase] SC
  LEFT JOIN Default_MSCRM.dbo.SolutionBase S ON S.SolutionId = SC.SolutionId
  INNER JOIN Default_MSCRM.dbo.WebResourceBase WR ON WR.WebResourceId = SC.ObjectId
  WHERE WR.Name LIKE '%classeventscoresheet.htm%'
```
