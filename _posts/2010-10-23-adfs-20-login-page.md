---
layout: post
title: Display ADFS 2.0 Forms Authentication Login Page Instead of Windows Authentication
  Prompt
date: '2010-10-23T17:21:00.005-04:00'
author: Rick Wilson
tags:
- ADFS 2.0
- Authentication
- IIS
modified_time: '2010-11-05T12:19:57.607-04:00'
thumbnail: http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNS3k2fSUI/AAAAAAAAFi4/9IGIUKJMYic/s72-c/adfsloginprompt.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4406178881524280857
blogger_orig_url: https://www.richardawilson.com/2010/10/adfs-20-login-page.html
---

After installing ADFS 2.0 for SharePoint a Windows login prompt was shown when the SharePoint site forwarded to the ADFS server instead of the ADFS Forms Authentication login screen.  

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNS3k2fSUI/AAAAAAAAFi4/9IGIUKJMYic/s320/adfsloginprompt.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNS3k2fSUI/AAAAAAAAFi4/9IGIUKJMYic/s1600/adfsloginprompt.png)

No matter what account I tried to use here I would eventually receive a 401 Not Auhorized error.

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNTITwOHCI/AAAAAAAAFi8/pR9WoZJNj_I/s400/adfs+401+error.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNTITwOHCI/AAAAAAAAFi8/pR9WoZJNj_I/s1600/adfs+401+error.png)

The reason for this is that the ADFS website tries to use Windows Authentication before trying to use the Forms authentication which displays the loging page below.

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNP9XnvyTI/AAAAAAAAFio/FsKymt2I5RM/s400/adfsloginscreen.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNP9XnvyTI/AAAAAAAAFio/FsKymt2I5RM/s1600/adfsloginscreen.png)Forms Login Screen for ADFS 2.0

To fix this do the following on the ADFS server:

1. Open IIS and Explore under Default Website\adfs\ls

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNQmuAyt0I/AAAAAAAAFis/hh89w5QBMJE/s400/adfsexplore.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TMNQmuAyt0I/AAAAAAAAFis/hh89w5QBMJE/s1600/adfsexplore.png)

2. Open the web.config file with Notepad, look for the localAuthenticationTypes section.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNRvI1vjPI/AAAAAAAAFiw/5Ud917KhrY0/s400/adfslocalauthenticationtypes.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNRvI1vjPI/AAAAAAAAFiw/5Ud917KhrY0/s1600/adfslocalauthenticationtypes.png)

3. Move the line for Forms above the line for Integrated and save the web.config file.  This will force the ADFS application to use the Login Page authentication before trying to use Windows Authentication.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNRy6VnxPI/AAAAAAAAFi0/YKR18tqLO10/s400/adfsformsabove.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMNRy6VnxPI/AAAAAAAAFi0/YKR18tqLO10/s1600/adfsformsabove.png)

 

