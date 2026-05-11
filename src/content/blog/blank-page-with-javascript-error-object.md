---
title: "Blank Page With JavaScript Error 'Object Expected'"
description: "I had just installed reporting services and the reporting services connector. Suddenly my CRM web client is only showing me a blue screen and will not go to the main page."
pubDate: 2009-08-21
category: power-apps
tags:
  - "crm-4"
  - "error"
draft: false
originalBloggerUrl: /2009/08/blank-page-with-javascript-error-object.html
---

I had just installed reporting services and the reporting services connector. Suddenly my CRM web client is only showing me a blue screen and will not go to the main page. My office neighbor could see the screen but no images were being displayed.  
  
There was a javascript error that said the following:  
  
Error on page  
Line: 194  
Char: 1  
Error: Object expected  
Code: 0  
URL: http://localhost:5555/orgname  
  
Here is what I did to fix:  
  
-Go into the IIS Manager and select properties for the CRM Website.  
  
-Remove Anonymous access from the site.  
  
-Apply the properties  
  
-Go back in and turn Anonymous access back on and re-apply the change.  
  
Now navigate back to your site. Voila! It worked for me.
