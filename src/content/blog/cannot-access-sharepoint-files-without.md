---
title: "Cannot Access SharePoint Files Without Visitor Access in Dynamics CRM Documents Grid"
description: "Recently while building a system which synchronized Dynamics permissions to SharePoint we came upon an error which caused the SharePoint Document grid to tell us that we did not have the correct…"
pubDate: 2019-04-06
category: power-apps
tags:
  - "dynamics"
  - "sharepoint"
  - "crm"
  - "security"
draft: false
originalBloggerUrl: /2019/04/cannot-access-sharepoint-files-without.html
---

Recently while building a system which synchronized Dynamics permissions to SharePoint we came upon an error which caused the SharePoint Document grid to tell us that we did not have the correct permissions to access the files.  Our code was creating SharePoint document libraries with their inheritance broken, and then synchronizing the security.  When we viewed the document libraries in SharePoint it appears the users had all the permissions they needed but upon opening the Documents grid in Dynamics CRM we would receive an error.  What we found was that the users needed to have at least read access to the root SharePoint site.  After adding the users into the site Visitors group the grid starting showing users the files they had access to.
