---
layout: post
title: Microsoft Forefront Client Install Wihtout Centralized Server
date: '2010-07-01T18:19:00.004-04:00'
author: Rick Wilson
tags:
- Forefront
- Windows Server 2008R2
- Windows Server 2008
modified_time: '2011-05-16T10:14:26.665-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2402444649535077308
blogger_orig_url: https://www.richardawilson.com/2010/07/microsoft-forefront-client-install.html
---

I was recently looking around for an Anti-Virus solution for Windows Server 2008.  I had tried downloading Microsoft Forefront Client before but when I ran the setup it wanted me to install a ton of server components... so where is the client part of all this?  What I wanted was a simple anti-virus software that uses windows update to get all my new virus definitions.

To do this just run the install the client from the cd using the /NOMOM switch.  This install the client but uses Windows Update to get all the virus definitions.

Open a Command Prompt using the "Run as administrator" option.  Then run one of the following commands based upon your server OS being 32 or 64 bit.

32-bit

[CD]:\CLIENT\CLIENTSETUP.EXE /NOMOM

64-bit
[CD]:\CLIENT\X64\CLIENTSETUP.EXE /NOMOM

