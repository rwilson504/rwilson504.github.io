---
title: "Filtering Down the CrmSvcUtil"
description: "Most of the time i use late bound but there are times when early bound makes things easier. I needed to limit the size of the file so filtering down on just the entities i use was needed.…"
pubDate: 2018-03-08
updatedDate: 2018-03-15
category: power-apps
tags:
  - "c"
  - "crm"
draft: false
originalBloggerUrl: /2018/03/filtering-down-crmsvcutil.html
---

Most of the time i use late bound but there are times when early bound makes things easier.  I needed to limit the size of the file so filtering down on just the entities i use was needed.  Luckily Eric Pool create a quick way to do this already.  
  
http://erikpool.blogspot.com/2011/03/filtering-generated-entities-with.html  
  
The only think i would add to this is that I am using it with CRM 2015 so I had to make sure that my VS project was set to .NET 4.5.2
