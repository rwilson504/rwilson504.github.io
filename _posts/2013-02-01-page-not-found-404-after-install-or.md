---
layout: post
title: Page Not Found 404 After Install or Uninstalling CRM 2011 UR
date: '2013-02-01T11:26:00.001-05:00'
author: Rick Wilson
tags:
- CRM 2011
- Error
- Update Rollup
modified_time: '2013-02-01T12:35:55.216-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1365540614522849217
blogger_orig_url: https://www.richardawilson.com/2013/02/page-not-found-404-after-install-or.html
---

After uninstalling an update rollup and rebooting the machine CRM starting coming back with a 404 Page Not Found error when trying to access the site.

The trace log showed the following error:
Crm Exception: Message: Invalid license. PidGen.dll cannot be loaded from this path C:\Program Files\Microsoft Dynamics CRM\Server\bin\PidGen.dll, ErrorCode: –2147167677

This machine was set to NOT automatically install windows updates.  To solve my issue run windows update and get all the current updates other than any new CRM Update Rollups you do not wish to install.  After the windows update and another reboot everything was working again.  

