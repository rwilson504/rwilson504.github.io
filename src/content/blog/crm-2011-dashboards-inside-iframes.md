---
title: "CRM 2011 Dashboards Inside IFrames"
description: "If you are going to place CRM 2011 Dashboards within an IFrame make sure your URL points to:"
pubDate: 2012-03-16
heroImage: "/heroes/crm-2011-dashboards-inside-iframes.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "crm-2011"
draft: false
originalBloggerUrl: /2012/03/crm-2011-dashboards-inside-iframes.html
---

If you are going to place CRM 2011 Dashboards within an IFrame make sure your URL points to:  
  
/dashboards/dashboard.aspx  
  
and not  
  
/workplace/home\_dashboards.aspx  
  
using the home\_dashboards.aspx may cause your charts to just sit with the loading icon displayed.

To get the url of a dashboard right click on the name of the dashboard and click “Copy a Link”
