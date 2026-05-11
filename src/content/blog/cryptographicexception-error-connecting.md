---
title: "CryptographicException Error Connecting SharePoint 2007 and ADFS 2.0 Using Domain App Pool User with SharePoint"
description: "When attempting to connect ADFS 2.0 and SharePoint 2007 most of the documentation assumes you are using the NetworkService account to run the application pools for the SharePoint content web…"
pubDate: 2010-10-25
heroImage: "/heroes/cryptographicexception-error-connecting.png"
category: power-apps
tags:
  - "adfs-2"
  - "iis"
  - "sharepoint-2007"
  - "windows-server-2008r2"
draft: false
originalBloggerUrl: /2010/10/cryptographicexception-error-connecting.html
---

When attempting to connect ADFS 2.0 and SharePoint 2007 most of the documentation assumes you are using the NetworkService account to run the application pools for the SharePoint content web applications.  In a real world environment though a domain user is probably running the app pools.  
  
Tech Specs:  
  
SharePoint Version: 2007  
ADFS Version: 2.0  
Server OS: 2008R2  
  
ADFS URL: <https://lab-adfs.defenseready.local/>  
SharePoint 2007 URL: <https://ext.defenseready.local/>  
SharePoint App Pool User: defenseready\spapppool  
  
What Happens:  
  

|  |
| --- |
|  |
| Users opens the browser and navigates to the site. |

﻿﻿﻿﻿﻿   

|  |
| --- |
|  |
| Enter user information and click Sign In |

﻿﻿﻿﻿﻿﻿   

|  |
| --- |
|  |
| The user now is presented with the error that An unexpected error has occurred. |

﻿   

How to diagnose:

In order to diagnose we will need to update the web.config for the SharePoint site.

|  |
| --- |
|  |
| First find the CallStack attribute and set it to true |

|  |
| --- |
|  |
| Secondly change the customErrors mode attribute to Off |

Error:  
  
When we repeat the steps earlier and try to access the site we can now see the full error.  
  
﻿   

|  |
| --- |
|  |
| SharePoint is reporting a CryptographicException |

﻿ How to Resolve:  
  
In order to give the application pool the correct rights to load the certificates we need to update the application pool settings.   Specifically we need to update the Load User Profile setting to True.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdr1eqEFRORbDBTEWWj2_W05tdRk2CtFZFARgKd2c-G0Ow6I6JkONSLA8g273a7s40gxGlfYH7-gXqF9zY_ucCSw9y89l602-PMCJbcgdsK_QpjtcXvTfgKvpfcI68s3rojKHgV61OF6w/s400/sharepointapppool.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdr1eqEFRORbDBTEWWj2_W05tdRk2CtFZFARgKd2c-G0Ow6I6JkONSLA8g273a7s40gxGlfYH7-gXqF9zY_ucCSw9y89l602-PMCJbcgdsK_QpjtcXvTfgKvpfcI68s3rojKHgV61OF6w/s1600/sharepointapppool.png)

  
 After you have updated this restart IIS and give it another try.  
![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjjurb95KwrH3hMx5bqQrCKhSzeN6LbvgutQ3Pmss2ISXlE6bPIsw4afQ2pjKN2MILpVGf7-w4RWUoIVCc_n1H87hWmmArSH8AfhAjWvAxh-wcObqZgsYC5BFB_fwjDFdPemx9IeJcznVo/s320/spwebconfig1.png)
