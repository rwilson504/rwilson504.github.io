---
layout: post
title: SharePoint Kerberos Authentication wtih IIS 7+
date: '2010-07-01T18:48:00.006-04:00'
author: Rick Wilson
tags:
- Kerberos
- SharePoint 2007 Administration
- Windows Server 2008
- IIS
modified_time: '2010-07-08T11:28:51.646-04:00'
thumbnail: http://1.bp.blogspot.com/_mr9BzRLR2GQ/TCp48KO0_5I/AAAAAAAAFBg/vmIcS5fCqK8/s72-c/Kerberos1.jpg
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5135840657633662697
blogger_orig_url: https://www.richardawilson.com/2010/07/sharepoint-kerberos-authentication-wtih.html
---


When Microsoft designed IIS 7 they decided to add in a new feature that automaticaly uses the LocalSystem account for Windows Authentication by the kernel.  The problem with this is that is causes problems when a domain account is being used for the SharePoint applicaiton pools and Kerberos is enabled.  Because the authenication is happening as LocalSystem the application pool account is desregarded when it comes to kerberos.

Symptom(s):

When I had kerberos enabled and the kernel-mode authentication was enabledI would get prompted for user credentials until finally receiving a 401 error in the browser.

Fix(s):

There are two ways to fix this issue.  You can fix it for all websites or for a specific website.  The first solution is to apply to all websites.

**Apply to all sites:**

Right click on Notepad and choose "Run as administrator"

Navigate to and open: C:\Windows\System32\inetsrv\config\applicationHost.config

Under the system.webServer/security/authentication/windowsAuthentication section ensure the following.

    ```<windowsauthentication enabled="true" useapppoolcredentials="true" usekernelmode="true">
    ```

**Apply to individual site:**
The second way will allow you to apply this change to a specific website.

Open the IIS Manager and click on the website you would like to change.  Then double click on the Authentication icon in the center pane.

[![](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TCp48KO0_5I/AAAAAAAAFBg/vmIcS5fCqK8/s400/Kerberos1.jpg)](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TCp48KO0_5I/AAAAAAAAFBg/vmIcS5fCqK8/s1600/Kerberos1.jpg)

Click on the Windows Authentication option in the center pane and then click Advanced Settings... in the right hand pane.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TCp4-lmVMJI/AAAAAAAAFBo/uk3sBjHzNCE/s400/Kerberos2.jpg)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TCp4-lmVMJI/AAAAAAAAFBo/uk3sBjHzNCE/s1600/Kerberos2.jpg)

Finally **un-check** the Enable Kernel-mode authentication box.

[![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TCp5B13flTI/AAAAAAAAFBw/WlXU4kjQngg/s320/Kerberos3.jpg)](http://3.bp.blogspot.com/_mr9BzRLR2GQ/TCp5B13flTI/AAAAAAAAFBw/WlXU4kjQngg/s1600/Kerberos3.jpg)

Supporting Post(s):

[http://www.harbar.net/archive/2008/05/18/Using-Kerberos-with-SharePoint-on-Windows-Server-2008.aspx](http://www.harbar.net/archive/2008/05/18/Using-Kerberos-with-SharePoint-on-Windows-Server-2008.aspx)

