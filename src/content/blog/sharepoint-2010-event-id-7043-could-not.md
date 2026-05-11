---
title: "SharePoint 2010, Event ID 7043: Could not load type 'Microsoft.SharePoint.Portal.WebControls.TaxonomyPicker'"
description: "PROBLEM: Every time the application pool is reset the following error appears in the application log."
pubDate: 2011-05-31
heroImage: "/heroes/sharepoint-2010-event-id-7043-could-not.png"
category: power-apps
tags:
  - "error"
  - "sharepoint-2010"
  - "user-control"
draft: false
originalBloggerUrl: /2011/05/sharepoint-2010-event-id-7043-could-not.html
---

PROBLEM: Every time the application pool is reset the following error appears in the application log.  
  

```
Load control template file /_controltemplates/TaxonomyPicker.ascx failed: Could not load type
'Microsoft.SharePoint.Portal.WebControls.TaxonomyPicker' from assembly
'Microsoft.SharePoint.Portal, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.
```

  

ORIGINAL SOLUTION:   It appeared at first that the problem was with a HTML encoded ',' in the assembly reference of the file which I changed by editing the TaxonomyPicker.ascx file.

[![](/images/sharepoint-2010-event-id-7043-could-not/01-TaxonomyPickerError4.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgS2hzk_aU53bHhQQYolJQss-0pN4FfHX1bd3FW-ZcfpIWxTwGTatIFnfpSXIlf-5tzD8XuHpb-zkoa16mk4cxEM4K0gL78yUcKSOzjqJ7xynGMTIG4XhIZP4MEGGiWcp7WpNPthO2tQMA/s1600/TaxonomyPickerError4.png)

You can see here that the ',' character has been encoded into

```
&#44; 
```

  

[![](/images/sharepoint-2010-event-id-7043-could-not/02-TaxonomyPickerError2.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiqXvP06rsgcjJ20Ii3oNLzbDIPNooTlFUssRry9bmTmkvgQw0ThnSlAOGQBTU01KpwO6qtJ941TA7t34Ky7m_EO7WjOGVfOYpn-pRS1kDicqhSkqVZMzEuPBshjGSVTGNsZx9i2s6K37c/s1600/TaxonomyPickerError2.png)

Below you can see the correct way in which the reference should be done.

  

[![](/images/sharepoint-2010-event-id-7043-could-not/03-TaxonomyPickerError3.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjSbiyTPGkW8yxrzsdA0S7JSZDvdqGCKAyGUmT3TzIBqohENnpRJuO4D2tdfZjmrrhvBu8FNPp08EkvgyGEsiwEc-z7i3VosOFGD3laRj-Oeg6PG1r1lTblUYWTNUf1i6wdRr8x7SxxUUU/s1600/TaxonomyPickerError3.png)

**UPDATED SOLUTION:**  The above updates stopped working and the next time an IISRESET happened the error came back.  After doing some research it appears that the TaxonomyPicker is never actually used.  To finally remove the error I just renamed the file to TaxonomyPicker\_broken.ascx and the errors went away.

[![](/images/sharepoint-2010-event-id-7043-could-not/04-TaxonomyPickerError5.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiRVjxVvDk9O6jVdH0bhBzmTtKjmnvaOgyzGMZWFKfbP8Pp8r440STsFitmrAYibQeuiDwE1jEB34lFlmtiBjQrtUiNVMKlucm3zzdGYmjISSxXUakdvwktEHmkchD7PDNXS-4QYlQFafQ/s1600/TaxonomyPickerError5.png)
