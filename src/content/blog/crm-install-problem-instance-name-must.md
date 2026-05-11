---
title: "CRM Install Problem: instance name must be the same as computer name"
description: "Open a query window in the Microsoft SQL Server Management Studio and run the following command. It will display to you the current name of the SQL server."
pubDate: 2010-02-24
category: power-apps
tags:
  - "crm-4"
  - "error"
draft: false
originalBloggerUrl: /2010/02/crm-install-problem-instance-name-must.html
---

Open a query window in the Microsoft SQL Server Management Studio and run the following command.  It will display to you the current name of the SQL server.  
  
sp\_helpserver  
GO  
  
Next we will run the following commands.  Replace old\_name with the SQL server name you discovered in the sp\_helpserver command, and replace new\_name with the name of the server.  (include the single quotes our the names)  
  
sp\_dropserver 'old\_name'  
GO  
sp\_addserver 'new\_name', local  
GO  
  
Open the SQL Server Configuration Manager and resart the SQL Services.  
  
To deteremine if the update was successful run the following command against the 'master' database.  If the query displays the new\_name you assigned to SQL it will be displayed here.  If there is nothing displayed then something went wrong.  
SELECT @@SERVERNAME
