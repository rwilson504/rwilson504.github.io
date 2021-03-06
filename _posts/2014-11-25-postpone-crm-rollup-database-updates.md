---
layout: post
title: Postpone CRM Rollup Database Updates
date: '2014-11-25T11:23:00.001-05:00'
author: Rick Wilson
tags:
- SQL
- CRM 2011
- Update Rollup
modified_time: '2014-11-25T11:29:20.734-05:00'
thumbnail: http://lh3.ggpht.com/-HFa142pPesc/VHSuXjpEyTI/AAAAAAAAMFo/ROAQQNohyw8/s72-c/AutomaticallyInstallDatabaseUpdates_thumb%25255B10%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5486662362725629395
blogger_orig_url: https://www.richardawilson.com/2014/11/postpone-crm-rollup-database-updates.html
---


Update Rollup 17 for CRM 2011 creates new indexes for database tables when installed.  Because of this the install can take several hours.  In the case that you have a multitenant environment with separate hardware for each org you may want to defer rolling out database updates to all the orgs so that you can install the update rollup per sever/org pair.

To disable the automatic update you can use PowerShell or update the MSCRM_CONFIG database as shown below.

1. Open **SQL Server Management Studio**
2. Expand the **MSCRM_CONFIG** database
3. Right Click the **dbo.DeploymentProperties** table and select **Edit Top 200 Rows**
4. Find the **AutomaticallyInstallDatabaseUpdates** key and update the **BitColumn** from True to **False**

[![AutomaticallyInstallDatabaseUpdates](http://lh3.ggpht.com/-HFa142pPesc/VHSuXjpEyTI/AAAAAAAAMFo/ROAQQNohyw8/AutomaticallyInstallDatabaseUpdates_thumb%25255B10%25255D.png?imgmax=800)](http://lh3.ggpht.com/-c08U6fN8lOM/VHSuXI9eRaI/AAAAAAAAMFg/2VbzMLcNwYI/s1600-h/AutomaticallyInstallDatabaseUpdates%25255B14%25255D.png)

After installing the binary files for UR17 on each server you will then need to go into the CRM Deployment Manager and manually apply the updates for the organization.

1. Start **Microsoft Dynamics CRM Deployment Manager**
2. **Click** on **Organizations**
3. **Right click** on the **organization** you wish to update and select the **Update** option.

