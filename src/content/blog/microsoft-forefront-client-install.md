---
title: "Microsoft Forefront Client Install Wihtout Centralized Server"
description: "I was recently looking around for an Anti-Virus solution for Windows Server 2008. I had tried downloading Microsoft Forefront Client before but when I ran the setup it wanted me to install a ton of…"
pubDate: 2010-07-01
updatedDate: 2011-05-16
category: "windows"
tags:
  - "forefront"
  - "windows-server-2008"
  - "windows-server-2008r2"
draft: false
originalBloggerUrl: /2010/07/microsoft-forefront-client-install.html
---

I was recently looking around for an Anti-Virus solution for Windows Server 2008.  I had tried downloading Microsoft Forefront Client before but when I ran the setup it wanted me to install a ton of server components... so where is the client part of all this?  What I wanted was a simple anti-virus software that uses windows update to get all my new virus definitions.  
  
To do this just run the install the client from the cd using the /NOMOM switch.  This install the client but uses Windows Update to get all the virus definitions.  
  
Open a Command Prompt using the "Run as administrator" option.  Then run one of the following commands based upon your server OS being 32 or 64 bit.  
  
32-bit  
  
[CD]:\CLIENT\CLIENTSETUP.EXE /NOMOM  
  
64-bit  
[CD]:\CLIENT\X64\CLIENTSETUP.EXE /NOMOM
