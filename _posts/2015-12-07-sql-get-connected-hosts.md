---
layout: post
title: SQL - Get Connected Hosts
date: '2015-12-07T14:08:00.000-05:00'
author: Rick Wilson
tags:
- SQL
modified_time: '2015-12-07T14:08:33.142-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-56067315029592535
blogger_orig_url: https://www.richardawilson.com/2015/12/sql-get-connected-hosts.html
---

Gets a list of all the connections currently open on SQL  
    
    SELECT HOST_NAME, PROGRAM_NAME, wait_resource, 
    wait_time, 
    wait_type, 
    net_transport, 
    DMER.session_id,
    start_time,
    DMES.status,
    plan_handle,
    auth_scheme,
    local_tcp_port,
    local_net_address 
     FROM sys.dm_exec_requests DMER
    INNER JOIN sys.dm_exec_sessions DMES ON DMES.session_id=DMER.session_id
    INNER JOIN sys.dm_exec_connections DMEC ON DMEC.session_id=DMES.session_id
    

