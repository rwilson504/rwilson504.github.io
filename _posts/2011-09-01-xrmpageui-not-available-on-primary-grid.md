---
layout: post
title: Xrm.Page.ui Not Available on Primary Grid
date: '2011-09-01T09:50:00.001-04:00'
author: Rick Wilson
tags:
- CRM 2011
- Ribbon
- Javascript
modified_time: '2011-09-01T09:50:22.105-04:00'
thumbnail: http://lh4.ggpht.com/-FFpKMUY4BC4/Tl-NmFjILdI/AAAAAAAAGZQ/_3SZCkoRg90/s72-c/test_thumb%25255B1%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-604328805267791472
blogger_orig_url: https://www.richardawilson.com/2011/09/xrmpageui-not-available-on-primary-grid.html
---


&#160;

While developing an EnableRule for some new functionality I decided to use an Async call.&#160; Here is a great link on how to use Async calls with EnableRule.

[http://myencounterwithcrm.wordpress.com/2011/06/09/walkthrough-of-asynchronous-call-from-customrule-ribbondiff/](http://myencounterwithcrm.wordpress.com/2011/06/09/walkthrough-of-asynchronous-call-from-customrule-ribbondiff/)

Microsoft even notes this strategy in the SDK documentation:&#160; 
[![test](http://lh4.ggpht.com/-FFpKMUY4BC4/Tl-NmFjILdI/AAAAAAAAGZQ/_3SZCkoRg90/test_thumb%25255B1%25255D.png?imgmax=800)](http://lh5.ggpht.com/-U3mjjWeVkI0/Tl-Nl9FODhI/AAAAAAAAGZM/BJGMH-UM2ro/s1600-h/test%25255B4%25255D.png)

Consider that Microsoft sees this as the “proper way” to do things you might think that they would provide the necessary methods to complete this, that would only be half correct.

All of this works if you are on an entity form because Xrm.Page.ui.refreshRibbon() is available.&#160; Unfortunately if you are in a grid such as the one displayed below, Xrm.Page.ui is null, which means you cannot call the refreshRibbon() method.

[![test2](http://lh3.ggpht.com/-ehilNMs4Cdo/Tl-NnGcvZeI/AAAAAAAAGZY/vP1EGsY2NS4/test2_thumb%25255B2%25255D.png?imgmax=800)](http://lh3.ggpht.com/-V4ad9IUSen0/Tl-NmvMZiUI/AAAAAAAAGZU/UDjo4bQEfX4/s1600-h/test2%25255B5%25255D.png)

DAGGER!!!!!!

If anyone knows a way in which to get around this please leave a comment ![Smile](http://lh3.ggpht.com/-YFt9LxZdOH4/Tl-NnWu2PjI/AAAAAAAAGZc/mQjQWAPSlTg/wlEmoticon-smile%25255B2%25255D.png?imgmax=800)

