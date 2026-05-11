---
title: "Using SQL Server 2005/2008 with ADFS 2.0"
description: "If you plan on using a SQL server 2005/2008 to host your ADFS 2.0 configuration database you must run the configuration using the command line.…"
pubDate: 2010-09-30
updatedDate: 2010-10-25
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgg24Svig5TBNDKE9wxGaTZgvIji8qz6xQpx-4Sp-bE1ezr4nd_5UaT10piSLsl8gj-V2lfohIqTVC8ZsYdpl829YVGc5OyZHYsewHc4c15A9HClt4OYRg4CtdXJVd3kBji57h6pK5xZsY/s400/CreateSQLFarmComplete.png"
category: power-apps
tags:
  - "adfs-2"
  - "security"
draft: false
originalBloggerUrl: /2010/09/using-sql-server-with-adfs-20.html
---

If you plan on using a SQL server 2005/2008 to host your ADFS 2.0 configuration database you must run the configuration using the command line.  If you use the GUI configuration SQL Server Express will be installed on the machine and used to host the database.  
  
Below is an example of a configuration command that would set the service account, create the database and wipe out any information if it already exists, and to use self signed certificates.  
  
Open a command prompt and navigate to:   
**C:\Program Files\Active Directory Federation Services 2.0**  
  
Run the following command:  
**FSConfig.exe CreateSQLFarm /ServiceAccount "domain\user" /ServiceAccountPassword "password" /SQLConnectionString "database=AdfsConfigurationServer;server=sqlservername;integrated security=SSPI" /port 443 /FederationServiceName "adfsserver.domain.com" /CleanConfig /AutoCertRolloverEnabled**  
  
Here is an example of my lab configuration:  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgg24Svig5TBNDKE9wxGaTZgvIji8qz6xQpx-4Sp-bE1ezr4nd_5UaT10piSLsl8gj-V2lfohIqTVC8ZsYdpl829YVGc5OyZHYsewHc4c15A9HClt4OYRg4CtdXJVd3kBji57h6pK5xZsY/s400/CreateSQLFarmComplete.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgg24Svig5TBNDKE9wxGaTZgvIji8qz6xQpx-4Sp-bE1ezr4nd_5UaT10piSLsl8gj-V2lfohIqTVC8ZsYdpl829YVGc5OyZHYsewHc4c15A9HClt4OYRg4CtdXJVd3kBji57h6pK5xZsY/s1600/CreateSQLFarmComplete.png)

  
Finally, the help information is only available through the command line. below is a screen shot of the full output.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjkFQDpsXEAF7l2TpjpOsjX7BZGtwuhFG9Ii68hazlfVbqQJ5gnLqJICzU_F8wpk4gVzMSCJKLARsroQ6oi9bRrIt41-pfg6E0PcKv_Ius8M7EiyQtL6yfDX_MNnrrrt2Z_pD4wdj_a9-4/s640/CreateSQLFarmHelp.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjkFQDpsXEAF7l2TpjpOsjX7BZGtwuhFG9Ii68hazlfVbqQJ5gnLqJICzU_F8wpk4gVzMSCJKLARsroQ6oi9bRrIt41-pfg6E0PcKv_Ius8M7EiyQtL6yfDX_MNnrrrt2Z_pD4wdj_a9-4/s1600/CreateSQLFarmHelp.png)

  
  
[MSDN - Configure a New Federation Server](http://technet.microsoft.com/en-us/library/adfs2-help-how-to-configure-a-new-federation-server(WS.10).aspx)
