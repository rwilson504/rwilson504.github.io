---
layout: post
title: ADFS 2.0 ID:4332 The SamlSecurityToken is rejected because the SamlAssertion
date: '2012-02-28T13:10:00.002-05:00'
author: Rick Wilson
tags:
- ADFS 2.0
modified_time: '2012-03-01T15:13:05.664-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5295211835149970837
blogger_orig_url: https://www.richardawilson.com/2012/02/adfs-20-id4332-samlsecuritytoken-is.html
---


ID4223: The SamlSecurityToken is rejected because the SamlAssertion.NotOnOrAfter condition is not satisfied.
NotOnOrAfter: '02/28/2012 1:15:04 PM'
Current time: '02/28/2012 2:18:35 PM'

This error happens when the clock on the ADFS server and the clock on the machine hosting the website are not synchronized.

To fix this go onto each box and restart the "Windows Time" service.  Then open a command prompt and type w32tm /resync

