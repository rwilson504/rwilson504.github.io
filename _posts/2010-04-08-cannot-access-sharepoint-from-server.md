---
layout: post
title: Cannot Access SharePoint From The Server
date: '2010-04-08T16:05:00.001-04:00'
author: Rick Wilson
tags:
- Error
- SharePoint 2007 Administration
- SharePoint 2007
modified_time: '2010-04-08T16:06:17.439-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7658087566625465169
blogger_orig_url: https://www.richardawilson.com/2010/04/cannot-access-sharepoint-from-server.html
---

**Problem**:
Accessing sharepoint using the FQDN while on the server.

**Solution**:
There is a registry setting to disable the Loopback Adapter that is present in Windows Server.  I have found this to cause a lot of errors not only with accessing the SharePoint site but also with indexing and searching.  I typicaly suggestion making the following registry settings after installing any instance of Microsoft SharePoint or Microsoft SQL server.

To set the DisableLoopbackCheck registry key, follow these steps:

1. Set the DisableStrictNameChecking registry entry to 1. For more information about how to do this, click the following article number to view the article in the Microsoft Knowledge Base: 

281308 (http://support.microsoft.com/kb/281308/ ) Connecting to SMB share on a Windows 2000-based computer or a Windows Server 2003-based computer may not work with an alias name 

2. Click Start, click Run, type regedit, and then click OK.

3. In Registry Editor, locate and then click the following registry key: 

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa

4. Right-click Lsa, point to New, and then click DWORD Value.

5. Type DisableLoopbackCheck, and then press ENTER.

6. Right-click DisableLoopbackCheck, and then click Modify.

7. In the Value data box, type 1, and then click OK.

8. Quit Registry Editor, and then restart your computer.

http://support.microsoft.com/kb/896861

