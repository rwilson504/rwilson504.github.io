---
layout: post
title: Turn on Teams/Skype Meeting Recording and Transcription for Entire Organization
date: '2019-07-08T16:27:00.002-04:00'
author: Rick Wilson
tags: 
modified_time: '2019-07-08T16:33:27.932-04:00'
thumbnail: https://1.bp.blogspot.com/-aubFgbLqM4w/XSOoeQlGDtI/AAAAAAABIc8/XMI2v2RNFvg39GMVEwMmIv4yC4OTOiBjwCLcBGAs/s72-c/TeamsAdminEnableRecordingAndTranscription.PNG
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4198502645720539633
blogger_orig_url: https://www.richardawilson.com/2019/07/turn-on-teamsskype-meeting-recording.html
---

```    <#
    .SYNOPSIS
     Turn on meeting recording and transcription for entire organization
    
    .PREREQUISITES
     Download the Skype for Business Online Connector Module - https://www.microsoft.com/en-us/download/details.aspx?id=39366
    
    .ADDITIONAL RESOURCES
     Teams cloud meeting recording - https://docs.microsoft.com/en-us/microsoftteams/cloud-recording
     Manage Skype for Business Online with Office 365 PowerShell - https://docs.microsoft.com/en-us/office365/enterprise/powershell/manage-skype-for-business-online-with-office-365-powershell
    #>
    
    
    Import-Module SkypeOnlineConnector
    
    # Update this to a user who is a Teams Administrator
    $userName="admin@test.onmicrosoft.com" 
    $message = "Please Login Using Your Office 365 Credentials"
    $credentials = Get-Credential -UserName $userName -Message $message
    $TeamsSession = New-CsOnlineSession -Credential $credentials 
    Import-PSSession $TeamsSession 
    # Turns on recording and transcription for everyone withing the organization
    Set-CsTeamsMeetingPolicy -Identity Global -AllowCloudRecording $true -AllowTranscription $true
```

These settings can also be updated using the Teams Admin website.

[![](https://1.bp.blogspot.com/-aubFgbLqM4w/XSOoeQlGDtI/AAAAAAABIc8/XMI2v2RNFvg39GMVEwMmIv4yC4OTOiBjwCLcBGAs/s640/TeamsAdminEnableRecordingAndTranscription.PNG)](https://1.bp.blogspot.com/-aubFgbLqM4w/XSOoeQlGDtI/AAAAAAABIc8/XMI2v2RNFvg39GMVEwMmIv4yC4OTOiBjwCLcBGAs/s1600/TeamsAdminEnableRecordingAndTranscription.PNG)

