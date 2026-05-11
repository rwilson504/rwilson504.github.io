---
title: "Postpone CRM Rollup Database Updates"
description: "Update Rollup 17 for CRM 2011 creates new indexes for database tables when installed. Because of this the install can take several hours.…"
pubDate: 2014-11-25
heroImage: "/heroes/postpone-crm-rollup-database-updates.png"
heroImageAlt: "AutomaticallyInstallDatabaseUpdates"
category: power-apps
tags:
  - "crm-2011"
  - "sql"
  - "update-rollup"
draft: false
originalBloggerUrl: /2014/11/postpone-crm-rollup-database-updates.html
---

Update Rollup 17 for CRM 2011 creates new indexes for database tables when installed.  Because of this the install can take several hours.  In the case that you have a multitenant environment with separate hardware for each org you may want to defer rolling out database updates to all the orgs so that you can install the update rollup per sever/org pair.

To disable the automatic update you can use PowerShell or update the MSCRM\_CONFIG database as shown below.

1. Open **SQL Server Management Studio**
2. Expand the **MSCRM\_CONFIG** database
3. Right Click the **dbo.DeploymentProperties** table and select **Edit Top 200 Rows**
4. Find the **AutomaticallyInstallDatabaseUpdates** key and update the **BitColumn** from True to **False**

After installing the binary files for UR17 on each server you will then need to go into the CRM Deployment Manager and manually apply the updates for the organization.

1. Start **Microsoft Dynamics CRM Deployment Manager**
2. **Click** on **Organizations**
3. **Right click** on the **organization** you wish to update and select the **Update** option.
