---
title: "User Rights Issues in CRM using JavaScript"
description: "I needed to find a way to determine if a user did not exist in CRM or did not have any rights. The devError page is available in both CRM 4 and 2011 and returns the same errors.…"
pubDate: 2011-05-25
category: power-apps
tags:
  - "crm-2011"
  - "javascript"
  - "permissions"
draft: false
originalBloggerUrl: /2011/05/user-rights-issues-in-crm-using.html
---

I needed to find a way to determine if a user did not exist in CRM or did not have any rights. The devError page is available in both CRM 4 and 2011 and returns the same errors. Also for this to work correctly the user must be in the same domain as CRM and the CRM site url must be in trusted or local intranet sites and passing the authentication automatically.  
  

```
                    $.ajax({
                                            url: data.serverurl + '/_common/error/devError.aspx',
                                            success: function (data) {
                                                if ($('div pre:contains("[CrmException: No Microsoft Dynamics CRM user exists with the specified domain name and user ID")', data).length > 0)
                                                { accessError = true; }
                                                else if ($('div pre:contains("[CrmException: The user is not assigned any privileges.")', data).length > 0)
                                                { accessError = true; }
                                            },
                                            async: false
                                        });
```
