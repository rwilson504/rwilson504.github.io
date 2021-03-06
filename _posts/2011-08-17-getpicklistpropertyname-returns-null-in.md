---
layout: post
title: GetPickListProperty.name Returns Null in PreCreate
date: '2011-08-17T13:03:00.000-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Plugin Development
modified_time: '2011-08-17T13:03:27.177-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5136707810971628464
blogger_orig_url: https://www.richardawilson.com/2011/08/getpicklistpropertyname-returns-null-in.html
---

In CRM 4.0 using the Target.GetPickListProperty("fieldname").name property would return the string value of the pick list item display name even in a PreCreate plugin step.  Apparently though in 2011 the name property just returns null until after the initial create has been done.  Instead of using name make sure to use the Value property which is always available.

mypicklist Example:
Value  Name
1         Approve
2         Cancel

PreCreate step:
Target.GetPickListProperty("mypicklist").name  // this would return null
Target.GetPickListProperty("mypicklist").Value // this would return either 1 or 2

PostCreate step:

Target.GetPickListProperty("mypicklist").name  // this would return either "Approve" or "Cancel"
Target.GetPickListProperty("mypicklist").Value // this would return either 1 or 2

