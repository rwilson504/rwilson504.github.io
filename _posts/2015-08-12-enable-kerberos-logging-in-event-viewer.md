---
layout: post
title: Enable Kerberos Logging in Event Viewer
date: '2015-08-12T13:49:00.001-04:00'
author: Rick Wilson
tags:
- Kerberos
modified_time: '2015-08-12T13:49:49.609-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-264173332250936601
blogger_orig_url: https://www.richardawilson.com/2015/08/enable-kerberos-logging-in-event-viewer.html
---


1. Open the Registry Editor (regedit.exe)
2. Navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters
3. Add a new **DWORD** Value called “**LogLevel**” set the value to **1**
4. The logging should start without any reboot

After you have completed your testing delete the LogLevel key reboot the server to ensure you stop logging.

