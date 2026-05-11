---
title: "Calculate Date of Birth in SSRS"
description: "You can utilize this code in an Expression to find the Date of Birth."
pubDate: 2014-02-28
category: power-apps
tags:
  - "reports"
  - "ssrs"
draft: false
originalBloggerUrl: /2014/02/calculate-date-of-birth-in-ssrs.html
---

You can utilize this code in an Expression to find the Date of Birth.

```
=IIF(IsNothing(Fields!dateofbirth.Value), "",
IIF( ((Month(Now) - Month(Fields!dateofbirth.Value)) < 0) 
OR ((Month(Now) - Month(Fields!dateofbirth.Value)) = 0 
AND (Day(Now) - Day(Fields!dateofbirth.Value)) < 0), 
(Year(Now) - Year(Fields!dateofbirth.Value)) - 1,
(Year(Now) - Year(Fields!dateofbirth.Value))
))
```
