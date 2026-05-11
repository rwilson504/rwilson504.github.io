---
title: "SharePoint Kerberos Authentication wtih IIS 7+"
description: "When Microsoft designed IIS 7 they decided to add in a new feature that automaticaly uses the LocalSystem account for Windows Authentication by the kernel.…"
pubDate: 2010-07-01
updatedDate: 2010-07-08
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgAVosxhO3N3VnCrbw4OUUcfCEKj24KVRJXyo8BRZ-c7IKF-20DMoc-earYSZz-Lw_bW3oGkNEDOqPywZ3CAwP8OVwhTFRaBVd0RLR_0ql4bKp1ruMRQjlSbuTkgTMiMLi_0tS_cOATiy0/s400/Kerberos1.jpg"
category: power-apps
tags:
  - "iis"
  - "kerberos"
  - "sharepoint-2007-administration"
  - "windows-server-2008"
draft: false
originalBloggerUrl: /2010/07/sharepoint-kerberos-authentication-wtih.html
---

When Microsoft designed IIS 7 they decided to add in a new feature that automaticaly uses the LocalSystem account for Windows Authentication by the kernel.  The problem with this is that is causes problems when a domain account is being used for the SharePoint applicaiton pools and Kerberos is enabled.  Because the authenication is happening as LocalSystem the application pool account is desregarded when it comes to kerberos.

Symptom(s):

When I had kerberos enabled and the kernel-mode authentication was enabledI would get prompted for user credentials until finally receiving a 401 error in the browser.

Fix(s):  
  

There are two ways to fix this issue.  You can fix it for all websites or for a specific website.  The first solution is to apply to all websites.

**Apply to all sites:**

Right click on Notepad and choose "Run as administrator"

Navigate to and open: C:\Windows\System32\inetsrv\config\applicationHost.config

Under the system.webServer/security/authentication/windowsAuthentication section ensure the following.  
  

```
<windowsauthentication enabled="true" useapppoolcredentials="true" usekernelmode="true">
```

  
**Apply to individual site:**  
The second way will allow you to apply this change to a specific website.

Open the IIS Manager and click on the website you would like to change.  Then double click on the Authentication icon in the center pane.

Click on the Windows Authentication option in the center pane and then click Advanced Settings... in the right hand pane.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQXv0EGkkFDp-cOf2Z0u3IUYwc5hB7cFdWQJZ6Vl-l82255rhUqIgs9lYb_Uiu2Hq9-W1110n_zDXJ8rHzIPqz8jh-K4QTva0m6OMd616qIuhx_c7jIv2nZ4CxAA_eClgWn7vWesa0N_4/s400/Kerberos2.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQXv0EGkkFDp-cOf2Z0u3IUYwc5hB7cFdWQJZ6Vl-l82255rhUqIgs9lYb_Uiu2Hq9-W1110n_zDXJ8rHzIPqz8jh-K4QTva0m6OMd616qIuhx_c7jIv2nZ4CxAA_eClgWn7vWesa0N_4/s1600/Kerberos2.jpg)

Finally **un-check** the Enable Kernel-mode authentication box.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg8VHzqhluv7CKb276QXuuxH1mttwh0XoNefGK0dXMhbfc3RbchJC5qy1ceUlFEclt5VFsevhw0wk0pnmhObod_9KDAjS67qow6vcyYI3FTv7MrmtAKq8CBK4hZtPT-7F-xPFcIp6wKwSk/s320/Kerberos3.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg8VHzqhluv7CKb276QXuuxH1mttwh0XoNefGK0dXMhbfc3RbchJC5qy1ceUlFEclt5VFsevhw0wk0pnmhObod_9KDAjS67qow6vcyYI3FTv7MrmtAKq8CBK4hZtPT-7F-xPFcIp6wKwSk/s1600/Kerberos3.jpg)

Supporting Post(s):

<http://www.harbar.net/archive/2008/05/18/Using-Kerberos-with-SharePoint-on-Windows-Server-2008.aspx>
