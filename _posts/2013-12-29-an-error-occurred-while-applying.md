---
layout: post
title: An error occurred while applying security information to
date: '2013-12-29T16:56:00.002-05:00'
author: Rick Wilson
tags:
- Security
- Windows Server 2008R2
- Windows Server 2008
modified_time: '2019-04-06T14:50:33.762-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2924260930626275022
blogger_orig_url: https://www.richardawilson.com/2013/12/an-error-occurred-while-applying.html
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

