---
title: "GetPickListProperty.name Returns Null in PreCreate"
description: "In CRM 4.0 using the Target.GetPickListProperty(\"fieldname\").name property would return the string value of the pick list item display name even in a PreCreate plugin step.…"
pubDate: 2011-08-17
category: power-apps
tags:
  - "crm-2011"
  - "plugin-development"
draft: false
originalBloggerUrl: /2011/08/getpicklistpropertyname-returns-null-in.html
---

In CRM 4.0 using the Target.GetPickListProperty("fieldname").name property would return the string value of the pick list item display name even in a PreCreate plugin step.  Apparently though in 2011 the name property just returns null until after the initial create has been done.  Instead of using name make sure to use the Value property which is always available.  
  
**mypicklist Example:**  
Value  Name  
1         Approve  
2         Cancel  
  
**PreCreate step:**  
Target.GetPickListProperty("mypicklist").name  // this would return null  
Target.GetPickListProperty("mypicklist").Value // this would return either 1 or 2  
  
**PostCreate step:**  
  
Target.GetPickListProperty("mypicklist").name  // this would return either "Approve" or "Cancel"  
Target.GetPickListProperty("mypicklist").Value // this would return either 1 or 2
