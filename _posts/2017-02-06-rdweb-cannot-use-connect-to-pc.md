---
layout: post
title: RDWeb - Cannot use Connect to a PC Functionality
date: '2017-02-06T11:12:00.001-05:00'
author: Rick Wilson
tags:
- RDS
- Remote Desktop
- Remote Desktop Gateway
- Windows Server 2012
modified_time: '2017-02-06T12:15:35.821-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7662322538494115911
blogger_orig_url: https://www.richardawilson.com/2017/02/rdweb-cannot-use-connect-to-pc.html
---

After completing the setup of the RDS/RDWeb on Windows Server 2012 R2 we were unable to use the "Connect to a PC" functionality.  When attempting to connect the following error:

Remote Desktop can't find the computer "".  This means that "" does not belong to the specific network.  Verify the computer name and domain that you are trying to connect to" 

The fix for this is to go into the IIS Manager on the RDS server. 
 -Go to Server -> Sites -> Default Web Site -> RDWeb -> Pages 
-Click on Application Settings. 
-Modify the DefaultTSGateway setting by entering the FQDN of your RDS server. eg(rds.richardawilson.lab)

