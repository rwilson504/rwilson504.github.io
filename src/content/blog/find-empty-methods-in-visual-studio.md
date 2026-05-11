---
title: "Find Empty Methods in Visual Studio"
description: "To find empty methods in Visual Studio search using the following regular expression."
pubDate: 2018-04-23
updatedDate: 2018-04-24
heroImage: "/heroes/find-empty-methods-in-visual-studio.png"
category: power-apps
tags:
  - "regex"
  - "visual-studio"
draft: false
originalBloggerUrl: /2018/04/find-empty-methods-in-visual-studio.html
---

To find empty methods in Visual Studio search using the following regular expression.  
  

```
void\ .*\(*\)(\ |(\r\n))*{(\ |(\r\n))*}
```
