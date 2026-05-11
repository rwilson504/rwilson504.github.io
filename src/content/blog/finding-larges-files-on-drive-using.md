---
title: "Finding Largest Files on Drive Using Powershell"
description: "Recently a colleague of mine was having issues with low drive space on one of our servers. Because this is a clients system i am unable to copy over WinDirStat which is what i would usually use to…"
pubDate: 2019-04-22
updatedDate: 2019-07-01
category: power-apps
tags:
  - "powershell"
draft: false
originalBloggerUrl: /2019/04/finding-larges-files-on-drive-using.html
---

Recently a colleague of mine was having issues with low drive space on one of our servers.  Because this is a clients system i am unable to copy over [WinDirStat](https://windirstat.net/) which is what i would usually use to determine what is eating up all the drive space.  Instead I ended up using PowerShell to show me to top files which were eating up space.  
  

```
dir -path c:\ -rec -ErrorAction SilentlyContinue | sort -desc Length | select -first 20
```
