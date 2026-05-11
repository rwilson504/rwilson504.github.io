---
title: "Postpone CRM Rollup Database Updates"
description: "Update Rollup 17 for CRM 2011 creates new indexes for database tables when installed. Because of this the install can take several hours.…"
pubDate: 2014-11-25
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjzmUjIDtrT9ddih-9KZPXnRq7y3IjSvaxAGYUoj4LMoJoXCDvBN1XomJ-4iXbYS7yhFo1onWFRkBZvBZZV0X7DXlwvq80W8y7AEZGhMxAPqIDN_A9G30hdfaD7ki-QFiihXfJ7qmirRdU/?imgmax=800"
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

[![AutomaticallyInstallDatabaseUpdates](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjzmUjIDtrT9ddih-9KZPXnRq7y3IjSvaxAGYUoj4LMoJoXCDvBN1XomJ-4iXbYS7yhFo1onWFRkBZvBZZV0X7DXlwvq80W8y7AEZGhMxAPqIDN_A9G30hdfaD7ki-QFiihXfJ7qmirRdU/?imgmax=800 "AutomaticallyInstallDatabaseUpdates")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjAXKq8fjZB5Z1RBFkFBOx18p6GsXgjUnxsDI9YrGAYB1qg7OJlqxbcgOV-cKBnmLqQtOAyl-B62Rjt2VUq4jXcL52D3ViM0ECmPj1ncfYE505sFiJQPrzXylwo02OpuOziTqgQig1jDaM/s1600-h/AutomaticallyInstallDatabaseUpdates%25255B14%25255D.png)

After installing the binary files for UR17 on each server you will then need to go into the CRM Deployment Manager and manually apply the updates for the organization.

1. Start **Microsoft Dynamics CRM Deployment Manager**
2. **Click** on **Organizations**
3. **Right click** on the **organization** you wish to update and select the **Update** option.
