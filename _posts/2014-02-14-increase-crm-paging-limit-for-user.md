---
layout: post
title: Increase CRM Paging Limit for User
date: '2014-02-14T12:39:00.000-05:00'
author: Rick Wilson
tags:
- CRM 2011
modified_time: '2014-03-05T11:31:07.481-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1343819484846655666
blogger_orig_url: https://www.richardawilson.com/2014/02/increase-crm-paging-limit-for-user.html
---

Below is an unsupported method for increasing the number of records in each page of a view.  This setting is individual to each users.  In the case below we are updating it for the user related to the DOMAIN\User account.  This is not recommended for normal user but I find it helpful when I need to add 2000 plugin steps to a solution.

UPDATE US
SET US.[PagingLimit] = 1000
FROM [Default_MSCRM].[dbo].[UserSettings] US
LEFT JOIN [Default_MSCRM].[dbo].[SystemUser] SU ON SU.SystemUserId = US.SystemUserId
WHERE SU.[DomainName] like 'DOMAIN\User'

