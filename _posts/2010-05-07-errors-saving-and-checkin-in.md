---
layout: post
title: Errors Saving and Checkin In Excel/PowerPoint files in SharePoint using CAC
  Card
date: '2010-05-07T11:30:00.004-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Administration
- Windows Server 2008
- IIS
modified_time: '2010-07-08T11:47:43.377-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6768174352673879038
blogger_orig_url: https://www.richardawilson.com/2010/05/errors-saving-and-checkin-in.html
---


Users accessing SharePoint using a CAC card may experienced problems with saving and checking in Excel and PowerPoint documents on the SharePoint servers.  When attempting to do either a dialog box appeared stating that "The web server is currently busy please try again later."

Environment:

-Office 2007

-Server 2008

-SharePoint 2007 SP2

-IIS 7.5

The problem turned out to be that a setting, uploadreadaheadsize, is defaulted to 48kb.  This is not big enough for the website to read in the entire header when a CAC certificate is added to it.  To fix the problem I completed the following steps.

**1. Start**->**Run**-> runas /user:Administrator cmd
cd c:\Windows\systems32\inetsrv

**2.** appcmd.exe set config  -section:system.webServer/serverRuntime /uploadReadAheadSize:"200000000"  /commit:apphost

This updates IIS to ensure it can read all the data in the headers.

Supporing Posts:

[http://blogs.msdn.com/rakkimk/archive/2009/03/17/iis7-tweet-1-setting-uploadreadaheadsize.aspx](http://blogs.msdn.com/rakkimk/archive/2009/03/17/iis7-tweet-1-setting-uploadreadaheadsize.aspx)

[http://forums.iis.net/p/1108662/1702390.aspx](http://forums.iis.net/p/1108662/1702390.aspx)

