---
layout: post
title: Blank Page With JavaScript Error 'Object Expected'
date: '2009-08-21T16:11:00.001-04:00'
author: Rick Wilson
tags:
- Error
- CRM 4.0
modified_time: '2009-08-21T16:11:44.569-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1079338125430761990
blogger_orig_url: https://www.richardawilson.com/2009/08/blank-page-with-javascript-error-object.html
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

