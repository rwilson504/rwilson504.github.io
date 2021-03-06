---
layout: post
title: Passing Parameters Between Web Part and User Control
date: '2011-05-18T11:22:00.004-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Development
- Web Part
- User Control
modified_time: '2011-05-18T11:28:08.826-04:00'
thumbnail: http://3.bp.blogspot.com/-n2R7w7AUisw/TdPhY-gV8WI/AAAAAAAAGQU/s6SGNGKtx9E/s72-c/UserControl.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-3101667338627131202
blogger_orig_url: https://www.richardawilson.com/2011/05/passing-parameters-between-web-part-and.html
---

When creating a web part which encapsulates a custom user control the following is one way to utilize the custom attributes for the web part within the user control.

First find the class name of the user control in the code behind of the user control page.

[![](http://3.bp.blogspot.com/-n2R7w7AUisw/TdPhY-gV8WI/AAAAAAAAGQU/s6SGNGKtx9E/s400/UserControl.png)](http://3.bp.blogspot.com/-n2R7w7AUisw/TdPhY-gV8WI/AAAAAAAAGQU/s6SGNGKtx9E/s1600/UserControl.png)User Control Code Behind - Class Name
Define a web part property in your web part code.  In this case I want users to enter a URL which I will use to load an iframe within the control.

[![](http://3.bp.blogspot.com/-gUd6-DPgnao/TdPjw6tJxnI/AAAAAAAAGQg/wzqFOHS4QlM/s400/WebPartProperty.png)](http://3.bp.blogspot.com/-gUd6-DPgnao/TdPjw6tJxnI/AAAAAAAAGQg/wzqFOHS4QlM/s1600/WebPartProperty.png)Web Part Code - Property Definition
Next when creating your user control in the web part code make sure to specify the type of the control you are going to add as the class of your user control.  Then you can add attributes to the control which will be accessible when the user control loads.

[![](http://1.bp.blogspot.com/-YeGP9cgqBZk/TdPhZQ5NYeI/AAAAAAAAGQc/6ERt4QMHV0g/s400/WebPart.png)](http://1.bp.blogspot.com/-YeGP9cgqBZk/TdPhZQ5NYeI/AAAAAAAAGQc/6ERt4QMHV0g/s1600/WebPart.png)Web Part Code - CreateChildControls()

Finally you can access the attributes you have added to the control from the code behind on the user control.  In the example below I am retrieving the ViewURL in the user control Page_Load so that I can update an iframe src with the URL I passed.

[![](http://2.bp.blogspot.com/-s7lwBHT6vQ4/TdPhZDK-aPI/AAAAAAAAGQY/5FSTCFsBO4o/s400/UserControlPageLoad.png)](http://2.bp.blogspot.com/-s7lwBHT6vQ4/TdPhZDK-aPI/AAAAAAAAGQY/5FSTCFsBO4o/s1600/UserControlPageLoad.png)User Control Code Behind - Page_Load

