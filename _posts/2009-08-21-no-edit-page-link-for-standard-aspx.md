---
layout: post
title: No "Edit Page" link for standard aspx page in SharePoint
date: '2009-08-21T16:43:00.001-04:00'
author: Rick Wilson
tags:
- SharePoint 2007
modified_time: '2009-09-01T17:58:05.046-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6894054513922595387
blogger_orig_url: https://www.richardawilson.com/2009/08/no-edit-page-link-for-standard-aspx.html
---

Many times user create aspx pages within SharePoint designer and then add web part zones to them so they can add data. There are several problems with this, the first being that you will never get a link for "Edit Page". This means you have to open the page in SharePoint designer every time you want to do a modification.

There is a way to get around this. Add the follow to the end of the url : ?PageView=Shared&ToolPaneView=2

**Example**: [www.sharepoint.com/sites/Test/Documents/newdoc.aspx?PageView=Shared&ToolPaneView=2](http://www.blogger.com/www.sharepoint.com/sites/Test/Documents/newdoc.aspx?PageView=Shared&amp;ToolPaneView=2)

You will now be able to see the Edit drop down on all the web parts although it may look a little wonky.

