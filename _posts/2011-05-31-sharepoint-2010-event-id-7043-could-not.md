---
layout: post
title: 'SharePoint 2010, Event ID 7043: Could not load type Microsoft.SharePoint.Portal.WebControls.TaxonomyPicker'
date: '2011-05-31T10:35:00.002-04:00'
author: Rick Wilson
tags:
- Error
- SharePoint 2010
- User Control
modified_time: '2011-05-31T10:36:50.280-04:00'
thumbnail: http://2.bp.blogspot.com/-W3fPmLPCkdc/TeT4I7XsjGI/AAAAAAAAGQk/D9fPOaJEAyA/s72-c/TaxonomyPickerError1.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1294483259728727550
blogger_orig_url: https://www.richardawilson.com/2011/05/sharepoint-2010-event-id-7043-could-not.html
---

PROBLEM: Every time the application pool is reset the following error appears in the application log.

```Load control template file /_controltemplates/TaxonomyPicker.ascx failed: Could not load type
    'Microsoft.SharePoint.Portal.WebControls.TaxonomyPicker' from assembly
    'Microsoft.SharePoint.Portal, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.
```

[![](http://2.bp.blogspot.com/-W3fPmLPCkdc/TeT4I7XsjGI/AAAAAAAAGQk/D9fPOaJEAyA/s400/TaxonomyPickerError1.png)](http://2.bp.blogspot.com/-W3fPmLPCkdc/TeT4I7XsjGI/AAAAAAAAGQk/D9fPOaJEAyA/s1600/TaxonomyPickerError1.png)

ORIGINAL SOLUTION:   It appeared at first that the problem was with a HTML encoded ',' in the assembly reference of the file which I changed by editing the TaxonomyPicker.ascx file.

[![](http://2.bp.blogspot.com/-1N3LmZyQx6Y/TeT4JnrH16I/AAAAAAAAGQw/N9hzNXg3hgo/s400/TaxonomyPickerError4.png)](http://2.bp.blogspot.com/-1N3LmZyQx6Y/TeT4JnrH16I/AAAAAAAAGQw/N9hzNXg3hgo/s1600/TaxonomyPickerError4.png)

You can see here that the ',' character has been encoded into 

 ```&#44;``` 

[![](http://2.bp.blogspot.com/-Y5kBpQPM974/TeT4JNMHKoI/AAAAAAAAGQo/gHlYNjspecY/s400/TaxonomyPickerError2.png)](http://2.bp.blogspot.com/-Y5kBpQPM974/TeT4JNMHKoI/AAAAAAAAGQo/gHlYNjspecY/s1600/TaxonomyPickerError2.png)

Below you can see the correct way in which the reference should be done.

[![](http://3.bp.blogspot.com/-rsZ6C7CRvsM/TeT4JTlzl5I/AAAAAAAAGQs/ElvHMaCZuvM/s400/TaxonomyPickerError3.png)](http://3.bp.blogspot.com/-rsZ6C7CRvsM/TeT4JTlzl5I/AAAAAAAAGQs/ElvHMaCZuvM/s1600/TaxonomyPickerError3.png)

UPDATED SOLUTION:  The above updates stopped working and the next time an IISRESET happened the error came back.  After doing some research it appears that the TaxonomyPicker is never actually used.  To finally remove the error I just renamed the file to TaxonomyPicker_broken.ascx and the errors went away.

[http://3.bp.blogspot.com/-rsZ6C7CRvsM/TeT4JTlzl5I/AAAAAAAAGQs/ElvHMaCZuvM/s1600/TaxonomyPickerError3.png](http://3.bp.blogspot.com/-rsZ6C7CRvsM/TeT4JTlzl5I/AAAAAAAAGQs/ElvHMaCZuvM/s1600/TaxonomyPickerError3.png)[![](http://2.bp.blogspot.com/-ady8Pv8X6ck/TeT5mQ26ZtI/AAAAAAAAGQ0/rU5e9As3Dog/s400/TaxonomyPickerError5.png)](http://2.bp.blogspot.com/-ady8Pv8X6ck/TeT5mQ26ZtI/AAAAAAAAGQ0/rU5e9As3Dog/s1600/TaxonomyPickerError5.png)

