---
layout: post
title: CRM 4.0 Development Tips
date: '2009-08-17T12:15:00.001-04:00'
author: Rick Wilson
tags:
- Development
- CRM 4.0
modified_time: '2009-09-01T18:01:04.385-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3458895476154102905
blogger_orig_url: https://www.richardawilson.com/2009/08/crm-40-development-tips.html
---

Here are a list of items to think about when developing.

Entities:
-Add an informaiton bar to the form form. ([Click Here for Instructions](http://mscrmtools.blogspot.com/2009/06/add-information-message-in-crm-form.html))
-Update SiteMap Description field. These descriptions are displayed in the Outlook client.(

Workflows
-If you re-deploye a custom workflow activity dll you may need to delete and recreate those steps in the workflows which were using it.
-Web Services: When you are in the Execute method of a workflow you do not need to specify all the connection items to connect to the CRM web services. All that information is already there you just need to create a new instance of the service. ([Example](http://techblog.ranjanbanerji.com/post/2008/08/22/Microsoft-Dynamics-CRM-40-Editing-Entities-in-Workflow.aspx))

Other:
[CRM Tools Blog](http://mscrmtools.blogspot.com/): This site offers a collection of tools that I find very useful and time saving when developing in CRM.

