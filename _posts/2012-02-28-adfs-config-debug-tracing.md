---
layout: post
title: ADFS 2.0 Config Debug Tracing
date: '2012-02-28T13:07:00.002-05:00'
author: Rick Wilson
tags:
- ADFS 2.0
modified_time: '2015-08-12T13:04:25.785-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1861306912671513172
blogger_orig_url: https://www.richardawilson.com/2012/02/adfs-config-debug-tracing.html
---


1. Run CMD as Administrator 
2. wevtutil sl "AD FS 2.0 Tracing/Debug" /l:5 
3. Open Event Viewer. 
4. To open Event Viewer, click **Start**, point to **Programs**, point to **Administrative Tools**, and then click **Event Viewer**. 
5. On the **View** menu, click **Show Analytic and Debug Logs**. 
6. In the console tree, expand **Applications and Services Logs**, expand **AD FS 2.0 Tracing**, and then click **Debug**. 
7. In the **Actions** pane, click **Enable Log**. 
8. Tracing for AD FS 2.0 is now enabled. 
9. Restart the **AD FS 2.0 Windows Service**.

[http://technet.microsoft.com/en-us/library/adfs2-troubleshooting-configuring-computers(v=WS.10).aspx](http://technet.microsoft.com/en-us/library/adfs2-troubleshooting-configuring-computers(v=WS.10).aspx)

