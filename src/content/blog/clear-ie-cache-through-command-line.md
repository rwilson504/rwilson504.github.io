---
title: "Clear IE Cache Through Command Line"
description: "Apparently you can clear the IE cache using the command line. This is going into batch files to reduce the number of times I have to click in IE."
pubDate: 2011-04-18
category: misc
tags:
  - "batch-files"
  - "cache"
  - "internet-explorer"
draft: false
originalBloggerUrl: /2011/04/clear-ie-cache-through-command-line.html
---

Apparently you can clear the IE cache using the command line.  This is going into batch files to reduce the number of times I have to click in IE.

- **All**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
- **History**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
- **Cookies**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
- **Temp Internet Files**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
- **Form Data**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
- **Passwords**, RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32
