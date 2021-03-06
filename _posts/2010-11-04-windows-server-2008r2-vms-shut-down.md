---
layout: post
title: Windows Server 2008R2 VMs Shut Down After 1 to 2 Hours
date: '2010-11-04T16:59:00.001-04:00'
author: Rick Wilson
tags:
- Windows Server 2008R2
- Windows Server 2008
modified_time: '2011-02-21T16:09:40.020-05:00'
thumbnail: http://4.bp.blogspot.com/_mr9BzRLR2GQ/TNMeILFAQTI/AAAAAAAAFxY/rdcLCuubc-c/s72-c/activate1.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1267194315839592586
blogger_orig_url: https://www.richardawilson.com/2010/11/windows-server-2008r2-vms-shut-down.html
---

When created a lab environment to test ADFS 2.0 I utilized the Windows 2008R2 VM baselines distributed by Microsoft.  After a few days I was told that I had to activate.  The VMs included a 180 day license for use but I didn't feel like adding another network adapter into Hyper-V to connect them to the internet.  I started having issues though where the servers would shut down every hour or so.  I though that maybe there was a memory issue and Hyper-V was shutting them down in order to free up RAM.  Turns out that if Server 2008R2 is not activated it automatically shuts down after a period of time.  After connecting the server to the internet and activating them the problem went away.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TNMeILFAQTI/AAAAAAAAFxY/rdcLCuubc-c/s400/activate1.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TNMeILFAQTI/AAAAAAAAFxY/rdcLCuubc-c/s1600/activate1.png)

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TNMeLx8jCOI/AAAAAAAAFxc/vWvmt0MDG0I/s400/activate2.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TNMeLx8jCOI/AAAAAAAAFxc/vWvmt0MDG0I/s1600/activate2.png)[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TNMePH0vfVI/AAAAAAAAFxg/5L_V-0kRZfE/s400/activate3.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TNMePH0vfVI/AAAAAAAAFxg/5L_V-0kRZfE/s1600/activate3.png)

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TNMeSiN5WuI/AAAAAAAAFxk/6Dp0FstXzgk/s320/activate4.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TNMeSiN5WuI/AAAAAAAAFxk/6Dp0FstXzgk/s1600/activate4.png)

Finally the madness of the unknown shut downs has ended :)

