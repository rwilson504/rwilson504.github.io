---
layout: post
title: Get SPUser Information for the Document Creator
date: '2009-09-01T17:15:00.003-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Development
modified_time: '2009-09-01T17:57:24.288-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-620551918983563953
blogger_orig_url: https://www.richardawilson.com/2009/09/get-spuser-information-for-document.html
---

While working on creating a SharePoint 2007 event handler I needed to get the login name for the creator of the document I was trying to update. This is the code I snagged from a blog article which worked.

    SPSite oSite = new SPSite("Your site URL");
    SPList oList = oSite.OpenWeb().Lists["Your list name"];
    SPListItem oItem = oList.GetItemById("Item ID");
    string userValue = oItem["Created By"].ToString();
    int index = userValue.Index Of(';');
    int id = Int32.Parse(userValue.Substring(0, index));
    SPUser itemCreator = oSite.OpenWeb().SiteUsers.GetByID(id);  
    ```

After using that information I could then call:

    itemCreator.LoginName.ToString()  
    ```

Which produces the users login name in the following format "DOMAIN\User".

