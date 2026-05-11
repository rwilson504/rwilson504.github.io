---
title: "Disable CRL Checking in IIS 8"
description: "When working on a system with no internet access it is important to ensure that CRL checking is disabled. If not disabled you will always receive a 403.13 error after entering you pin."
pubDate: 2014-12-16
updatedDate: 2015-07-27
category: power-apps
tags:
  - "adfs-2"
  - "cac"
  - "certificates"
  - "iis"
  - "windows-server-2012"
draft: false
originalBloggerUrl: /2014/12/disable-crl-checking-in-iis-8.html
---

When working on a system with no internet access it is important to ensure that CRL checking is disabled. If not disabled you will always receive a 403.13 error after entering you pin. After a lot of searching I found an article written by Kaushal Kumar Panday. I would suggest you check out his article first, I'm just re-posting some of the commands here for my own use.  
[Original Article](http://blogs.msdn.com/b/kaushal/archive/2012/10/15/disable-client-certificate-revocation-check-on-iis.aspx)  
  
Also if you are using ip addresses not hostname just change hostnameport to ipport.  
  
**Command to Show All Binding and Their Verify Client Certificate Revocation Setting:**  

```
netsh http show sslcert
```

  
**Delete SNI Binding:**   

```
netsh http delete sslcert hostnameport=www.mysite.com:443
```

  
**Add SNI Binding:**
  

```
netsh http add sslcert hostnameport=www.mysite.com:443 certhash=78dd6cc2bf5785a123654d1d789c530fcb5687c2 appid={3cc2a456-a78c-2cc9-bcc9-782bc83bb789} certstorename=My verifyclientcertrevocation=disable
```
