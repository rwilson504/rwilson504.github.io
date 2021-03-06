---
layout: post
title: Hibernation Mode With Windows Server 2008 and Hyper-V
date: '2011-02-18T08:52:00.002-05:00'
author: Rick Wilson
tags:
- Windows Server 2008R2
- Hyper-V
modified_time: '2011-02-21T16:14:33.381-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5569062047990687918
blogger_orig_url: https://www.richardawilson.com/2011/02/hibernation-mode-with-windows-server.html
---

On occasion I need to run Hyper-V for testing on my laptop.  Most of the time though I would love to have the power management function such as hibernation which is disabled by Hyper-V.  In order to get around this I have updated the following registry key which disables Hyper-V on startup.

    ```[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\hvboot]"Start"=dword:00000003
    ```

Now when I want to run Hyper-V I just click on a .bat file on my desktop which contains the following commands. 

    ```net start hvboot 
    net start vmms
    net start nvspwmi
    net start vhdsvc
    PAUSE
    ```

Now that you have enabled Hyper-V the power management features will no longer be available until you reboot the system.  This isn't exactly a fix but it's a great workaround.

