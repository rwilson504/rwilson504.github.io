---
title: "PowerShell Script for Delete SharePoint Designer Cache"
description: "I have developed several workflow activities for use within SharePoint designer.…"
pubDate: 2010-07-09
updatedDate: 2010-11-05
category: power-apps
tags:
  - "powershell"
  - "sharepoint-2010"
draft: false
originalBloggerUrl: /2010/07/powershell-script-for-delete-sharepoint.html
---

I have developed several workflow activities for use within SharePoint designer.  Every time a SharePoint Designer workflow is opened a copy of the deployed DLL is downloaded into the WebSiteCache folder in the user profile.  If the DLL is redeployed and the cache is not cleared out errors will be detected when attempting to re-save the workflow.  In order to fix this I have created a simple PowerShell script that will determine the location of the cache directory and delete it.  It will also detect if SharePoint designer is currently running.  It is required that Designer be closed in order to delete the cache directory.  
  

```
# This script will determine the current user and delete the
# WebSiteCache folder which hold temporary data used by SharePoint
# Designer.

if(Get-Process 'SPDESIGN' -ea SilentlyContinue)
{
    "Please close SharePoint Designer before running this script."
}
else
{
    $username = $env:USERNAME
    if (Test-Path C:\Users\$username\AppData\Local\Microsoft\WebsiteCache)
    {
        "Directory Exists Removing Contents for $username"
        Remove-Item C:\Users\$username\AppData\Local\Microsoft\WebsiteCache -force -recurse
        "Done."
    }
    else
    {
        "Directory Does Not Exist for $username"
    }
}
```
