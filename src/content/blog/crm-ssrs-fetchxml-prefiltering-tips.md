---
title: "CRM SSRS FetchXml PreFiltering Tips"
description: "I don't do custom SSRS to often but when I do I consonantly have issues pre-filtering FetchXML in SSRS reports.…"
pubDate: 2017-03-16
category: power-apps
tags:
  - "crm"
  - "reports"
  - "ssrs"
draft: false
originalBloggerUrl: /2017/03/crm-ssrs-fetchxml-prefiltering-tips.html
---

I don't do custom SSRS to often but when I do I consonantly have issues pre-filtering FetchXML in SSRS reports.  The items below are what I have found to be the total set of requirements to make sure it works.  
  
Example:  Let's say we have an entity called 'new\_house'.  Below is the FetchXML statement I would use in the data set.  
  

```
<fetch mapping="logical" version="1.0">
 <entity name="new_hosue" enableprefiltering="true" prefilterparametername="CRM_Filterednew_house">
  <all-attributes/> 
</fetch>
```

  
  
  
Here are the steps i usually take to create this fetch.  
  
-Open the query designer and paste in the fetch without the enableprefiltering and prefilterparametername attribute.  
  

```
<fetch mapping="logical" version="1.0">
 <entity name="new_hosue" >
  <all-attributes/> 
</fetch>
```

  
  
-Next add the enableprefiltering="true" attribute then close the dataset.  A new Parameter will automatically be created in your report.  Sometimes SSRS will create the report parameter name correctly but sometimes it will not.   The report parameter MUST have the following naming convention.  If it does not select the properties of the parameters and change it's name.  
  
CRM\_Filtered<entityname>  
  
So in my case it needs to be called CRM\_Filterednew\_house  
  
-Reopen the dataset and update the fetch to include the prefilterparametername attribute  
  

```
<fetch mapping="logical" version="1.0">
 <entity name="new_hosue" enableprefiltering="true" prefilterparametername="CRM_Filterednew_house">
  <all-attributes/> 
</fetch>
```

  
  
  
Final Notes:  
-DO NOT ALIAS the entity you are prefiltering.  If you add the alias it will not work.  You may Alias any Linked Entities.  
-DO NOT RE-UPLOAD your file to the same Report record you created in CRM.  When you do the initial upload of the report the first time a lot of things are saved to this record and are not updated if you just edit the record and upload a new rdl file.
