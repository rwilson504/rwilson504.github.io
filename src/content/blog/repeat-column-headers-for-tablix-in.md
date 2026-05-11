---
title: "Repeat Column Headers for Tablix in SSRS 2008"
description: "If you are having trouble getting the column headings to repeat on every page for a table/tablix in SSRS 2008 try this.…"
pubDate: 2013-11-05
updatedDate: 2014-03-24
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhGSkwlGu2hIiKzOsOF5C3HAqjKAaNY9QEOCw1D1a3TGAujgndfzpQalpg2XsdIwHS7J826AYa9YMiOHPn6qaE-R0fddfqX4dhnN9ALNTCJi2V7gxIZBqm6t39GGcYIJHPrcPwMDsFdrbc/s320/tablix.png"
category: power-apps
tags:
  - "reports"
  - "ssrs"
draft: false
originalBloggerUrl: /2013/11/repeat-column-headers-for-tablix-in.html
---

If you are having trouble getting the column headings to repeat on every page for a table/tablix in SSRS 2008 try this. Open the file in a text editor and look for the Tablixrowheirarchy->tablixMembers->TablixMember node. Then add the following elements.

```
<keepwithgroup>After</keepwithgroup>  
<repeatonnewpage>true</repeatonnewpage>  
<keeptogether>true</keeptogether>
```

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: Consolas, "Courier New", Courier, Monospace; background-color: #ffffff; /\*white-space: pre;\*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt { background-color: #f4f4f4; width: 100%; margin: 0em;}.csharpcode .lnum { color: #606060; }  
  
[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhGSkwlGu2hIiKzOsOF5C3HAqjKAaNY9QEOCw1D1a3TGAujgndfzpQalpg2XsdIwHS7J826AYa9YMiOHPn6qaE-R0fddfqX4dhnN9ALNTCJi2V7gxIZBqm6t39GGcYIJHPrcPwMDsFdrbc/s320/tablix.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhGSkwlGu2hIiKzOsOF5C3HAqjKAaNY9QEOCw1D1a3TGAujgndfzpQalpg2XsdIwHS7J826AYa9YMiOHPn6qaE-R0fddfqX4dhnN9ALNTCJi2V7gxIZBqm6t39GGcYIJHPrcPwMDsFdrbc/s1600/tablix.png)
