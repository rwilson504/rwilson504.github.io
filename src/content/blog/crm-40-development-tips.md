---
title: "CRM 4.0 Development Tips"
description: "Here are a list of items to think about when developing."
pubDate: 2009-08-17
updatedDate: 2009-09-01
category: power-apps
tags:
  - "crm-4"
  - "development"
draft: false
originalBloggerUrl: /2009/08/crm-40-development-tips.html
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
