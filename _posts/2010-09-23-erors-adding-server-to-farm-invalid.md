---
layout: post
title: Errors Adding a Server to the Farm - Invalid List Template (0x8102007B)
date: '2010-09-23T11:51:00.002-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Administration
- SharePoint 2007
modified_time: '2011-02-21T16:10:30.273-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-613280223095684815
blogger_orig_url: https://www.richardawilson.com/2010/09/erors-adding-server-to-farm-invalid.html
---

**Situation:**
Attempting to run the SharePoint Products and Technology Configuration Wizard on a server to add it into the farm.  Our farm also has customized site and list definitions.

**Problem:**
During the configuration an error was displayed stating that there was an 'Invalid List Template' and to check to logs for more errors.  The Windows Application logs revealed a Event 104 error with the details showing a System.Runtime.InteropServices.COMException error which also identified an Invalid List Template as well the error code, 0x8102007B.

**Fix:**
Run the SharePoint Products and Technology Configuration Wizard on the machine you attempted to add and remove it from the SharePoint farm.  (This is done because the Invalid List Template error does not cause the wizard to roll back the installation it just leaves a semi-broken installation in place.)

Log into a machine already attached to the SharePoint farm and navigate to the following directory.

C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\12\TEMPLATE\1033\XML

Copy all the files located in this directory and past them into the same directory in the server you are attempting to add to the farm.

Run the SharePoint Products and Technology Configuration Wizard again.

