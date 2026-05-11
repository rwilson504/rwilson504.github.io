---
title: "SharePoint Documents Grid Error in Dynamics CRM"
description: "After setting up Server based authentication between SharePoint and Dynamics on several instances we were having issues on certain instances where users would attempt to access the Document grid…"
pubDate: 2019-04-06
category: power-apps
tags:
  - "authentication"
  - "crm"
  - "dynamics"
  - "sharepoint"
draft: false
originalBloggerUrl: /2019/04/sharepoint-documents-grid-error-in.html
---

After setting up Server based authentication between SharePoint and Dynamics on several instances we were having issues on certain instances where users would attempt to access the Document grid within CRM and would receive the following error "You don't have permissions to view files in this location. Contact your Microsoft OneDrive owner or SharePoint administrator for access."  The grid ribbon buttons still loaded and if we clicked on the Open Location button SharePoint would open with all the files displaying which told us that the user had the required permissions.  
  
After troubleshooting with a Microsoft tech for a few hours we concluded that the fix was populating the SharePoint Email Address field on the User record for each user within CRM.  Another important thing to note here is that we were using Azure AD account which had an account name of rick@ad.test.com but the email address was rick@test.com (no ad in the domain name).  I had previously found the articles below which gave me the idea that it might be the SharePoint Email Address but i had been using my full domain account rick@ad.test.com and it turned out it needed to be the email address rick@test.com  
  
To rectify the issue on our environments we added the SharePoint Email Field field to the form.  We then created a workflow to copy the Primary Email Address into the SharePoint Email Address field when a user is Created or the Primary Email Address is changed.  
  
Finally one thing still bothers me about all this, the fact that some environments required populating this field while other didn't.  The techs at Microsoft were unable to give a reason for this.  
  
[Troubleshooting server-based authentication](https://docs.microsoft.com/en-us/previous-versions/dynamicscrm-2016/administering-dynamics-365/dn946906%28v%3dcrm.8%29)  
  
[Configure server-based authentication with Microsoft Dynamics 365 (on-premises) and SharePoint on-premises](https://docs.microsoft.com/en-us/previous-versions/dynamicscrm-2016/administering-dynamics-365/dn949332(v=crm.8))
