---
layout: post
title: SharePoint Server State Service
date: '2010-07-22T11:36:00.002-04:00'
author: Rick Wilson
tags:
- PowerShell
- SharePoint 2010
modified_time: '2010-11-05T16:52:10.148-04:00'
thumbnail: http://2.bp.blogspot.com/_mr9BzRLR2GQ/TEhkrav-snI/AAAAAAAAFCk/-tIzZxtEOyg/s72-c/New+Picture.bmp
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1696792891500152574
blogger_orig_url: https://www.richardawilson.com/2010/07/sharepoint-server-state-service.html
---

After adding the SharePoint 2010 Chart Web Part to a page I received an error that the Server State Service had not been configured.  Apparently this service is not installed unless you do the simple SharePoint install or use the service setup wizard (which you should never use).  This service application is also used for InfoPath forms services and some of the Visio services which are not set up to use Silverlight.

After reviewing the Central Administration console I soon realized this service application cannot be created in the UI so I lookup up the article to use PowerShell, here it is: [http://technet.microsoft.com/en-us/library/ee704548.aspx](http://technet.microsoft.com/en-us/library/ee704548.aspx)

To create the service open a SharePoint PowerShell command windows from **Start -> Microsoft SharePoint 2010 Products -> SharePoint 2010 Management Shell**
Here are the three basic commands you will need to create the service application and associated database.

    ```$serviceApp = New-SPStateServiceApplication -Name "<StateServiceName>"
    
    New-SPStateServiceDatabase -Name "<StateServiceDatabase>" -ServiceApplication $serviceApp
    
    New-SPStateServiceApplicationProxy -Name "<ApplicationProxyName>" -ServiceApplication $serviceApp -DefaultProxyGroup
    ```

Also here is a screenshot of the output I received:

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TEhkrav-snI/AAAAAAAAFCk/-tIzZxtEOyg/s400/New+Picture.bmp)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/TEhkrav-snI/AAAAAAAAFCk/-tIzZxtEOyg/s1600/New+Picture.bmp)

After the service was up and running the Chart Web Part started working great.

