---
layout: post
title: Force Line Break in CRM 2011 Ribbon Labels
date: '2012-02-27T15:07:00.001-05:00'
author: Rick Wilson
tags:
- CRM 2011
- Ribbon
modified_time: '2012-03-01T15:14:01.180-05:00'
thumbnail: http://1.bp.blogspot.com/-L8wTmZ7hX1g/T0vwiYiIfrI/AAAAAAAAGds/49bRT-zo3Tk/s72-c/charmap.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2661257897157319354
blogger_orig_url: https://www.richardawilson.com/2012/02/force-line-break-in-crm-2011-ribbon.html
---

With really long title on CRM ribbon buttons the text will fill the entire space before going to the next line.  In order to for text to the next line you can use the Zero Width Space.  Encoded these characters look like this.

    ```&#x200b;```

In order to actually enter these characters into a text editor the easier way is the use the charmap.exe utility in windows. 

NOTE: If using Windows Server 2008 ensure the Desktop Experience feature installed or the Charmap will not be available.

[![](http://1.bp.blogspot.com/-L8wTmZ7hX1g/T0vwiYiIfrI/AAAAAAAAGds/49bRT-zo3Tk/s320/charmap.png)](http://1.bp.blogspot.com/-L8wTmZ7hX1g/T0vwiYiIfrI/AAAAAAAAGds/49bRT-zo3Tk/s1600/charmap.png)

1. Start->Run->charmap

2. Change the font to Arial Unicode MS

3. Scroll down about 1/6 of the way down and you will see the space characters.

4. Click on the characters until you see that U+200B is selected at the bottom of the screen.

5. Click Select

6. Click Copy

