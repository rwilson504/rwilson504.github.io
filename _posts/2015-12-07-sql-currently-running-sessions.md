---
layout: post
title: SQL Currently Running Sessions
date: '2015-12-07T14:10:00.001-05:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2015-12-07T14:10:28.080-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6246994746033338221
blogger_orig_url: https://www.richardawilson.com/2015/12/sql-currently-running-sessions.html
---

Get all current sessions running on sql instance.  
    
    SELECT r.session_id, r.status, r.start_time, r.command, s.text, 
    r.wait_time, r.cpu_time, r.total_elapsed_time, r.reads, r.writes, r.logical_reads, r.transaction_isolation_level 
    ,r.* 
    FROM sys.dm_exec_requests r 
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) s
    

