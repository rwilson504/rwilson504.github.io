---
layout: post
title: Grouping Articles By Month
date: '2009-09-01T17:07:00.009-04:00'
author: Rick Wilson
tags:
- Web Part
- SharePoint 2007
modified_time: '2009-09-01T17:57:37.778-04:00'
thumbnail: http://4.bp.blogspot.com/_mr9BzRLR2GQ/Sp2MTYcTa0I/AAAAAAAAEdc/HN87RgqsS04/s72-c/groupbymonthcalcfield.jpg
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-9073057570953765332
blogger_orig_url: https://www.richardawilson.com/2009/09/grouping-articles-by-month.html
---

After creating a blog site I wanted to show a webpart that grouped the posts by month. To accomplish this I added a calculated field to my Posts list and used the following formula:

     =TEXT(Published,"yyyy - ")&TEXT(Published,"mm")&TEXT(Published," (mmmm")&TEXT(Published," yyyy)")```

[![](http://4.bp.blogspot.com/_mr9BzRLR2GQ/Sp2MTYcTa0I/AAAAAAAAEdc/HN87RgqsS04/s400/groupbymonthcalcfield.jpg)](http://4.bp.blogspot.com/_mr9BzRLR2GQ/Sp2MTYcTa0I/AAAAAAAAEdc/HN87RgqsS04/s1600-h/groupbymonthcalcfield.jpg)
  

  
  
  
  
  
  
    
  

  
  
  
  
  
  
  
  
  
  
  

You can substitute Published for any other date field within your Posts list. When calculated it displays the date in the following format "2007 - 05 (May 2007)" 

After completing the calculated field I added a new Posts webpart to the page. I then modified it to the show the "All Posts" view. Then I modified that view to group by the calculated field I created. 

**Note**: It is important to change the view of the webpart to from "" to "All Items" after you add the webpart. Otherwise when you uncollapse the grouping the titles and other text will have the same formatting as the blog posts. This means your titles will show up HUGE.

[![](http://1.bp.blogspot.com/_mr9BzRLR2GQ/Sp2MnN5xwVI/AAAAAAAAEdk/xKeXBbUpIv4/s400/groupbymonth.jpg)](http://1.bp.blogspot.com/_mr9BzRLR2GQ/Sp2MnN5xwVI/AAAAAAAAEdk/xKeXBbUpIv4/s1600-h/groupbymonth.jpg)

