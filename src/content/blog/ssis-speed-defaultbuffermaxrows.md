---
title: "SSIS Speed: DefaultBufferMaxRows "
description: "SSIS can sometimes take a long time to load. Try messing witht he DefaultBufferMaxRows setting in the package.…"
pubDate: 2013-10-22
category: power-apps
tags:
  - "sql"
  - "ssis"
draft: false
originalBloggerUrl: /2013/10/ssis-speed-defaultbuffermaxrows.html
---

SSIS can sometimes take a long time to load.  Try messing witht he DefaultBufferMaxRows setting in the package.  In a first attempt on one table changing the setting from 10,000 (the default) to 1,000 saved me about 15 minutes off my run time.  
  
Thanks to Jamie Thomson for posting this info: <http://consultingblogs.emc.com/jamiethomson/archive/2007/12/18/SSIS_3A00_-A-performance-tuning-success-story.aspx>
