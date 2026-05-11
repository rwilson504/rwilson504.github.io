---
title: "Get SPUser Information for the Document Creator"
description: "While working on creating a SharePoint 2007 event handler I needed to get the login name for the creator of the document I was trying to update."
pubDate: 2009-09-01
category: power-apps
tags:
  - "sharepoint-2007-development"
draft: false
originalBloggerUrl: /2009/09/get-spuser-information-for-document.html
---

While working on creating a SharePoint 2007 event handler I needed to get the login name for the creator of the document I was trying to update. This is the code I snagged from a blog article which worked.  
  

```
SPSite oSite = new SPSite("Your site URL");
SPList oList = oSite.OpenWeb().Lists["Your list name"];
SPListItem oItem = oList.GetItemById("Item ID");
string userValue = oItem["Created By"].ToString();
int index = userValue.Index Of(';');
int id = Int32.Parse(userValue.Substring(0, index));
SPUser itemCreator = oSite.OpenWeb().SiteUsers.GetByID(id);
```

  
After using that information I could then call:  
  

```
itemCreator.LoginName.ToString()
```

  
Which produces the users login name in the following format "DOMAIN\User".
