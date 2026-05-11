---
title: "Add User As Local Administrator On Domain Controller"
description: "I recently was settting up a new Microsoft SharePoint 2010 machine and had promoted the machine to a domain controller before creating my SharePoint admin accounts."
pubDate: 2010-06-30
updatedDate: 2011-02-21
category: power-apps
tags:
  - "active-directory"
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2010/06/add-user-as-local-administrator-on.html
---

I recently was settting up a new Microsoft SharePoint 2010 machine and had promoted the machine to a domain controller before creating my SharePoint admin accounts.  I needed to add several of my accounts to the local Administrators group.  Unfortunately after you promote a server to a domain controller you can no longer access the GUI for Local Users and Groups.  Instead I had to use the command line to add the users.  
  
Open a command promt using the "Run as administrator" function and then run the following command.  
  
net localgroup Administrators /add {domain}\{user}  
  
Note: do not include the {} brackets.
