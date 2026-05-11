---
title: "CRM Asynchronous Process Failure Settings"
description: "One of the things I do when setting up a CRM 4.0 server is modify the Recovery settings of the Asynch process."
pubDate: 2009-09-09
updatedDate: 2011-02-21
heroImage: "/heroes/crm-asynchronous-process-failure.png"
category: power-apps
tags:
  - "crm-4"
draft: false
originalBloggerUrl: /2009/09/crm-asynchronous-process-failure.html
---

One of the things I do when setting up a CRM 4.0 server is modify the Recovery settings of the Asynch process. This process tends to have a lot of difficulty recovering if it loses the connection to SQL.  
  

Figure 1

  
  
By default the service is set to Restart only on the first failure and the restart time is set to occur after 1 minute (Figure 1). The problem is that it typicaly takes a SQL server longer than one minute to reboot. In order to better ensure that you don't need to restart the service manually I typicaly change the **Second failure** to **Restart the Service** and set the **Restart service after** setting to something between **3 and 5 minutes** (Figure 2).  
  
  

[![](/images/crm-asynchronous-process-failure/01-RestartServices.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgX5k4rmNvmJYkULvfVZqSt9jDibpRZMdUlifG-40YKYuGKvRJXc9Alovd-efZ1xHAXVrpfNBCA32f0Ufnt9T1Cu-r3KLvgcSS-F5sOv3zHpFyyFJEDrQ8Mz6-Vjz_XBwGnz4XKHWq6_Do/s1600-h/RestartServices.png)Figure 2

  
  
By tweeking these setting you can help reduce the strain on your support folks by not always having to do a manual restart of this service every time they want to install patches on the SQL box.  Also your users won't be sitting there wondering why their workflows are not kicking off.
