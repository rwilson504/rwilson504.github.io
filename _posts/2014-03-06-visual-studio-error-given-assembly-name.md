---
layout: post
title: 'Visual Studio Error: The given assembly name or codebase was invalid (HRESULT:
  0x80131047)'
date: '2014-03-06T18:59:00.001-05:00'
author: Rick Wilson
tags:
- Visual Studio
- Error
modified_time: '2014-03-06T18:59:38.696-05:00'
thumbnail: http://lh3.ggpht.com/-8-AA-TmPZSc/UxkL6ew0aeI/AAAAAAAAHlo/-ePLcvDT64s/s72-c/image_thumb%25255B1%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-4555038249229682987
blogger_orig_url: https://www.richardawilson.com/2014/03/visual-studio-error-given-assembly-name.html
---


When attempting to add a reference to a project this error kept appearing.  

[![image](http://lh3.ggpht.com/-8-AA-TmPZSc/UxkL6ew0aeI/AAAAAAAAHlo/-ePLcvDT64s/image_thumb%25255B1%25255D.png?imgmax=800)](http://lh6.ggpht.com/-9S37arTo-5E/UxkL5uD2qnI/AAAAAAAAHlg/A5Fxae_DWgg/s1600-h/image%25255B3%25255D.png)

I though it was because I had switched the project from .Net 3.0 to 3.5 but it turns out it was something else.  The problem turned out to be that the assembly path contained a comma (eg. C:\Libraries\MyLibrary{1-1-14, Customer}).  Once I moved the assembly to C:\Libraries it added correctly.

