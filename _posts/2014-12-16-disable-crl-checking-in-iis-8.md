---
layout: post
title: Disable CRL Checking in IIS 8
date: '2014-12-16T12:18:00.000-05:00'
author: Rick Wilson
tags:
- CAC
- Certificates
- ADFS 2.0
- Windows Server 2012
- IIS
modified_time: '2015-07-27T14:18:54.639-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2300918509150096187
blogger_orig_url: https://www.richardawilson.com/2014/12/disable-crl-checking-in-iis-8.html
---

When working on a system with no internet access it is important to ensure that CRL checking is disabled.  If not disabled you will always receive a 403.13 error after entering you pin.  After a lot of searching I found an article written by Kaushal Kumar Panday.  I would suggest you check out his article first, I'm just re-posting some of the commands here for my own use.
[Original Article](http://blogs.msdn.com/b/kaushal/archive/2012/10/15/disable-client-certificate-revocation-check-on-iis.aspx)

Also if you are using ip addresses not hostname just change hostnameport to ipport.

Command to Show All Binding and Their Verify Client Certificate Revocation Setting:

    netsh http show sslcert

Delete SNI Binding:

    netsh http delete sslcert hostnameport=www.mysite.com:443

Add SNI Binding:

    netsh http add sslcert hostnameport=www.mysite.com:443 certhash=78dd6cc2bf5785a123654d1d789c530fcb5687c2 appid={3cc2a456-a78c-2cc9-bcc9-782bc83bb789} certstorename=My verifyclientcertrevocation=disable

