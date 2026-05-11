---
title: "ADFS 2.0 Config Debug Tracing"
description: "1.…"
pubDate: 2012-02-28
updatedDate: 2015-08-12
category: power-apps
tags:
  - "adfs-2"
draft: false
originalBloggerUrl: /2012/02/adfs-config-debug-tracing.html
---

1. Run CMD as Administrator- wevtutil sl "AD FS 2.0 Tracing/Debug" /l:5- Open Event Viewer.- To open Event Viewer, click **Start**, point to **Programs**, point to **Administrative Tools**, and then click **Event Viewer**.- On the **View** menu, click **Show Analytic and Debug Logs**.- In the console tree, expand **Applications and Services Logs**, expand **AD FS 2.0 Tracing**, and then click **Debug**.- In the **Actions** pane, click **Enable Log**.- Tracing for AD FS 2.0 is now enabled.- Restart the **AD FS 2.0 Windows Service**.

<http://technet.microsoft.com/en-us/library/adfs2-troubleshooting-configuring-computers(v=WS.10).aspx>
