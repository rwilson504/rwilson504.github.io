---
layout: post
title: Get Solutions Containing Web Resource
date: '2016-08-04T09:36:00.000-04:00'
author: Rick Wilson
tags: 
modified_time: '2016-08-04T11:06:36.791-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3360377952633453528
blogger_orig_url: https://www.richardawilson.com/2016/08/get-solutions-containing-web-resource.html
---

Snipit to determine which solutions contain a web resource.  
    
    SELECT TOP 1000 
     S.FriendlyName, 
     s.UniqueName, 
     WR.DisplayName, 
     WR.Name     
      FROM [Default_MSCRM].[dbo].[SolutionComponentBase] SC
      LEFT JOIN Default_MSCRM.dbo.SolutionBase S ON S.SolutionId = SC.SolutionId
      INNER JOIN Default_MSCRM.dbo.WebResourceBase WR ON WR.WebResourceId = SC.ObjectId
      WHERE WR.Name LIKE '%classeventscoresheet.htm%'
    

