---
layout: post
title: IE11 __dopostback undefined
date: '2013-11-19T11:54:00.000-05:00'
author: Rick Wilson
tags:
- Web Application
- ASP.NET
modified_time: '2013-11-19T11:54:11.091-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3501387881937448701
blogger_orig_url: https://www.richardawilson.com/2013/11/ie11-dopostback-undefined.html
---

After attempting to access my web app in IE11 I noticed all the links were no longer working.  Looking through the JavaScript debugger I saw the error "__dopostback undefined" when attempting to click a link.  Solution turned out to be installing .NET 4.5 on the server.

[http://www.microsoft.com/en-us/download/details.aspx?id=30653](http://www.microsoft.com/en-us/download/details.aspx?id=30653)

