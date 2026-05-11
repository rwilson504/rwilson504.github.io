---
title: "Where did my Collaboration Portal go in SharePoint 2010?"
description: "When I went to create my first site collection in SharePoint 2010 I was surprised to find there was no site template for the Collaboration Portal."
pubDate: 2010-07-20
updatedDate: 2010-11-05
category: power-apps
tags:
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2010/07/where-did-my-collaboration-portal-go-in.html
---

When I went to create my first site collection in SharePoint 2010 I was surprised to find there was no site template for the Collaboration Portal.  Apparently it is still there but not on the list of site templates.  If you would like to use the template you will need to create the site using PowerShell.  Below is the command to create a site collection using the Collaboration Portal template.  
  

```
New-SPSite -Url http://<url of Site> -OwnerAlias <domain>\<user> -Name “The Wils” -Template SPSPORTAL#0
```

  
Sources:  
<http://technicallead.wordpress.com/2010/05/11/create-collaboration-portal-using-powershell/> (Where I discovered this information)  
  
<http://www.toddbaginski.com/blog/archive/2009/11/20/which-sharepoint-2010-site-template-is-right-for-me.aspx>(A great article on choosing what site template is best for you and also what the site template IDs are for your PowerShell scripts)
