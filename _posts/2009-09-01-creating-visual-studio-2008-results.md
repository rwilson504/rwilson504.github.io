---
layout: post
title: Creating a Visual Studio 2008 Results Repository
date: '2009-09-01T17:38:00.003-04:00'
author: Rick Wilson
tags:
- Visual Studio
- Testing
modified_time: '2009-09-01T17:56:08.697-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7828351602296613933
blogger_orig_url: https://www.richardawilson.com/2009/09/creating-visual-studio-2008-results.html
---

Learned a very important lesson. If you don't set up a results repository database before running a load test in Visual Studio you won't be able to pull up your reports later.

In this example only one machine was being used for load testing and SQL Express was installed as part of Visual Studio.

To create the results repository database in SQL Express follow the instructions below. If you want additional information or want to know how to create the database in SQL Standard check out Microsoft's instructions at [http://msdn.microsoft.com/en-us/library/ms182600.aspx](http://msdn.microsoft.com/en-us/library/ms182600.aspx)

-Open a command prompt by going to **Start -> Run** and type in **CMD** and hit **Enter**

-Type: **cd n:\Program Files\Microsoft Visual Studio 9\Common7\IDE**

-Type: **SQLCMD /S localhost\sqlexpress /i loadtestresultsrepository.sql**

