---
title: "Reset Default Org for CRM Users"
description: "The script below will change the default org for users. This can be helpful if you have disabled the original default org and users are now getting the crm error that the organization has been…"
pubDate: 2013-09-24
category: power-apps
tags:
  - "crm-2011"
  - "crm-4"
draft: false
originalBloggerUrl: /2013/09/reset-default-org-for-crm-users.html
---

The script below will change the default org for users.  This can be helpful if you have disabled the original default org and users are now getting the crm error that the organization has been disabled.  Just change the @NewOrgName value to the value of your database name without the \_MSCRM suffix.  
  

USE MSCRM\_Config  
DECLARE @NewOrgName VARCHAR(64)   
SET @NewOrgName = 'DefenseReadyUM'   
  
UPDATE [MSCRM\_CONFIG].[dbo].[SystemUser] SET [DefaultOrganizationId] =   
(SELECT [Id] FROM [MSCRM\_CONFIG].[dbo].[Organization] WHERE [DatabaseName] = @NewOrgName + '\_MSCRM')   
WHERE EXISTS (SELECT [Id] FROM [MSCRM\_CONFIG].[dbo].[Organization] WHERE [Id] = [MSCRM\_CONFIG].[dbo].[SystemUser].[DefaultOrganizationId])
