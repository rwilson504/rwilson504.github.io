---
title: "Find Empty Methods in Visual Studio"
description: "To find empty methods in Visual Studio search using the following regular expression."
pubDate: 2018-04-23
updatedDate: 2018-04-24
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

  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg28qLWLPkdIE7QPJtf1CqI2ELKVdbbvhAY53PZXuLcO8YTxVgd9ZxROqnxeL2F19fv_2eFavRHixqJPVd7xLi_LobGCv9GgNy6V2BIzZ8jmJg3KR1jnDW6-ZONB_DXT8FejdS9FDh4kGY/s320/RegularExpressionEmptyMethods.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg28qLWLPkdIE7QPJtf1CqI2ELKVdbbvhAY53PZXuLcO8YTxVgd9ZxROqnxeL2F19fv_2eFavRHixqJPVd7xLi_LobGCv9GgNy6V2BIzZ8jmJg3KR1jnDW6-ZONB_DXT8FejdS9FDh4kGY/s1600/RegularExpressionEmptyMethods.png)
