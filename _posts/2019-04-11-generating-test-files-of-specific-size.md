---
layout: post
title: Generating Test Files of A Specific Size
date: '2019-04-11T12:57:00.002-04:00'
author: Rick Wilson
tags:
- Windows
- Testing
modified_time: '2019-04-11T12:58:09.443-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-359596173124012957
blogger_orig_url: https://www.richardawilson.com/2019/04/generating-test-files-of-specific-size.html
---

While attempting to unit test the max upload size of files to CRM I needed to generates files of different sizes.  Since Windows XP came out Microsoft has included a utility called fsutil that you can run at the command line to do just this thing.

fsutil file createnew filename filesizeinbytes 

1. Open a Command Prompt (As Administrator)

2. Run the following command

    fsutil file createnew "c:\temp\test5.txt" 5242880

If you need to convert from Megabytes to Bytes you can use this quick converter: [Megabytes to Bytes Converter](https://convertlive.com/u/convert/megabytes/to/bytes#5)

