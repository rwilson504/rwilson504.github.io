---
title: "RDWeb - Cannot use Connect to a PC Functionality"
description: "After completing the setup of the RDS/RDWeb on Windows Server 2012 R2 we were unable to use the \"Connect to a PC\" functionality. When attempting to connect the following error:"
pubDate: 2017-02-06
category: misc
tags:
  - "rds"
  - "remote-desktop"
  - "remote-desktop-gateway"
  - "windows-server-2012"
draft: false
originalBloggerUrl: /2017/02/rdweb-cannot-use-connect-to-pc.html
---

After completing the setup of the RDS/RDWeb on Windows Server 2012 R2 we were unable to use the "Connect to a PC" functionality. When attempting to connect the following error:  
  
Remote Desktop can't find the computer "". This means that "" does not belong to the specific network. Verify the computer name and domain that you are trying to connect to"   
  
The fix for this is to go into the IIS Manager on the RDS server.   
 -Go to Server -> Sites -> Default Web Site -> RDWeb -> Pages   
-Click on Application Settings.   
-Modify the DefaultTSGateway setting by entering the FQDN of your RDS server. eg(rds.richardawilson.lab)
