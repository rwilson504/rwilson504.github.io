---
title: "No \"Edit Page\" link for standard aspx page in SharePoint"
description: "Many times user create aspx pages within SharePoint designer and then add web part zones to them so they can add data."
pubDate: 2009-08-21
updatedDate: 2009-09-01
category: power-apps
tags:
  - "sharepoint-2007"
draft: false
originalBloggerUrl: /2009/08/no-edit-page-link-for-standard-aspx.html
---

Many times user create aspx pages within SharePoint designer and then add web part zones to them so they can add data. There are several problems with this, the first being that you will never get a link for "Edit Page". This means you have to open the page in SharePoint designer every time you want to do a modification.  
  
There is a way to get around this. Add the follow to the end of the url : ?PageView=Shared&ToolPaneView=2  
  
**Example**: [www.sharepoint.com/sites/Test/Documents/newdoc.aspx?PageView=Shared&ToolPaneView=2](http://www.blogger.com/www.sharepoint.com/sites/Test/Documents/newdoc.aspx?PageView=Shared&ToolPaneView=2)  
  
You will now be able to see the Edit drop down on all the web parts although it may look a little wonky.
