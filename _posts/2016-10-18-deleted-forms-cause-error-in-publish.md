---
layout: post
title: Deleted Forms Cause Error in Publish
date: '2016-10-18T13:52:00.000-04:00'
author: Rick Wilson
tags:
- Error
- CRM
modified_time: '2016-10-18T13:53:15.554-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-936374928895213418
blogger_orig_url: https://www.richardawilson.com/2016/10/deleted-forms-cause-error-in-publish.html
---

During recent CRM upgrades I started getting the following error on publish.  

    systemform With Id = {Guid} Does Not Exist
    

After looking through the database it was discovered that there were upgraded forms that had been marked with the component state of deleted which were causing the error.  Deleting those rows marked with the component state of 2 (deleted) allowed for publishing.  

*** Disclaimer: Modifying CRM data directly can void your warranty.  Use at your own risk. ***

    delete from systemformbase where componentstate = 2
    

