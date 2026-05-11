---
title: "Wake Up IIS Websites"
description: "One of the biggest issues I have found with using authentication methods like Kerberos Constrained Delegation is that the first person who hits the site in the morning gets a 500 error until the…"
pubDate: 2013-10-25
category: power-apps
tags:
  - "crm-2011"
  - "iis"
  - "kerberos"
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2013/10/wake-up-iis-websites.html
---

One of the biggest issues I have found with using authentication methods like Kerberos Constrained Delegation is that the first person who hits the site in the morning gets a 500 error until the website application pools have been rebuilt after their nightly recycle.  Recently I discovered a great module for IIS that can help prevent this.  
  
<http://www.iis.net/downloads/microsoft/application-initialization>  
  
"IIS Application Initialization for IIS 7.5 enables website administrators to improve the responsiveness of their Web sites by loading the Web applications before the first request arrives. By proactively loading and initializing all the dependencies such as database connections, compilation of ASP.NET code, and loading of modules, IT Professionals can ensure their Web sites are responsive at all times even if their Web sites use a custom request pipeline or if the Application Pool is recycled. While an application is being initialized, IIS can also be configured to return an alternate response such as static content as a placeholder or "splash page" until an application has completed its initialization tasks."  
  
Also you will probably want a UI that allows you to do the configuration, here you go:  
<http://blogs.msdn.com/b/amol/archive/2013/01/25/application-initialization-ui-for-iis-7-5.aspx>  
  
  
Additional Resources:  
<http://blogs.iis.net/wadeh/archive/2012/05/01/application-initialization-part-2.aspx>  
<http://dynamics.co.il/crm-iis-site-wake/>
