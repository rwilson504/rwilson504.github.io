---
layout: post
title: 'CRM Install Problem: instance name must be the same as computer name'
date: '2010-02-24T17:33:00.001-05:00'
author: Rick Wilson
tags:
- Error
- CRM 4.0
modified_time: '2010-02-24T17:34:23.804-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8263179319087794499
blogger_orig_url: https://www.richardawilson.com/2010/02/crm-install-problem-instance-name-must.html
---

Open a query window in the Microsoft SQL Server Management Studio and run the following command.  It will display to you the current name of the SQL server.

sp_helpserver
GO

Next we will run the following commands.  Replace old_name with the SQL server name you discovered in the sp_helpserver command, and replace new_name with the name of the server.  (include the single quotes our the names)

sp_dropserver 'old_name'
GO
sp_addserver 'new_name', local
GO

Open the SQL Server Configuration Manager and resart the SQL Services.

To deteremine if the update was successful run the following command against the 'master' database.  If the query displays the new_name you assigned to SQL it will be displayed here.  If there is nothing displayed then something went wrong.
SELECT @@SERVERNAME

