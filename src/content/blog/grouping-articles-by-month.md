---
title: "Grouping Articles By Month"
description: "After creating a blog site I wanted to show a webpart that grouped the posts by month. To accomplish this I added a calculated field to my Posts list and used the following formula:"
pubDate: 2009-09-01
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhO5l6aBWWmRho_WbDbokFYPyI1KrVcVnjgCwCaWTIJYNBxhWi69xc8dkrqdqm1rMiDsFNe_EUqjvsHbYFxJo-xlDlAUqDvgLTpYgi_dJRUkXtoJUXj0gbZKvLYXdCU2djl3x_NTPPbzu0/s400/groupbymonthcalcfield.jpg"
category: power-apps
tags:
  - "sharepoint-2007"
  - "web-part"
draft: false
originalBloggerUrl: /2009/09/grouping-articles-by-month.html
---

After creating a blog site I wanted to show a webpart that grouped the posts by month. To accomplish this I added a calculated field to my Posts list and used the following formula:  
  

```
 =TEXT(Published,"yyyy - ")&TEXT(Published,"mm")&TEXT(Published," (mmmm")&TEXT(Published," yyyy)")
```

  
    
  
  
    
    
    
    
    
    
      
    
  
  
  
    
    
    
    
    
    
    
    
    
    
    
  
  
You can substitute Published for any other date field within your Posts list. When calculated it displays the date in the following format "2007 - 05 (May 2007)"   
  
After completing the calculated field I added a new Posts webpart to the page. I then modified it to the show the "All Posts" view. Then I modified that view to group by the calculated field I created.   
  
**Note**: It is important to change the view of the webpart to from "" to "All Items" after you add the webpart. Otherwise when you uncollapse the grouping the titles and other text will have the same formatting as the blog posts. This means your titles will show up HUGE.  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgtCIpZvArzImJU-mQcqMDfZKT7AVmYAvfxxGpM5VqBNayBr47VfxoTH7Befj5F2BFVD1Qf_lFcPEZp_s46s5hnRAA7EUCGRXZ0vx39cg_31IJ7izceCxf_pfz2Kz2JqNRIjuK1L82ozdo/s400/groupbymonth.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgtCIpZvArzImJU-mQcqMDfZKT7AVmYAvfxxGpM5VqBNayBr47VfxoTH7Befj5F2BFVD1Qf_lFcPEZp_s46s5hnRAA7EUCGRXZ0vx39cg_31IJ7izceCxf_pfz2Kz2JqNRIjuK1L82ozdo/s1600-h/groupbymonth.jpg)
