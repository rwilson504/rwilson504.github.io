---
title: "Creating a Visual Studio 2008 Results Repository"
description: "Learned a very important lesson. If you don't set up a results repository database before running a load test in Visual Studio you won't be able to pull up your reports later."
pubDate: 2009-09-01
category: power-apps
tags:
  - "testing"
  - "visual-studio"
draft: false
originalBloggerUrl: /2009/09/creating-visual-studio-2008-results.html
---

Learned a very important lesson. If you don't set up a results repository database before running a load test in Visual Studio you won't be able to pull up your reports later.  
  
In this example only one machine was being used for load testing and SQL Express was installed as part of Visual Studio.  
  
To create the results repository database in SQL Express follow the instructions below. If you want additional information or want to know how to create the database in SQL Standard check out Microsoft's instructions at <http://msdn.microsoft.com/en-us/library/ms182600.aspx>  
  
-Open a command prompt by going to **Start -> Run** and type in **CMD** and hit **Enter**  
  
-Type: **cd n:\Program Files\Microsoft Visual Studio 9\Common7\IDE**  
  
-Type: **SQLCMD /S localhost\sqlexpress /i loadtestresultsrepository.sql**
