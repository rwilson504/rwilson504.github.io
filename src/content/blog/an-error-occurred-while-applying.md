---
title: "An error occurred while applying security information to"
description: "While attempting to move files from a hard drive I recovered I kept getting the following error on a specific set of files."
pubDate: 2013-12-29
updatedDate: 2019-04-06
category: "windows"
tags:
  - "security"
  - "windows-server-2008"
  - "windows-server-2008r2"
draft: false
originalBloggerUrl: /2013/12/an-error-occurred-while-applying.html
---

While attempting to move files from a hard drive I recovered I kept getting the following error on a specific set of files.  
  
An error occurred while applying security information to  
{G:\Folder}  
Failed to enumerate objects in the container. Access is denied.  
  
In order to fix it did the following.  
  
-Open a Command Prompt "As Administrator"  
  
-Run the following commands:  
  
takeown /f "G:\folder" /r /d y  
icacls "G:\folder" /grant administrators:F /T
