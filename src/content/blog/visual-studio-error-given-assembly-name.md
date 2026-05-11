---
title: "Visual Studio Error: The given assembly name or codebase was invalid (HRESULT: 0x80131047)"
description: "When attempting to add a reference to a project this error kept appearing."
pubDate: 2014-03-06
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiTNi4bTE2IOL5bzjue4gQGQFqH6FEsI6OGbGvFFkqcOdpK3qXQGqEtPvZnMbtltZaC5lkJin8TKc7cmNuSv8f6Uz5UGHOsh62p520ZI_z2vIEFooxpqFR_nTMswCbWTKoV1DMurFYDvAs/?imgmax=800"
heroImageAlt: "image"
category: power-apps
tags:
  - "error"
  - "visual-studio"
draft: false
originalBloggerUrl: /2014/03/visual-studio-error-given-assembly-name.html
---

When attempting to add a reference to a project this error kept appearing.

I though it was because I had switched the project from .Net 3.0 to 3.5 but it turns out it was something else.  The problem turned out to be that the assembly path contained a comma (eg. C:\Libraries\MyLibrary{1-1-14, Customer}).  Once I moved the assembly to C:\Libraries it added correctly.
