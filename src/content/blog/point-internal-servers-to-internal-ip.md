---
title: "Point Internal Servers to Internal IP for Internet Facing Sub Domain"
description: "When you want to create internal DNS entries for a domain name that is also registered externally you can actually create a DNZ zone for that specific sub-domain."
pubDate: 2014-06-05
category: "windows"
tags:
  - "dns"
  - "networking"
  - "windows-server"
draft: false
originalBloggerUrl: /2014/06/point-internal-servers-to-internal-ip.html
---

When you want to create internal DNS entries for a domain name that is also registered externally you can actually create a DNZ zone for that specific sub-domain.  
  
The first thing I had tried was creating a zone for the entire domain, eg external.com.  I then put in A records for the specific sub-domains I wanted.  The issues I had though was that any other sub-domains were unreachable without an A record.  
  
Instead what I did was create a zone for my specific sub-domain, eg sub.external.com.  I then put in an A record with a blank Host Name and entered the IP address of my local server.  This way when my local servers attempt to navigate to anything in the domain.com namespace they will still go to my outside name server unless I have specifically created a zone for the sub-domains I want them to access using internal Urls.  
  
  

- internal.local

- Forward Lookup Zone

- \_msdcs.internal.local
- internal.local
- sub.external.com

- A Record - Name, (same as parent folder) - Type, Host (A) - Data, 10.0.0.25
