---
title: "Deleted Forms Cause Error in Publish"
description: "During recent CRM upgrades I started getting the following error on publish."
pubDate: 2016-10-18
category: power-apps
tags:
  - "crm"
  - "error"
draft: false
originalBloggerUrl: /2016/10/deleted-forms-cause-error-in-publish.html
---

During recent CRM upgrades I started getting the following error on publish.
  

```
systemform With Id = {Guid} Does Not Exist
```

After looking through the database it was discovered that there were upgraded forms that had been marked with the component state of deleted which were causing the error.
Deleting those rows marked with the component state of 2 (deleted) allowed for publishing.
  
  
\*\*\* Disclaimer: Modifying CRM data directly can void your warranty. Use at your own risk. \*\*\*
  

```
delete from systemformbase where componentstate = 2
```
