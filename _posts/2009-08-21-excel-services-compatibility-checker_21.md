---
layout: post
title: Excel Services Compatibility Checker
date: '2009-08-21T15:34:00.001-04:00'
author: Rick Wilson
tags:
- Excel Services
- SharePoint 2007
modified_time: '2009-08-21T15:50:23.427-04:00'
thumbnail: http://lh4.ggpht.com/_mr9BzRLR2GQ/So72mCQB55I/AAAAAAAAEWA/Iy1PKCHvjow/s72-c/warning_thumb_3F2EBBCC.jpg
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-1016742437722669664
blogger_orig_url: https://www.richardawilson.com/2009/08/excel-services-compatibility-checker_21.html
---


A while back I had a customer who wished to use Excel Services to do some project reporting dashboards.  After initially uploading the Excel file and configuring Excel Services accordingly I tried opening it with the Excel Web Access web part.  The follow error appeared on the screen.

[![](http://lh4.ggpht.com/_mr9BzRLR2GQ/So72mCQB55I/AAAAAAAAEWA/Iy1PKCHvjow/s400/warning_thumb_3F2EBBCC.jpg)](http://lh4.ggpht.com/_mr9BzRLR2GQ/So72mCQB55I/AAAAAAAAEWA/Iy1PKCHvjow/s800/warning_thumb_3F2EBBCC.jpg)

This and many other things within Excel that can cause similar errors including adding images  or query tables.  If you are using one excel sheet to populate several dashboard it can extremely frustrating when a simple change to your Excel file causes them all to display an error screen.

After searching around for a while I came upon the Excel Services Compatibility Checker.  This tool is available as a download and it allows you to determine what items within your Excel file will cause Excel Services to error out before you upload the file.  Thus avoiding the annoyance of all your dashboards breaking because someone though it would be cool to add an image to the file.

[Click here](http://blogs.msdn.com/cumgranosalis/pages/excel-services-compatibility-checker-download-page.aspx) for the Excel Services Compatibility Checker download page.
[Click here](http://blogs.msdn.com/cumgranosalis/archive/2007/09/14/excel-services-compatibility-checker-build-914-autofix-external-references-finer-control-over-available-checks.aspx) for information on the most recent build of the tool.

