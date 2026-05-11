---
title: "Visual Studio Error: The given assembly name or codebase was invalid (HRESULT: 0x80131047)"
description: "When attempting to add a reference to a project this error kept appearing."
pubDate: 2014-03-06
category: power-apps
tags:
  - "error"
  - "visual-studio"
draft: false
originalBloggerUrl: /2014/03/visual-studio-error-given-assembly-name.html
---

When attempting to add a reference to a project this error kept appearing.

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiTNi4bTE2IOL5bzjue4gQGQFqH6FEsI6OGbGvFFkqcOdpK3qXQGqEtPvZnMbtltZaC5lkJin8TKc7cmNuSv8f6Uz5UGHOsh62p520ZI_z2vIEFooxpqFR_nTMswCbWTKoV1DMurFYDvAs/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEilPpM6Io7KfH7vK1VyAfkdlbC2QWy1HM7qB6Azu90Kq8zaRazd6rbyVTMLifXBA16lF2BV0Lx-W1neyv6U0GZr4NroO48d041L44Rj6ZQq6OTykFNH1Qqsr-RMa6OJUf0No_3yqIflw4o/s1600-h/image%25255B3%25255D.png)

I though it was because I had switched the project from .Net 3.0 to 3.5 but it turns out it was something else.  The problem turned out to be that the assembly path contained a comma (eg. C:\Libraries\MyLibrary{1-1-14, Customer}).  Once I moved the assembly to C:\Libraries it added correctly.
