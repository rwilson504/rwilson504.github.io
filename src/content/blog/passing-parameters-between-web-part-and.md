---
title: "Passing Parameters Between Web Part and User Control"
description: "When creating a web part which encapsulates a custom user control the following is one way to utilize the custom attributes for the web part within the user control."
pubDate: 2011-05-18
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg2anSIJjtzCOM0b8VelawNSdBGTDSqkgFS_TFaRfmShBwd2HWKBnbcR9kPbBaq7iWVzdPYbtH7C2cQsCS_bQ-ui-lmCEz54igJITIL0sZoDt1j6r1f1oBBIysVMEKpHoIuXhL2qV4CCw4/s400/UserControl.png"
category: power-apps
tags:
  - "sharepoint-2007-development"
  - "user-control"
  - "web-part"
draft: false
originalBloggerUrl: /2011/05/passing-parameters-between-web-part-and.html
---

When creating a web part which encapsulates a custom user control the following is one way to utilize the custom attributes for the web part within the user control.  
  
First find the class name of the user control in the code behind of the user control page.  
  

|  |
| --- |
|  |
| User Control Code Behind - Class Name |

Define a web part property in your web part code.  In this case I want users to enter a URL which I will use to load an iframe within the control.

|  |
| --- |
|  |
| Web Part Code - Property Definition |

Next when creating your user control in the web part code make sure to specify the type of the control you are going to add as the class of your user control.  Then you can add attributes to the control which will be accessible when the user control loads.

|  |
| --- |
|  |
| Web Part Code - CreateChildControls() |

Finally you can access the attributes you have added to the control from the code behind on the user control.  In the example below I am retrieving the ViewURL in the user control Page\_Load so that I can update an iframe src with the URL I passed.

  

|  |
| --- |
|  |
| User Control Code Behind - Page\_Load |
