---
layout: post
title: Navigate to the Document Associate Grid View From Record
date: '2019-01-29T12:05:00.002-05:00'
author: Rick Wilson
tags:
- Ribbon
- Dynamics
- SharePoint
modified_time: '2019-01-29T12:05:32.950-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4022858223328615712
blogger_orig_url: https://www.richardawilson.com/2019/01/navigate-to-document-associate-grid.html
---

This will allow you to navigate to the Documents Associated Grid view form a button in the main records ribbon.  This currently works for Dynamics 9.0 and 9.1 Online.  Some of the previous versions used navDocument instead of navSPDocuments.

-Create a new ribbon button called DOCUMENTS
-Create a WebResource with a javascript function, something like this

function navigateToSharePointDocuments() {
Xrm.Page.ui.navigation.items.get("navSPDocuments").setFocus();
  };

-From the new button call the javascript function.

