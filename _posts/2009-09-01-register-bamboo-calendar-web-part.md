---
layout: post
title: Register Bamboo Calendar Web Part
date: '2009-09-01T17:19:00.001-04:00'
author: Rick Wilson
tags:
- Web Part
- SharePoint 2007
modified_time: '2009-09-01T17:57:07.398-04:00'
thumbnail: http://2.bp.blogspot.com/_mr9BzRLR2GQ/Sp2P3tVwQ-I/AAAAAAAAEds/0B96_y8xITQ/s72-c/bambooinstaller.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7890543903497720639
blogger_orig_url: https://www.richardawilson.com/2009/09/register-bamboo-calendar-web-part.html
---

I recently downloaded the Bamboo Calendar Plus Web Part v2.5. I ran the setup file and installed both the Calendar Plus Web Part and the Bamboo License Manager v2.7. Here are the issues I ran into:

Firstly, you will need to be connected to the internet to get the registration program to correctly activate the web part. Otherwise you will have to activate by e-mail or phone.

Secondly, the Calendar web part .dll is not located in the GAC so I had to go out and search for it. The .dll was located in <System Drive>:\Inetpub\wwwroot\wss\VirtualDirectories\80\bin\Bamboo.CalendarViewExtended.dll. In my case my VirtualDirectory was 80 but for others this may be different. Also if you installed the web part into multiple web application you will also need to activate the product by located the .dll under the other VirtualDirectories folders.

Then after selecting the .ddl file in the License Manager I entered the product code. I accidently entered an incorrect product code. Then came the BLUE SCREEN OF DEATH from Windows Server 2003. I don't know about you but that is scary.

After my server restarted I then ran the License Manger again... this time using the correct product code. I was then able to activate the .dll file located in the multiple web application I installed it in.

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/Sp2P3tVwQ-I/AAAAAAAAEds/0B96_y8xITQ/s400/bambooinstaller.png)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/Sp2P3tVwQ-I/AAAAAAAAEds/0B96_y8xITQ/s1600-h/bambooinstaller.png)

