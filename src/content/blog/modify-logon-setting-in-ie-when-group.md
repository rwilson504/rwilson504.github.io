---
title: "Modify Logon Setting in IE When Group Policy Doesn't Allow It"
description: "Recently I needed to \"Prompt for user name and password\" when logging into my Local Intranet zone so that I could test as multiple users."
pubDate: 2019-02-07
heroImage: "/heroes/modify-logon-setting-in-ie-when-group.png"
category: misc
tags:
  - "active-directory"
  - "group-policy"
  - "internet-explorer"
  - "security"
draft: false
originalBloggerUrl: /2019/02/modify-logon-setting-in-ie-when-group.html
---

Recently I needed to "Prompt for user name and password" when logging into my Local Intranet zone so that I could test as multiple users.  A colleague of mine made me aware of the registry settings for these option so you can modify.  These settings will be overwritten next time Group Policy is applied but they provide a good temporary workaround.  
  

|  |
| --- |
|  |
| Default Settings for Local Intranet Zone Locked Out |

The specific key for the Local Intranet Zone is located at HKEY\_LOCAL\_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1. The key name is 1A00  
  

|  |
| --- |
|  |
| HKEY\_LOCAL\_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1\1A00 |

  
Just update this value to 20000 and your setting will now be switched to "Prompt for user name and password"  
  

|  |
| --- |
|  |
| Prompt for user name and password is not selected. |

  
  
  
  
Here is the listing of the other Zones:  
  

```
Value    Setting
   ------------------------------
   0        My Computer
   1        Local Intranet Zone
   2        Trusted sites Zone
   3        Internet Zone
   4        Restricted Sites Zone
```

  
  
Here is the listing of all the Logon settings you can use:  

```
Value    Setting
   ---------------------------------------------------------------
   0x00000000 Automatically logon with current username and password
   0x00010000 Prompt for user name and password
   0x00020000 Automatic logon only in the Intranet zone
   0x00030000 Anonymous logon
```

  
  
Also here is a powershell script which first makes sure Powershell is running as an administrator then sets the value for the Local Intranet Zone..  
  

```
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }  

Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1' -Name '1A00' -value '0x00010000'
```

  
  
These settings tables were taken from the Microsoft support article describing these settings which can be found here: <https://support.microsoft.com/en-us/help/182569/internet-explorer-security-zones-registry-entries-for-advanced-users>
