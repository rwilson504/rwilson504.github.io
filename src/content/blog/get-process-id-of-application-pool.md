---
title: "Get Process ID of Application Pool (w3wp.exe)"
description: "When wanting to debug in VS sometimes I only want to attach to a specific Application Pool. To find out which Process Id belongs to what Application pool open a Command Prompt and use the following…"
pubDate: 2014-06-26
heroImage: "/heroes/get-process-id-of-application-pool.png"
category: misc
tags: []
draft: false
originalBloggerUrl: /2014/06/get-process-id-of-application-pool.html
---

When wanting to debug in VS sometimes I only want to attach to a specific Application Pool.  To find out which Process Id belongs to what Application pool open a Command Prompt and use the following command.  
  

```
C:\Windows\System32\Inetsrv\> Appcmd list wp
```

  
You will get a list of all the running application pools and their process id.
