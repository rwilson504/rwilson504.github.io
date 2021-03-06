---
layout: post
title: CryptographicException Error Connecting SharePoint 2007 and ADFS 2.0 Using
  Domain App Pool User with SharePoint
date: '2010-10-25T11:57:00.002-04:00'
author: Rick Wilson
tags:
- Windows Server 2008R2
- SharePoint 2007
- ADFS 2.0
- IIS
modified_time: '2010-10-25T11:59:36.164-04:00'
thumbnail: http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWTJl1m0YI/AAAAAAAAFjc/R54tfDGXsoI/s72-c/navigatetosite.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7807929351122651900
blogger_orig_url: https://www.richardawilson.com/2010/10/cryptographicexception-error-connecting.html
---

When attempting to connect ADFS 2.0 and SharePoint 2007 most of the documentation assumes you are using the NetworkService account to run the application pools for the SharePoint content web applications.  In a real world environment though a domain user is probably running the app pools.

Tech Specs:

SharePoint Version: 2007
ADFS Version: 2.0
Server OS: 2008R2

ADFS URL: [https://lab-adfs.defenseready.local/](https://lab-adfs.defenseready.local/)
SharePoint 2007 URL: [https://ext.defenseready.local/](https://ext.defenseready.local/)
SharePoint App Pool User: defenseready\spapppool

What Happens:

[![](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWTJl1m0YI/AAAAAAAAFjc/R54tfDGXsoI/s400/navigatetosite.png)](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWTJl1m0YI/AAAAAAAAFjc/R54tfDGXsoI/s1600/navigatetosite.png)Users opens the browser and navigates to the site.
[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWRJrtFReI/AAAAAAAAFjY/HDoWAyzRnCI/s400/signin.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWRJrtFReI/AAAAAAAAFjY/HDoWAyzRnCI/s1600/signin.png)Enter user information and click Sign In
[![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWQHWDjiPI/AAAAAAAAFjQ/agEWvBz25_c/s400/unexpectederror.png)](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWQHWDjiPI/AAAAAAAAFjQ/agEWvBz25_c/s1600/unexpectederror.png)The user now is presented with the error that An unexpected error has occurred.

How to diagnose:

In order to diagnose we will need to update the web.config for the SharePoint site.

[![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWN_Pxhf1I/AAAAAAAAFjI/UwnfUCuGviY/s320/spwebconfig1.png)](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWN_Pxhf1I/AAAAAAAAFjI/UwnfUCuGviY/s1600/spwebconfig1.png)First find the CallStack attribute and set it to true[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWN_iDgYbI/AAAAAAAAFjM/gvVFKwGpLtg/s320/spwebconfig2.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWN_iDgYbI/AAAAAAAAFjM/gvVFKwGpLtg/s1600/spwebconfig2.png)Secondly change the customErrors mode attribute to OffError:

When we repeat the steps earlier and try to access the site we can now see the full error.

[![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWN9KilSWI/AAAAAAAAFjA/WBZlaxZ1f4E/s400/cryptoerror.png)](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWN9KilSWI/AAAAAAAAFjA/WBZlaxZ1f4E/s1600/cryptoerror.png)SharePoint is reporting a CryptographicException

﻿ How to Resolve:

In order to give the application pool the correct rights to load the certificates we need to update the application pool settings.   Specifically we need to update the Load User Profile setting to True.

[![](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWN-dIVulI/AAAAAAAAFjE/GRE6mnFVNq8/s400/sharepointapppool.png)](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWN-dIVulI/AAAAAAAAFjE/GRE6mnFVNq8/s1600/sharepointapppool.png)

 After you have updated this restart IIS and give it another try.
![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TMWN_Pxhf1I/AAAAAAAAFjI/UwnfUCuGviY/s320/spwebconfig1.png)

