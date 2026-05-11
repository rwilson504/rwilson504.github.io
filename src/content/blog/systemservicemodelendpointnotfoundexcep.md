---
title: "System.ServiceModel.EndpointNotFoundException in OWSTIMER.EXE"
description: "I started getting this error every five minutes after the timer service would kick off."
pubDate: 2011-04-25
heroImage: "/heroes/systemservicemodelendpointnotfoundexcep.png"
category: power-apps
tags:
  - "error"
  - "forefront"
  - "security"
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2011/04/systemservicemodelendpointnotfoundexcep.html
---

I started getting this error every five minutes after the timer service would kick off.

|  |
| --- |
|  |
| An Unhandled exception ('System.ServiceModel.EndpointNotFoundException') occurred in OWSTIMER.EXE |

  
Turns out that the error was due to the Forefront Identity Manager Service not being started.  After starting the service the error goes away.  
  

[![](/images/systemservicemodelendpointnotfoundexcep/01-ForefrontServicesStart.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEitE2v0hEYULUVkynN-sR6MkROq5JmCqLiATMHjUatOtQC0eTFPotm_G-lkXz3x0TnexNSkNGP-akv_XADvJb5Gs5Sa8jivLi8gHYMVdqE9OCTPqWyJFNsbB5bW5mpPkUh0w__4S0sotOc/s1600/ForefrontServicesStart.png)
