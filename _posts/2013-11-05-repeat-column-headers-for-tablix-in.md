---
layout: post
title: Repeat Column Headers for Tablix in SSRS 2008
date: '2013-11-05T17:30:00.002-05:00'
author: Rick Wilson
tags:
- Reports
- SSRS
modified_time: '2014-03-24T13:47:53.530-04:00'
thumbnail: http://2.bp.blogspot.com/-DfbJktOADbg/UnlxeqNWeLI/AAAAAAAAHVQ/wYhw8tt3A1g/s72-c/tablix.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2352655290255848798
blogger_orig_url: https://www.richardawilson.com/2013/11/repeat-column-headers-for-tablix-in.html
---

If you are having trouble getting the column headings to repeat on every page for a table/tablix in SSRS 2008 try this. Open the file in a text editor and look for the Tablixrowheirarchy->tablixMembers->TablixMember node. Then add the following elements.   
    
    <keepwithgroup>After</keepwithgroup>
    <repeatonnewpage>true</repeatonnewpage>
    <keeptogether>true</keeptogether>

.csharpcode, .csharpcode pre{font-size: small;color: black;font-family: Consolas, "Courier New", Courier, Monospace; background-color: #ffffff; /*white-space: pre;*/}.csharpcode pre { margin: 0em; }.csharpcode .rem { color: #008000; }.csharpcode .kwrd { color: #0000ff; }.csharpcode .str { color: #006080; }.csharpcode .op { color: #0000c0; }.csharpcode .preproc { color: #cc6633; }.csharpcode .asp { background-color: #ffff00; }.csharpcode .html { color: #800000; }.csharpcode .attr { color: #ff0000; }.csharpcode .alt { background-color: #f4f4f4; width: 100%; margin: 0em;}.csharpcode .lnum { color: #606060; }

[![](http://2.bp.blogspot.com/-DfbJktOADbg/UnlxeqNWeLI/AAAAAAAAHVQ/wYhw8tt3A1g/s320/tablix.png)](http://2.bp.blogspot.com/-DfbJktOADbg/UnlxeqNWeLI/AAAAAAAAHVQ/wYhw8tt3A1g/s1600/tablix.png)

