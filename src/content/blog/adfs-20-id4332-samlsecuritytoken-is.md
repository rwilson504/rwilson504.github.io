---
title: "ADFS 2.0 ID:4332 The SamlSecurityToken is rejected because the SamlAssertion"
description: "ID4223: The SamlSecurityToken is rejected because the SamlAssertion.NotOnOrAfter condition is not satisfied. NotOnOrAfter: '02/28/2012 1:15:04 PM' Current time: '02/28/2012 2:18:35 PM'"
pubDate: 2012-02-28
updatedDate: 2012-03-01
category: power-apps
tags:
  - "adfs-2"
draft: false
originalBloggerUrl: /2012/02/adfs-20-id4332-samlsecuritytoken-is.html
---

ID4223: The SamlSecurityToken is rejected because the SamlAssertion.NotOnOrAfter condition is not satisfied.  
NotOnOrAfter: '02/28/2012 1:15:04 PM'  
Current time: '02/28/2012 2:18:35 PM'  
  
This error happens when the clock on the ADFS server and the clock on the machine hosting the website are not synchronized.  
  
To fix this go onto each box and restart the "Windows Time" service.  Then open a command prompt and type w32tm /resync  

##
