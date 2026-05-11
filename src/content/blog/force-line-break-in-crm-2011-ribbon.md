---
title: "Force Line Break in CRM 2011 Ribbon Labels"
description: "With really long title on CRM ribbon buttons the text will fill the entire space before going to the next line. In order to for text to the next line you can use the Zero Width Space.…"
pubDate: 2012-02-27
updatedDate: 2012-03-01
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi8iFtBVRLPL_N9Jpa5zwHMCGkzFACY6r0letg7gHMa01npBxVjJXbCArbRfFzlO6nzrOBmtJJAi0OT-TZ9KNI3BzIhJJW-ia_RPo_ydkmoui4ZlplcnUX5aAddGYPlyelGRJvmk-MwM7A/s320/charmap.png"
category: power-apps
tags:
  - "crm-2011"
  - "ribbon"
draft: false
originalBloggerUrl: /2012/02/force-line-break-in-crm-2011-ribbon.html
---

With really long title on CRM ribbon buttons the text will fill the entire space before going to the next line.  In order to for text to the next line you can use the Zero Width Space.  Encoded these characters look like this.  

```
&#x200b;
```

In order to actually enter these characters into a text editor the easier way is the use the charmap.exe utility in windows.   
  
**NOTE**: If using Windows Server 2008 ensure the Desktop Experience feature installed or the Charmap will not be available.

1. Start->Run->charmap

2. Change the font to Arial Unicode MS

3. Scroll down about 1/6 of the way down and you will see the space characters.

4. Click on the characters until you see that U+200B is selected at the bottom of the screen.

5. Click Select

6. Click Copy
