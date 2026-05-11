---
title: "Display ADFS 2.0 Forms Authentication Login Page Instead of Windows Authentication Prompt"
description: "After installing ADFS 2.0 for SharePoint a Windows login prompt was shown when the SharePoint site forwarded to the ADFS server instead of the ADFS Forms Authentication login screen."
pubDate: 2010-10-23
updatedDate: 2010-11-05
category: power-apps
tags:
  - "adfs-2"
  - "authentication"
  - "iis"
draft: false
originalBloggerUrl: /2010/10/adfs-20-login-page.html
---

After installing ADFS 2.0 for SharePoint a Windows login prompt was shown when the SharePoint site forwarded to the ADFS server instead of the ADFS Forms Authentication login screen.    
  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjhxLEkZEkBRAyLgzL0u2ZWx_l_pyX5uw7gy0HlNVXuU-GyknLrYGcLzhRruAzUBC-UzuovXHzHT92ZqsjbCCpSwcigzvl93LzR6I2RfpvXoHoXtNY2v_KwkionFKDnLmqTrjIseWFj7TE/s320/adfsloginprompt.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjhxLEkZEkBRAyLgzL0u2ZWx_l_pyX5uw7gy0HlNVXuU-GyknLrYGcLzhRruAzUBC-UzuovXHzHT92ZqsjbCCpSwcigzvl93LzR6I2RfpvXoHoXtNY2v_KwkionFKDnLmqTrjIseWFj7TE/s1600/adfsloginprompt.png)

No matter what account I tried to use here I would eventually receive a 401 Not Auhorized error.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj3uMm2VSYCOVEyWvbA17HvJB1w11ZIIigHgz_7Thc-7tL5UiXxjQYkgXO5a3ftm0fi6iD9jIUl09gn7F0KMwKvX7JgU-CtspOlMhPFEH8_tletRasdQ2IuGLyAa5D5C6UZ3p8k54W_2tE/s400/adfs+401+error.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj3uMm2VSYCOVEyWvbA17HvJB1w11ZIIigHgz_7Thc-7tL5UiXxjQYkgXO5a3ftm0fi6iD9jIUl09gn7F0KMwKvX7JgU-CtspOlMhPFEH8_tletRasdQ2IuGLyAa5D5C6UZ3p8k54W_2tE/s1600/adfs+401+error.png)

  
The reason for this is that the ADFS website tries to use Windows Authentication before trying to use the Forms authentication which displays the loging page below.  
  
﻿   

|  |
| --- |
|  |
| Forms Login Screen for ADFS 2.0 |

﻿   

To fix this do the following on the ADFS server:

1. Open IIS and Explore under Default Website\adfs\ls

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhKMiHT12ylGPs5rIpoHcbkQyXOP0OSwqoj3THb5ANX1HT2s14j5kMcXrlQEwFK7kJEPpU_NwH_GRD0YPjjusgClM51ridUjjPfj0irxDxRxobcqG4lIxc27QVeYGwPHEa2k2Xx2PJMN8o/s400/adfsexplore.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhKMiHT12ylGPs5rIpoHcbkQyXOP0OSwqoj3THb5ANX1HT2s14j5kMcXrlQEwFK7kJEPpU_NwH_GRD0YPjjusgClM51ridUjjPfj0irxDxRxobcqG4lIxc27QVeYGwPHEa2k2Xx2PJMN8o/s1600/adfsexplore.png)

2. Open the web.config file with Notepad, look for the localAuthenticationTypes section.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjzDIKZwcBSpJ4Aqx6KUswZ9Hh-PUI8dpxnr69JasTKeKj8wkMHHE3DKr7GDYLeP6LWcGhN8GyfwpIYU6pygdVT8a0Ewb3ZzIWArEv5s3y-MybHkU7JiceOkdOVYS78gwagBas-ri0xUrM/s400/adfslocalauthenticationtypes.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjzDIKZwcBSpJ4Aqx6KUswZ9Hh-PUI8dpxnr69JasTKeKj8wkMHHE3DKr7GDYLeP6LWcGhN8GyfwpIYU6pygdVT8a0Ewb3ZzIWArEv5s3y-MybHkU7JiceOkdOVYS78gwagBas-ri0xUrM/s1600/adfslocalauthenticationtypes.png)

3. Move the line for Forms above the line for Integrated and save the web.config file.  This will force the ADFS application to use the Login Page authentication before trying to use Windows Authentication.

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhzxoLQy6-axLt-_ogcobp0c4x7KLlzvgy2q3fAkZWGEosz-Fxqq5Tk5U1M51M2dxhWY4wRmHj0wf2SYsa_QQhyphenhyphen9BxCxytTuH9ByphbF1T4B5jfG8LTD0xMkwlFRgXltU-GgO4ASxLZEcY/s400/adfsformsabove.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhzxoLQy6-axLt-_ogcobp0c4x7KLlzvgy2q3fAkZWGEosz-Fxqq5Tk5U1M51M2dxhWY4wRmHj0wf2SYsa_QQhyphenhyphen9BxCxytTuH9ByphbF1T4B5jfG8LTD0xMkwlFRgXltU-GgO4ASxLZEcY/s1600/adfsformsabove.png)
