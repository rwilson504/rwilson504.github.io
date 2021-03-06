---
layout: post
title: PowerShell Script for Delete SharePoint Designer Cache
date: '2010-07-09T16:07:00.003-04:00'
author: Rick Wilson
tags:
- PowerShell
- SharePoint 2010
modified_time: '2010-11-05T16:50:34.228-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-219282789585270469
blogger_orig_url: https://www.richardawilson.com/2010/07/powershell-script-for-delete-sharepoint.html
---

I have developed several workflow activities for use within SharePoint designer.  Every time a SharePoint Designerworkflow is opened a copy of the deployed DLL is downloaded into the WebSiteCache folder in the user profile.  If the DLL is redeployed and the cache is not cleared out errors will be detected when attempting to re-save the workflow.  In order to fix this I have created a simple PowerShell script that will determine the location of the cache directory and delete it.  It will also detect if SharePoint designer is currently running.  It is required that Designer be closed in order to delete the cache directory.

```# This script will determine the current user and delete the
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

