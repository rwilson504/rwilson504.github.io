---
layout: post
title: Could Not Load Type System.ServiceModel .net 4 Web App
date: '2014-03-10T15:05:00.001-04:00'
author: Rick Wilson
tags:
- ".net"
- Error
- IIS
modified_time: '2014-03-12T11:25:00.761-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6065440205386898178
blogger_orig_url: https://www.richardawilson.com/2014/03/could-not-load-type-systemservicemodel.html
---


 

While attempting to load a .Net 4 website I kept getting a configuration error and the following item in the Event Log

Exception information: 
    Exception type: ConfigurationErrorsException 
    Exception message: Could not load type 'System.ServiceModel.Activation.HttpModule' from assembly 'System.ServiceModel, Version=3.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.

Turns our that IIS didn’t have all the .Net components installed.  To fix this you can run the following command which will update IIS with the correct .Net components.  Didn’t even require a reboot.

```c:\WINDOWS\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -iru```

