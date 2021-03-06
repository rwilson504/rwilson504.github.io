---
layout: post
title: Remove Timeout When Debugging w3wp Process
date: '2010-07-08T12:18:00.013-04:00'
author: Rick Wilson
tags:
- Error
- Development
- IIS
- Testing
modified_time: '2010-07-08T12:39:02.366-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5738596673957880519
blogger_orig_url: https://www.richardawilson.com/2010/07/remove-timeout-when-debugging-w3wp.html
---

One of the smart guys I work with posted some information about debugging the W3WP process that I though I should share. Many times when debugging this process I get timeout errors when I let it sit for too long.

Error: The web server process that was being debugged has been terminated by Internet Information Services (IIS)

You can get rid of the timeout by following the following directions. **Caution**, this should only be done on development boxes, do not change these settings on your production machines.

1. Open the Administrative Tools window. 
2. Click Start and then choose Control Panel. 
3. In Control Panel, choose Switch to Classic View, if necessary, and then double-click Administrative Tools. 
4. In the Administrative Tools window, double-click Internet Information Services (IIS) Manager. 
5. In the Internet Information Services (IIS) Manager window, expand the node. 
6. Under the node, right-click Application Pools. 
7. In the Application Pools list, right-click the name of the pool your application runs in, and then click Advanced Settings. 
8. In the Advanced Settings dialog box, locate the Process Model section and chose one of the following actions: 

- Set Ping Enabled to False. —or— 
- Set Ping Maximum Response Time to a value greater than 90 seconds. 

9. Setting Ping Enabled to False stops IIS from checking whether the worker process is still running and keeps the worker process alive until you stop your debugged process. Setting Ping Maximum Response Time to a large value allows IIS to continue monitoring the worker process. 
10. Click OK. 

