---
title: "Moving a secondary site collection to a root site collection"
description: "I was recently tasked with migrating a secondary site collection to a new SharePoint server and making it the primary site collection."
pubDate: 2009-09-01
category: power-apps
tags:
  - "migration"
  - "sharepoint-2007-administration"
draft: false
originalBloggerUrl: /2009/09/moving-secondary-site-collection-to.html
---

I was recently tasked with migrating a secondary site collection to a new SharePoint server and making it the primary site collection.   
  
Here is an example of what a URL looks for for a secondary site collection. <http://www.example.com/sites/collection>   
  
Here is an example of what a URL looks like for a root site collection: <http://www.example.com/>   
  
You will notices that secondary site collection are placed by default under /sites/   
  
**Completing the Migration:**   
  
1. Run a backup of the site collection on the original server using STSADM. Here is the command line I used:   
  

```
stsadm -o backup -filename "c:\backups\backup.bak" -url http://www.example.com/sites/collection
```

  
2. Copy the backup file to the new server where a new SharePoint instance is created and contains a new root site collection.   
  
3. Run a restore of the site collection on the new server using STSADM. Here is the command line I used.   
  

```
stsadm -o restore -filename "c:\restores\backup.bak" -url http://www.example.com -overwrite
```

  
Note: you have to use the overwrite parameter since you are restoring over the blank site collection created when SharePoint was set up.   
  
4. Set up the search crawl rules in the Shared Service Provider to Include the new url.   
  
**Issue 1:**  
  
After the site was migrated I started clicking on things to see what would happen. Thing seemed fine until I clicked on a navigation heading. Highlighted in red below is an example of what I mean by "navigation heading."   
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjFAXsv6Wu94yKqGpgso1KBLTrXCr4b9RSJJXPkxL29LHp3cTT4VIFjlkxY1n71L8_TGVttDwQHpZ7-JrZRJ5zQcK_4IzqEOnkqETOGiLmA-h44jdFqXVdk8qHAy-aLn9FNj-NcUVk_6EY/s400/navigationheading.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjFAXsv6Wu94yKqGpgso1KBLTrXCr4b9RSJJXPkxL29LHp3cTT4VIFjlkxY1n71L8_TGVttDwQHpZ7-JrZRJ5zQcK_4IzqEOnkqETOGiLmA-h44jdFqXVdk8qHAy-aLn9FNj-NcUVk_6EY/s1600-h/navigationheading.jpg)

  
For some reason all the navigation heading links still wanted to put /sites/collection/ into the url. I have a lot of sites and really didn't want to hand punch the fixes for all of these links so I created a SQL script to go out and change them. Below is the SQL I used. NOTE: Manipulating SharePoint databases can be bad. Also it's not supported by Microsoft, so if you do it, make a backup... please.  
  

```
/*
Author: Rick Wilson
Date: 8/27/08
Description: This script was used to update a MOSS 2007 primary site collection that was restored from a secondary level site collection (/sites/collection) backup. For some reason the Headings in the site navigation still wanted to use the '/sites/collection' part of the link. This script finds where that old link is being used and removes that section of it. 

How to Reuse:
-Update MOSS_Content MJMOSS to reflect the name of your content database
-Update the number 17 in the STUFF command to reflect the number of characters you want to remove from the URL in my cast there were 17 character is '/sites/collection'
-Update the '/sites/collection' after the LIKE operator to reflect the part of the url you want to remove. Make sure the keep the %% characters or the LIKE won't work.

*/

USE MOSS_Content_MJMOSS
UPDATE [NavNodes] 
SET [Url] = STUFF([Url],1,17, '') 
WHERE [Url] LIKE '%/sites/collection%'
```

  
**Issue 2:**  
  
The sites that were created for this collection used the default SharePoint template. The only modification to the sites was the logo in the upper left hand corner which is set under the site settings. There were about 45 sites that had been created and again I wasn't feeling like manually changing the link for every site. Here is the SQL I wrote the change the logo for me.   
  

```
/*

Author: Rick Wilson
Date: 8/28/08Description: This script was used to update the Site Logo on SharePoint sites.

How to Reuse:
-Update MOSS_Content MJMOSS to reflect the name of your content database.
-Update the url after SET to the new url you have for your logo.
-Update the url after the WHERE operator to the old site logo that was being used.
*/

USE MOSS_Content_MJMOSS
UPDATE [Webs]
SET [SiteLogoURL] = 'http://www.example.com/PublishingImages/YJP.jpg'
WHERE [SiteLogoURL] = 'http://www.oldurl.com/sites/collection/PublishingImages/YJP.jpg'
```
