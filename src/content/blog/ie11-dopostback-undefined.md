---
title: "IE11 __dopostback undefined"
description: "After attempting to access my web app in IE11 I noticed all the links were no longer working. Looking through the JavaScript debugger I saw the error \"__dopostback undefined\" when attempting to click…"
pubDate: 2013-11-19
category: misc
tags:
  - "asp-net"
  - "web-application"
draft: false
originalBloggerUrl: /2013/11/ie11-dopostback-undefined.html
---

After attempting to access my web app in IE11 I noticed all the links were no longer working.  Looking through the JavaScript debugger I saw the error "\_\_dopostback undefined" when attempting to click a link.  Solution turned out to be installing .NET 4.5 on the server.  
  
<http://www.microsoft.com/en-us/download/details.aspx?id=30653>
