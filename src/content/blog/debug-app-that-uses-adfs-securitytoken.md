---
title: "Debug App that Uses ADFS: The SecurityToken is rejected because the validation time is out of range"
description: "When debugging an app which connected to CRM using IFD connection I kept getting the following in the trace log.…"
pubDate: 2014-04-21
category: power-apps
tags:
  - "adfs-2"
  - "authentication"
draft: false
originalBloggerUrl: /2014/04/debug-app-that-uses-adfs-securitytoken.html
---

When debugging an app which connected to CRM using IFD connection I kept getting the following in the trace log.
</StackTrace>
<ExceptionString>Microsoft.IdentityModel.Tokens.SecurityTokenExpiredException: ID4255:
The SecurityToken is rejected because the validation time is out of range.
ValidTo: '4/21/2014 4:25:11 PM'
ValidFrom: '4/21/2014 3:25:11 PM'
Current time: '4/21/2014 5:55:13 PM'
</ExceptionString>
The issue was that debugging the call caused the time the ticket was generated to be off. In order to fix this I utilized a property that allows tickets to be off by a certain amount of time. The PowerShell command below will allow tickets to be out of the time range by 5 minutes.
Add-PSSnaping Microsoft.Adfs.PowerShell
Set-ADFSRelyingPartyTrust -NotBeforeSkew "5" -targetname "Relying Party Trust Display Name"
