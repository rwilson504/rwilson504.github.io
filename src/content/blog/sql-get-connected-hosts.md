---
title: "SQL - Get Connected Hosts"
description: "Gets a list of all the connections currently open on SQL"
pubDate: 2015-12-07
category: power-apps
tags:
  - "sql"
draft: false
originalBloggerUrl: /2015/12/sql-get-connected-hosts.html
---

Gets a list of all the connections currently open on SQL

```
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
```
