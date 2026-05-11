---
title: "Enable Kerberos Logging in Event Viewer"
description: "1. Open the Registry Editor (regedit.exe) 2. Navigate to HKEY\\LOCAL\\MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\Kerberos\\Parameters 3. Add a new DWORD Value called “LogLevel” set the value to 1 4.…"
pubDate: 2015-08-12
category: power-apps
tags:
  - "kerberos"
draft: false
originalBloggerUrl: /2015/08/enable-kerberos-logging-in-event-viewer.html
---

1. Open the Registry Editor (regedit.exe)
2. Navigate to HKEY\_LOCAL\_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters
3. Add a new **DWORD** Value called “**LogLevel**” set the value to **1**
4. The logging should start without any reboot

After you have completed your testing delete the LogLevel key reboot the server to ensure you stop logging.
