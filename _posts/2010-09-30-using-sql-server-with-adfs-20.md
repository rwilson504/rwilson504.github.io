---
layout: post
title: Using SQL Server 2005/2008 with ADFS 2.0
date: '2010-09-30T14:56:00.009-04:00'
author: Rick Wilson
tags:
- Security
- ADFS 2.0
modified_time: '2010-10-25T12:38:01.961-04:00'
thumbnail: http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWyBVM5ERI/AAAAAAAAFjk/aXeRO05MA9o/s72-c/CreateSQLFarmComplete.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3592252714989760782
blogger_orig_url: https://www.richardawilson.com/2010/09/using-sql-server-with-adfs-20.html
---

If you plan on using a SQL server 2005/2008 to host your ADFS 2.0 configuration database you must run the configuration using the command line.  If you use the GUI configuration SQL Server Express will be installed on the machine and used to host the database.

Below is an example of a configuration command that would set the service account, create the database and wipe out any information if it already exists, and to use self signed certificates.

Open a command prompt and navigate to: 
**C:\Program Files\Active Directory Federation Services 2.0**

Run the following command:
**FSConfig.exe CreateSQLFarm /ServiceAccount "domain\user" /ServiceAccountPassword "password" /SQLConnectionString "database=AdfsConfigurationServer;server=sqlservername;integrated security=SSPI" /port 443 /FederationServiceName "adfsserver.domain.com" /CleanConfig /AutoCertRolloverEnabled**

Here is an example of my lab configuration:

[![](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWyBVM5ERI/AAAAAAAAFjk/aXeRO05MA9o/s400/CreateSQLFarmComplete.png)](http://1.bp.blogspot.com/_mr9BzRLR2GQ/TMWyBVM5ERI/AAAAAAAAFjk/aXeRO05MA9o/s1600/CreateSQLFarmComplete.png)

Finally, the help information is only available through the command line. below is a screen shot of the full output.

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWyV6dq4YI/AAAAAAAAFjs/qC7kqfLfudQ/s640/CreateSQLFarmHelp.png)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/TMWyV6dq4YI/AAAAAAAAFjs/qC7kqfLfudQ/s1600/CreateSQLFarmHelp.png)

[MSDN - Configure a New Federation Server](http://technet.microsoft.com/en-us/library/adfs2-help-how-to-configure-a-new-federation-server(WS.10).aspx)

