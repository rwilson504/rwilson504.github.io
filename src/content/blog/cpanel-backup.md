---
title: "cPanel - Backup"
description: "After having my e-mail accidentally removed and LunarPages.com charging me $75 dollars to have it restored I created a backup script to download the automated cPanel backups.…"
pubDate: 2009-08-21
updatedDate: 2009-09-01
category: misc
tags:
  - "backup"
  - "cpanel"
  - "horde"
draft: false
originalBloggerUrl: /2009/08/cpanel-backup.html
---

After having my e-mail accidentally removed and LunarPages.com charging me $75 dollars to have it restored I created a backup script to download the automated cPanel backups. I found a lot of other backups on the internet that used PHP and Perl to do this but since I was using cPanel proxy they would not work.  
  
This script can be set up using windows scheduling service. I have it run one a week. Additionally using the /d switch and the 'backups' setting you can make it delete old backups. Eg. If you want to keep the 3 most recent backups then set the 'backups' equal to 3. Please let me know if you have any comment or suggestion for this script.  
  
[Click here to download](http://rwilson504.googlepages.com/cPanelBackupRelease.zip)
