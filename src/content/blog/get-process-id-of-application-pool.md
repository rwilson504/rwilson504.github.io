---
title: "Get Process ID of Application Pool (w3wp.exe)"
description: "When wanting to debug in VS sometimes I only want to attach to a specific Application Pool.…"
pubDate: 2014-06-26
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwpsg9ScF9ByKoHR88A87K1AyXKeLAhmCJ09fkKUIIS0SSmDMPr2xD68Bo635bHAyFV2qh8_pQ5zjQ9-wVyGg1mwwGszuz29v4nNU9fGJ86E1akaLHy94VjFxyFHHKbxLxOJcQ0b9XPz0/s1600/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png"
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

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwpsg9ScF9ByKoHR88A87K1AyXKeLAhmCJ09fkKUIIS0SSmDMPr2xD68Bo635bHAyFV2qh8_pQ5zjQ9-wVyGg1mwwGszuz29v4nNU9fGJ86E1akaLHy94VjFxyFHHKbxLxOJcQ0b9XPz0/s1600/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiwpsg9ScF9ByKoHR88A87K1AyXKeLAhmCJ09fkKUIIS0SSmDMPr2xD68Bo635bHAyFV2qh8_pQ5zjQ9-wVyGg1mwwGszuz29v4nNU9fGJ86E1akaLHy94VjFxyFHHKbxLxOJcQ0b9XPz0/s1600/2014-06-26+15_20_32-dev-rick-wilson.permuta.com+-+Remote+Desktop+Connection+Manager+v2.2.png)
