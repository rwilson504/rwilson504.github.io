---
layout: post
title: 'SSIS Speed: DefaultBufferMaxRows '
date: '2013-10-22T16:04:00.001-04:00'
author: Rick Wilson
tags:
- SQL
- SSIS
modified_time: '2013-10-22T16:06:44.714-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5486250972125098811
blogger_orig_url: https://www.richardawilson.com/2013/10/ssis-speed-defaultbuffermaxrows.html
---

SSIS can sometimes take a long time to load.  Try messing witht he DefaultBufferMaxRows setting in the package.  In a first attempt on one table changing the setting from 10,000 (the default) to 1,000 saved me about 15 minutes off my run time.

Thanks to Jamie Thomson for posting this info: [http://consultingblogs.emc.com/jamiethomson/archive/2007/12/18/SSIS_3A00_-A-performance-tuning-success-story.aspx](http://consultingblogs.emc.com/jamiethomson/archive/2007/12/18/SSIS_3A00_-A-performance-tuning-success-story.aspx)

