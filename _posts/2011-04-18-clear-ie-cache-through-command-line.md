---
layout: post
title: Clear IE Cache Through Command Line
date: '2011-04-18T16:17:00.000-04:00'
author: Rick Wilson
tags:
- Batch Files
- Internet Explorer
- Cache
modified_time: '2011-04-18T16:17:19.326-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8564221373066628398
blogger_orig_url: https://www.richardawilson.com/2011/04/clear-ie-cache-through-command-line.html
---


Apparently  you can clear the IE cache using the command line.  This is going into batch files to reduce the number of times I have to click in IE.

- All, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 255 
- History, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 1
- Cookies, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 2
- Temp Internet Files, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 8
- Form Data, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 16
- Passwords, RunDll32.exe  InetCpl.cpl,ClearMyTracksByProcess 32

