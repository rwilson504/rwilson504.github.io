---
layout: post
title: Reset Default Org for CRM Users
date: '2013-09-24T13:48:00.000-04:00'
author: Rick Wilson
tags:
- CRM 2011
- CRM 4.0
modified_time: '2013-09-24T13:58:35.052-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8790920819030501715
blogger_orig_url: https://www.richardawilson.com/2013/09/reset-default-org-for-crm-users.html
---

The script below will change the default org for users.  This can be helpful if you have disabled the original default org and users are now getting the crm error that the organization has been disabled.  Just change the @NewOrgName value to the value of your database name without the _MSCRM suffix.

USE MSCRM_Config
DECLARE @NewOrgName VARCHAR(64) 
SET @NewOrgName = 'DefenseReadyUM'                                                                       

UPDATE [MSCRM_CONFIG].[dbo].[SystemUser] SET [DefaultOrganizationId] = 
(SELECT [Id] FROM [MSCRM_CONFIG].[dbo].[Organization] WHERE [DatabaseName] = @NewOrgName + '_MSCRM') 
WHERE EXISTS (SELECT [Id] FROM [MSCRM_CONFIG].[dbo].[Organization] WHERE [Id] = [MSCRM_CONFIG].[dbo].[SystemUser].[DefaultOrganizationId])

