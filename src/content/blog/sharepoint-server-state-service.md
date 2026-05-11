---
title: "SharePoint Server State Service"
description: "After adding the SharePoint 2010 Chart Web Part to a page I received an error that the Server State Service had not been configured.…"
pubDate: 2010-07-22
updatedDate: 2010-11-05
heroImage: "/heroes/sharepoint-server-state-service.jpg"
category: power-apps
tags:
  - "powershell"
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2010/07/sharepoint-server-state-service.html
---

After adding the SharePoint 2010 Chart Web Part to a page I received an error that the Server State Service had not been configured.  Apparently this service is not installed unless you do the simple SharePoint install or use the service setup wizard (which you should never use).  This service application is also used for InfoPath forms services and some of the Visio services which are not set up to use Silverlight.  
  
After reviewing the Central Administration console I soon realized this service application cannot be created in the UI so I lookup up the article to use PowerShell, here it is: <http://technet.microsoft.com/en-us/library/ee704548.aspx>  
  
To create the service open a SharePoint PowerShell command windows from **Start -> Microsoft SharePoint 2010 Products -> SharePoint 2010 Management Shell**  
Here are the three basic commands you will need to create the service application and associated database.  
  

```
$serviceApp = New-SPStateServiceApplication -Name "<StateServiceName>"

New-SPStateServiceDatabase -Name "<StateServiceDatabase>" -ServiceApplication $serviceApp

New-SPStateServiceApplicationProxy -Name "<ApplicationProxyName>" -ServiceApplication $serviceApp -DefaultProxyGroup
```

  
Also here is a screenshot of the output I received:  
  
  
After the service was up and running the Chart Web Part started working great.
