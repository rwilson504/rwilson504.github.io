---
layout: post
title: Calculate Date of Birth in SSRS
date: '2014-02-28T17:18:00.002-05:00'
author: Rick Wilson
tags:
- Reports
- SSRS
modified_time: '2014-02-28T17:22:31.563-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6343157200846834654
blogger_orig_url: https://www.richardawilson.com/2014/02/calculate-date-of-birth-in-ssrs.html
---

You can utilize this code in an Expression to find the Date of Birth.  
    
    =IIF(IsNothing(Fields!dateofbirth.Value), "",
    IIF( ((Month(Now) - Month(Fields!dateofbirth.Value)) < 0) 
    OR ((Month(Now) - Month(Fields!dateofbirth.Value)) = 0 
    AND (Day(Now) - Day(Fields!dateofbirth.Value)) < 0), 
    (Year(Now) - Year(Fields!dateofbirth.Value)) - 1,
    (Year(Now) - Year(Fields!dateofbirth.Value))
    ))
    

