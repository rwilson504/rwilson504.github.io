---
title: "Web.Config Modification Manager Update"
description: "So this is an update of a solution from Harmjan Greving which was an update from thekid.me.uk which can be used to view, modify, and create web.config modification that will be pushed to all servers…"
pubDate: 2011-06-02
category: misc
tags: []
draft: false
originalBloggerUrl: /2011/06/webconfig-modification-manager-update.html
---

So this is an update of a solution from [Harmjan Greving](http://www.dynasign.nl/blog/?p=14) which was an update from [thekid.me.uk](http://blog.thekid.me.uk/archive/2007/03/24/web-config-modification-manager-for-sharepoint.aspx) which can be used to view, modify, and create web.config modification that will be pushed to all servers within the farm.  
  
The only changes I made from Harmjan's version was to fix some problems when loading modification which contained double quotes.  They were causing the page to load improperly.  Also for the current modification table I added a number field as the first column so that when I'm talking to customers over the phone they can tell me the number of mods or easily reference individual items.  
  
To use it just download the [webconfig.aspx](https://docs.google.com/leaf?id=0BxfAiF_S2j-2MDY2ZDliYWUtODc2NC00YjAwLWI4NDktZjgxNWY4MTU2MmMx&hl=en_US) page. Then drop it in the 12 hive at, C:\Program Files\Common Files\Microsoft Shared\web server extensions\12\TEMPLATE\ADMIN.  
  
The page can be accessed through, http://CA:PORT/\_admin/webconfig.aspx
