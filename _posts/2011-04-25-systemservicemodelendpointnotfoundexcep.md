---
layout: post
title: System.ServiceModel.EndpointNotFoundException in OWSTIMER.EXE
date: '2011-04-25T11:25:00.000-04:00'
author: Rick Wilson
tags:
- Forefront
- Security
- Error
- SharePoint 2010
modified_time: '2011-04-25T11:25:30.939-04:00'
thumbnail: http://1.bp.blogspot.com/-vBNvtzg9zXs/TbWReWGI3NI/AAAAAAAAGIw/iNB4vUDd3dg/s72-c/SeriveModelErrorOwstimer.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7502121131790730390
blogger_orig_url: https://www.richardawilson.com/2011/04/systemservicemodelendpointnotfoundexcep.html
---


I started getting this error every five minutes after the timer service would kick off.

[![](http://1.bp.blogspot.com/-vBNvtzg9zXs/TbWReWGI3NI/AAAAAAAAGIw/iNB4vUDd3dg/s400/SeriveModelErrorOwstimer.png)](http://1.bp.blogspot.com/-vBNvtzg9zXs/TbWReWGI3NI/AAAAAAAAGIw/iNB4vUDd3dg/s1600/SeriveModelErrorOwstimer.png)An Unhandled exception ('System.ServiceModel.EndpointNotFoundException') occurred in OWSTIMER.EXE
Turns out that the error was due to the Forefront Identity Manager Service not being started.  After starting the service the error goes away.

[![](http://4.bp.blogspot.com/-5vNQcH_MOgE/TbWReQnnYuI/AAAAAAAAGIs/nJ5qyfufNKM/s400/ForefrontServicesStart.png)](http://4.bp.blogspot.com/-5vNQcH_MOgE/TbWReQnnYuI/AAAAAAAAGIs/nJ5qyfufNKM/s1600/ForefrontServicesStart.png)

