---
layout: post
title: SharePoint Event ID 6481 Fix
date: '2010-05-17T13:41:00.001-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Administration
- SharePoint 2007
modified_time: '2011-02-21T16:12:11.684-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1557005538897140647
blogger_orig_url: https://www.richardawilson.com/2010/05/sharepoint-event-id-6481-fix.html
---

**Event  Properties:**

System
- Provider
[ Name] Office SharePoint Server
- EventID 6481
[ Qualifiers] 0
Level 2
Task 1328
Keywords 0x80000000000000
- TimeCreated
[ SystemTime] 2010-05-13T17:11:13.000000000Z
EventRecordID 50233
Channel Application
Computer <>
Security

**Details:**
Microsoft.Office.Server.Search.Administration.SearchDataAccessServiceInstance (ae360320-4426-488b-9757-844f84dd7904).

Reason: An update conflict has occurred, and you must re-try this action. The object SearchDataAccessServiceInstance Parent=SPServer Name=<> is being updated by <>\<>, in the OWSTIMER process, on machine <>. View the tracing log for more information about the conflict.

Techinal Support Details:

Microsoft.SharePoint.Administration.SPUpdatedConcurrencyException: An update conflict has occurred, and you must re-try this action. The object SearchDataAccessServiceInstance Parent=SPServer Name=<> is being updated by <>\<>er, in the OWSTIMER process, on machine <>. View the tracing log for more information about the conflict.

at Microsoft.SharePoint.Administration.SPConfigurationDatabase.StoreObject(SPPersistedObject obj, Boolean storeClassIfNecessary, Boolean ensure)
at Microsoft.SharePoint.Administration.SPConfigurationDatabase.PutObject(SPPersistedObject obj, Boolean ensure)
at Microsoft.SharePoint.Administration.SPPersistedObject.Update()
at Microsoft.SharePoint.Administration.SPServiceInstance.Update()
at Microsoft.Office.Server.Search.Administration.SearchDataAccessServiceInstance.Synchronize(Boolean bCalledFromSSI)
at Microsoft.Office.Server.Administration.ApplicationServerJob.ProvisionLocalSharedServiceInstances(Boolean isAdministrationServiceJob)

**The Fix:**

[http://support.microsoft.com/kb/939308](http://support.microsoft.com/kb/939308)

