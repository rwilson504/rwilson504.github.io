---
layout: post
title: Pass XRM Ribbon Parameters Using JavaScript Array
date: '2014-03-05T19:24:00.001-05:00'
author: Rick Wilson
tags:
- CRM 2011
modified_time: '2014-03-05T19:24:06.633-05:00'
thumbnail: http://lh5.ggpht.com/-AOhCOA4tGm4/UxfAHdzIYiI/AAAAAAAAHWg/Z0eQCI5KMtM/s72-c/image_thumb%25255B1%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3810009742333884295
blogger_orig_url: https://www.richardawilson.com/2014/03/pass-xrm-ribbon-parameters-using.html
---


Trying to pass the list of selected items from a grid using query parameters has limitations due to restrictions on the size of a URL.  Instead use JavaScript to pass Ribbon parameters to a variable on the XRM page and grab the data in the popup window.

Ribbon Command Setup
Here we pass the SelectedControlSelectedItemIds which will pass an object array of all the record ids that are selected on the home grid.

[![image](http://lh5.ggpht.com/-AOhCOA4tGm4/UxfAHdzIYiI/AAAAAAAAHWg/Z0eQCI5KMtM/image_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.ggpht.com/-lzQrYcBA0k4/UxfAGhIZDeI/AAAAAAAAHWY/uakg5aA0AV0/s1600-h/image%25255B3%25255D.png)

**Ribbon JavaScript Web Resource
**The web resource will data the ids and post them to a new variable in the main XRM window then opens a popup window.

[![image](http://lh6.ggpht.com/-Nq3SA-kr3Vw/UxfAIQxhMvI/AAAAAAAAHWs/aGbL3BJrYqs/image_thumb%25255B3%25255D.png?imgmax=800)](http://lh5.ggpht.com/-BoWomBxYYKM/UxfAH4KaI3I/AAAAAAAAHWo/1OqQ8RfNK7s/s1600-h/image%25255B7%25255D.png)

**AddApplicantsToCourse.htm**
This popup page will get the ids from the page that opened it.  In order to do so we need to do the following:

-Include jQuery
-declare the array to hold the id values
-copy the values from the object in the parent page to the array you created

[![image](http://lh4.ggpht.com/-H5ZvIYF5Vu4/UxfAJT9X_gI/AAAAAAAAHW8/TRn8GB68jPc/image_thumb%25255B9%25255D.png?imgmax=800)](http://lh5.ggpht.com/-AbYYZPsj-YY/UxfAI8tCDUI/AAAAAAAAHW0/VuySUckp3EA/s1600-h/image%25255B19%25255D.png)

