---
layout: post
title: Get Times for CRM Import Jobs
date: '2013-10-24T15:40:00.001-04:00'
author: Rick Wilson
tags:
- SQL
- CRM 2011
- import
modified_time: '2015-01-06T09:57:16.931-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7749209030886024486
blogger_orig_url: https://www.richardawilson.com/2013/10/get-times-for-crm-import-jobs.html
---

This script will give you the times for CRM import jobs that have been run on your system.

    --Shows all import records and the amount of time they took
    SELECT [Name], [StartedOn], [CompletedOn],
    DATEDIFF(MINUTE, [StartedOn], [CompletedOn]) AS [Diff In Minutes]
    FROM [Default_MSCRM].[dbo].[AsyncOperationBase] 
    WHERE OperationType IN (3,4,5) --OperationType 3,4,5 are the ones which relate to imports

    --Shows total number of minutes for all imports
    SELECT SUM(DATEDIFF(MINUTE, [StartedOn], [CompletedOn])) AS [Total Diff In Minutes]
    FROM [Default_MSCRM].[dbo].[AsyncOperationBase] 
    WHERE OperationType IN (3,4,5)

    --Shows total number of hours for all imports
    SELECT SUM(DATEDIFF(MINUTE, [StartedOn], [CompletedOn])) /60 AS [Total Diff In Hours]
    FROM [Default_MSCRM].[dbo].[AsyncOperationBase] 
    WHERE OperationType IN (3,4,5)

