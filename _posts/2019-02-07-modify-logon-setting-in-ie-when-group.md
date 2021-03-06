---
layout: post
title: Modify Logon Setting in IE When Group Policy Doesn't Allow It
date: '2019-02-07T09:42:00.003-05:00'
author: Rick Wilson
tags:
- Group Policy
- Active Directory
- Security
- Internet Explorer
modified_time: '2019-02-07T10:31:39.996-05:00'
thumbnail: https://1.bp.blogspot.com/-9toRk0PJNx8/XFxBXWCXO5I/AAAAAAABC1A/NqxNqkjmr5svstYghlCEK7DSTRAB1a8twCEwYBhgL/s72-c/logonSettings1.PNG
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6624308321275108395
blogger_orig_url: https://www.richardawilson.com/2019/02/modify-logon-setting-in-ie-when-group.html
---

Recently I needed to "Prompt for user name and password" when logging into my Local Intranet zone so that I could test as multiple users.  A colleague of mine made me aware of the registry settings for these option so you can modify.  These settings will be overwritten next time Group Policy is applied but they provide a good temporary workaround.

[![](https://1.bp.blogspot.com/-9toRk0PJNx8/XFxBXWCXO5I/AAAAAAABC1A/NqxNqkjmr5svstYghlCEK7DSTRAB1a8twCEwYBhgL/s320/logonSettings1.PNG)](https://1.bp.blogspot.com/-9toRk0PJNx8/XFxBXWCXO5I/AAAAAAABC1A/NqxNqkjmr5svstYghlCEK7DSTRAB1a8twCEwYBhgL/s1600/logonSettings1.PNG)Default Settings for Local Intranet Zone Locked OutThe specific key for the Local Intranet Zone is located at HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1. The key name is 1A00

[![](https://4.bp.blogspot.com/-SPUR7PMkvNA/XFxBXc0jcSI/AAAAAAABC1M/XOZ-EPOtLpcNANxis5QfturGIWYSgtO-ACEwYBhgL/s400/logonSettings2.PNG)](https://4.bp.blogspot.com/-SPUR7PMkvNA/XFxBXc0jcSI/AAAAAAABC1M/XOZ-EPOtLpcNANxis5QfturGIWYSgtO-ACEwYBhgL/s1600/logonSettings2.PNG)HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1\1A00
Just update this value to 20000 and your setting will now be switched to "Prompt for user name and password"

[![](https://1.bp.blogspot.com/-F9gWyyIRznY/XFxBXlfYSlI/AAAAAAABC1Q/bnUPvEUaxPQ8vULfnogqFiO34KlaEhDbQCEwYBhgL/s320/logonSettings3.PNG)](https://1.bp.blogspot.com/-F9gWyyIRznY/XFxBXlfYSlI/AAAAAAABC1Q/bnUPvEUaxPQ8vULfnogqFiO34KlaEhDbQCEwYBhgL/s1600/logonSettings3.PNG)Prompt for user name and password is not selected.

Here is the listing of the other Zones:

    Value    Setting
       ------------------------------
       0        My Computer
       1        Local Intranet Zone
       2        Trusted sites Zone
       3        Internet Zone
       4        Restricted Sites Zone

Here is the listing of all the Logon settings you can use:

    Value    Setting
       ---------------------------------------------------------------
       0x00000000 Automatically logon with current username and password
       0x00010000 Prompt for user name and password
       0x00020000 Automatic logon only in the Intranet zone
       0x00030000 Anonymous logon

Also here is a powershell script which first makes sure Powershell is running as an administrator then sets the value for the Local Intranet Zone..

    
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
    
    Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1' -Name '1A00' -value '0x00010000'
    
    

These settings tables were taken from the Microsoft support article describing these settings which can be found here: [https://support.microsoft.com/en-us/help/182569/internet-explorer-security-zones-registry-entries-for-advanced-users](https://support.microsoft.com/en-us/help/182569/internet-explorer-security-zones-registry-entries-for-advanced-users)

