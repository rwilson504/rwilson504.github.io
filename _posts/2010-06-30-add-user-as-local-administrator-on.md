---
layout: post
title: Add User As Local Administrator On Domain Controller
date: '2010-06-30T12:07:00.001-04:00'
author: Rick Wilson
tags:
- Active Directory
- SharePoint 2010
modified_time: '2011-02-21T16:12:43.347-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4006151614448824563
blogger_orig_url: https://www.richardawilson.com/2010/06/add-user-as-local-administrator-on.html
---

I recently was settting up a new Microsoft SharePoint 2010 machine and had promoted the machine to a domain controller before creating my SharePoint admin accounts.  I needed to add several of my accounts to the local Administrators group.  Unfortunately after you promote a server to a domain controller you can no longer access the GUI for Local Users and Groups.  Instead I had to use the command line to add the users.

Open a command promt using the "Run as administrator" function and then run the following command.

net localgroup Administrators /add {domain}\{user}

Note: do not include the {} brackets.

