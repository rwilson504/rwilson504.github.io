---
layout: post
title: Get Process ID of Application Pool (w3wp.exe)
date: '2014-06-26T15:22:00.001-04:00'
author: Rick Wilson
tags: 
modified_time: '2014-06-26T15:26:58.816-04:00'
thumbnail: http://3.bp.blogspot.com/-Mnk0DZjxl-c/U6xzIvpn8BI/AAAAAAAAI60/xEtNjn6Cg6E/s72-c/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6872603532977258672
blogger_orig_url: https://www.richardawilson.com/2014/06/get-process-id-of-application-pool.html
---

When wanting to debug in VS sometimes I only want to attach to a specific Application Pool.  To find out which Process Id belongs to what Application pool open a Command Prompt and use the following command.

    
    C:\Windows\System32\Inetsrv\> Appcmd list wp
    

You will get a list of all the running application pools and their process id.

[![](http://3.bp.blogspot.com/-Mnk0DZjxl-c/U6xzIvpn8BI/AAAAAAAAI60/xEtNjn6Cg6E/s1600/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png)](http://3.bp.blogspot.com/-Mnk0DZjxl-c/U6xzIvpn8BI/AAAAAAAAI60/xEtNjn6Cg6E/s1600/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png)

