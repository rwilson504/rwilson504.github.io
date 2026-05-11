---
title: "Page Not Found 404 After Install or Uninstalling CRM 2011 UR"
description: "After uninstalling an update rollup and rebooting the machine CRM starting coming back with a 404 Page Not Found error when trying to access the site."
pubDate: 2013-02-01
category: power-apps
tags:
  - "crm-2011"
  - "error"
  - "update-rollup"
draft: false
originalBloggerUrl: /2013/02/page-not-found-404-after-install-or.html
---

After uninstalling an update rollup and rebooting the machine CRM starting coming back with a 404 Page Not Found error when trying to access the site.  
  
The trace log showed the following error:  
Crm Exception: Message: Invalid license. PidGen.dll cannot be loaded from this path C:\Program Files\Microsoft Dynamics CRM\Server\bin\PidGen.dll, ErrorCode: –2147167677  
  
This machine was set to NOT automatically install windows updates.  To solve my issue run windows update and get all the current updates other than any new CRM Update Rollups you do not wish to install.  After the windows update and another reboot everything was working again.
