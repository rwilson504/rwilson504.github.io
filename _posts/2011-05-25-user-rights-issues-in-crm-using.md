---
layout: post
title: User Rights Issues in CRM using JavaScript
date: '2011-05-25T16:35:00.000-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Javascript
- Permissions
modified_time: '2011-05-25T16:35:48.267-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4161971783088217378
blogger_orig_url: https://www.richardawilson.com/2011/05/user-rights-issues-in-crm-using.html
---

I needed to find a way to determine if a user did not exist in CRM or did not have any rights.  The devError page is available in both CRM 4 and 2011 and returns the same errors.  Also for this to work correctly the user must be in the same domain as CRM and the CRM site url must be in trusted or local intranet sites and passing the authentication automatically.

    ```                    $.ajax({
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

