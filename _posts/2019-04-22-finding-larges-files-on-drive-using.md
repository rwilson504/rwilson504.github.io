---
layout: post
title: Finding Largest Files on Drive Using Powershell
date: '2019-04-22T09:29:00.001-04:00'
author: Rick Wilson
tags: 
modified_time: '2019-07-01T08:18:29.722-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4002438996361539019
blogger_orig_url: https://www.richardawilson.com/2019/04/finding-larges-files-on-drive-using.html
---

Recently a colleague of mine was having issues with low drive space on one of our servers.  Because this is a clients system i am unable to copy over [WinDirStat ](https://windirstat.net/)which is what i would usually use to determine what is eating up all the drive space.  Instead I ended up using PowerShell to show me to top files which were eating up space.

    dir -path c:\ -rec -ErrorAction SilentlyContinue | sort -desc Length | select -first 20

