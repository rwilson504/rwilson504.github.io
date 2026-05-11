---
title: "Register Bamboo Calendar Web Part"
description: "I recently downloaded the Bamboo Calendar Plus Web Part v2.5. I ran the setup file and installed both the Calendar Plus Web Part and the Bamboo License Manager v2.7. Here are the issues I ran into:"
pubDate: 2009-09-01
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgfAq2p5_GB6ansf8t2dpI4HvsDJ5eMZSw7dxrs1JQzGyYnaRTL9RaPzW3_pt4t8KQye5etBqQZjvjBTR_19dluBNqaaJdwRblF2pcatJIuKFxdJsC4vX9619HoKYKJHjrOwH1viPmCHBI/s400/bambooinstaller.png"
category: power-apps
tags:
  - "sharepoint-2007"
  - "web-part"
draft: false
originalBloggerUrl: /2009/09/register-bamboo-calendar-web-part.html
---

I recently downloaded the Bamboo Calendar Plus Web Part v2.5. I ran the setup file and installed both the Calendar Plus Web Part and the Bamboo License Manager v2.7. Here are the issues I ran into:  
  
Firstly, you will need to be connected to the internet to get the registration program to correctly activate the web part. Otherwise you will have to activate by e-mail or phone.  
  
Secondly, the Calendar web part .dll is not located in the GAC so I had to go out and search for it. The .dll was located in <System Drive>:\Inetpub\wwwroot\wss\VirtualDirectories\80\bin\Bamboo.CalendarViewExtended.dll. In my case my VirtualDirectory was 80 but for others this may be different. Also if you installed the web part into multiple web application you will also need to activate the product by located the .dll under the other VirtualDirectories folders.  
  
Then after selecting the .ddl file in the License Manager I entered the product code. I accidently entered an incorrect product code. Then came the BLUE SCREEN OF DEATH from Windows Server 2003. I don't know about you but that is scary.  
  
After my server restarted I then ran the License Manger again... this time using the correct product code. I was then able to activate the .dll file located in the multiple web application I installed it in.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgfAq2p5_GB6ansf8t2dpI4HvsDJ5eMZSw7dxrs1JQzGyYnaRTL9RaPzW3_pt4t8KQye5etBqQZjvjBTR_19dluBNqaaJdwRblF2pcatJIuKFxdJsC4vX9619HoKYKJHjrOwH1viPmCHBI/s400/bambooinstaller.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgfAq2p5_GB6ansf8t2dpI4HvsDJ5eMZSw7dxrs1JQzGyYnaRTL9RaPzW3_pt4t8KQye5etBqQZjvjBTR_19dluBNqaaJdwRblF2pcatJIuKFxdJsC4vX9619HoKYKJHjrOwH1viPmCHBI/s1600-h/bambooinstaller.png)
