---
title: "Refresh ISV/WebResource after CRM 2013/2015/2016 Save Event"
description: "I had a Web Resource page which needed to refresh a jqgrid on it after some fields on a CRM form were updated and record was saved."
pubDate: 2016-04-07
category: power-apps
tags:
  - "crm"
  - "isv"
  - "javascript"
  - "web-resources"
draft: false
originalBloggerUrl: /2016/04/refresh-isvwebresource-after-crm.html
---

I had a Web Resource page which needed to refresh a jqgrid on it after some fields on a CRM form were updated and record was saved. In order to do this a ran a watcher to check to see if the modified date of the record had changed if so I ran the code to update the grid. This code is on the actual Web Resource page not the form JS. Also a quick note you may want to run another watcher to make sure window.parent.Xrm.Page is not null before you run this code.

```
//set the initial modified on date
var prevModifedOn = window.parent.Xrm.Page.getAttribute('modifiedon').getValue();

var xrmPageWatcher = window.setInterval(function () {
    //check to see if the date is modified, convert to string since JS doesn't know how to convert the CRM date time to a datetime object
    if (window.parent.Xrm.Page.getAttribute('modifiedon').getValue().toString() != prevModifedOn.toString()) {
    //update the previous data time so we can detect another save
    prevModifedOn = window.parent.Xrm.Page.getAttribute('modifiedon').getValue();
    //refresh our JQ grid or do whatever else you want like refresh the whole web resource etc.
    $("#grid").jqGrid('setGridParam', { data: awardsDS.generateDataTable(true) }).trigger('reloadGrid');           
    }            
}, 500);
```
