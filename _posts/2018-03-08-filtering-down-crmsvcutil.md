---
layout: post
title: Filtering Down the CrmSvcUtil
date: '2018-03-08T16:12:00.004-05:00'
author: Rick Wilson
tags:
- C#
- CRM
modified_time: '2018-03-15T14:00:08.916-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-9003095715651535255
blogger_orig_url: https://www.richardawilson.com/2018/03/filtering-down-crmsvcutil.html
---

Most of the time i use late bound but there are times when early bound makes things easier.  I needed to limit the size of the file so filtering down on just the entities i use was needed.  Luckily Eric Pool create a quick way to do this already.

http://erikpool.blogspot.com/2011/03/filtering-generated-entities-with.html

The only think i would add to this is that I am using it with CRM 2015 so I had to make sure that my VS project was set to .NET 4.5.2

