---
layout: post
title: CRM Asynchronous Process Failure Settings
date: '2009-09-09T12:27:00.001-04:00'
author: Rick Wilson
tags:
- CRM 4.0
modified_time: '2011-02-21T16:13:01.882-05:00'
thumbnail: http://4.bp.blogspot.com/_mr9BzRLR2GQ/SqfVHkfIXPI/AAAAAAAAEgk/vWYirkU3uSE/s72-c/DefaultSettings.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7779936299756113586
blogger_orig_url: https://www.richardawilson.com/2009/09/crm-asynchronous-process-failure.html
---

One of the things I do when setting up a CRM 4.0 server is modify the Recovery settings of the Asynch process. This process tends to have a lot of difficulty recovering if it loses the connection to SQL.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/SqfVHkfIXPI/AAAAAAAAEgk/vWYirkU3uSE/s400/DefaultSettings.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/SqfVHkfIXPI/AAAAAAAAEgk/vWYirkU3uSE/s1600-h/DefaultSettings.png)Figure 1

By default the service is set to Restart only on the first failure and the restart time is set to occur after 1 minute (Figure 1). The problem is that it typicaly takes a SQL server longer than one minute to reboot. In order to better ensure that you don't need to restart the service manually I typicaly change the **Second failure** to **Restart the Service** and set the **Restart service after** setting to something between **3 and 5 minutes** (Figure 2).

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/SqfWKljCv2I/AAAAAAAAEgs/mUgprK9i204/s400/RestartServices.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/SqfWKljCv2I/AAAAAAAAEgs/mUgprK9i204/s1600-h/RestartServices.png)Figure 2

By tweeking these setting you can help reduce the strain on your support folks by not always having to do a manual restart of this service every time they want to install patches on the SQL box.  Also your users won't be sitting there wondering why their workflows are not kicking off.

