---
title: "Navigate to the Document Associate Grid View From Record"
description: "This will allow you to navigate to the Documents Associated Grid view form a button in the main records ribbon. This currently works for Dynamics 9.0 and 9.1 Online."
pubDate: 2019-01-29
category: power-apps
tags:
  - "dynamics"
  - "ribbon"
  - "sharepoint"
draft: false
originalBloggerUrl: /2019/01/navigate-to-document-associate-grid.html
---

This will allow you to navigate to the Documents Associated Grid view form a button in the main records ribbon.  This currently works for Dynamics 9.0 and 9.1 Online.  Some of the previous versions used navDocument instead of navSPDocuments.  
  
-Create a new ribbon button called DOCUMENTS  
-Create a WebResource with a javascript function, something like this  
  
function navigateToSharePointDocuments() {  
 Xrm.Page.ui.navigation.items.get("navSPDocuments").setFocus();  
  };  
  
-From the new button call the javascript function.
