---
layout: post
title: Find Empty Methods in Visual Studio
date: '2018-04-23T08:56:00.002-04:00'
author: Rick Wilson
tags:
- Visual Studio
- RegEx
modified_time: '2018-04-24T09:10:49.515-04:00'
thumbnail: https://4.bp.blogspot.com/-x5Gk9uA_yks/Wt3XvEFF3cI/AAAAAAAA4Ao/CBgsEdpHkukpRHptFnwE-KQkb3Fjnj46QCLcBGAs/s72-c/RegularExpressionEmptyMethods.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3785108659158253763
blogger_orig_url: https://www.richardawilson.com/2018/04/find-empty-methods-in-visual-studio.html
---

To find empty methods in Visual Studio search using the following regular expression.

    void\ .*\(*\)(\ |(\r\n))*{(\ |(\r\n))*}
    
    

[![](https://4.bp.blogspot.com/-x5Gk9uA_yks/Wt3XvEFF3cI/AAAAAAAA4Ao/CBgsEdpHkukpRHptFnwE-KQkb3Fjnj46QCLcBGAs/s320/RegularExpressionEmptyMethods.png)](https://4.bp.blogspot.com/-x5Gk9uA_yks/Wt3XvEFF3cI/AAAAAAAA4Ao/CBgsEdpHkukpRHptFnwE-KQkb3Fjnj46QCLcBGAs/s1600/RegularExpressionEmptyMethods.png)

