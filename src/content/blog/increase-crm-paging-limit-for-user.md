---
title: "Increase CRM Paging Limit for User"
description: "Below is an unsupported method for increasing the number of records in each page of a view. This setting is individual to each users."
pubDate: 2014-02-14
updatedDate: 2014-03-05
category: power-apps
tags:
  - "crm-2011"
draft: false
originalBloggerUrl: /2014/02/increase-crm-paging-limit-for-user.html
---

Below is an unsupported method for increasing the number of records in each page of a view.  This setting is individual to each users.  In the case below we are updating it for the user related to the DOMAIN\User account.  This is not recommended for normal user but I find it helpful when I need to add 2000 plugin steps to a solution.  
  
UPDATE US  
SET US.[PagingLimit] = 1000  
FROM [Default\_MSCRM].[dbo].[UserSettings] US  
LEFT JOIN [Default\_MSCRM].[dbo].[SystemUser] SU ON SU.SystemUserId = US.SystemUserId  
WHERE SU.[DomainName] like 'DOMAIN\User'
