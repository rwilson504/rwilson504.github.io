---
title: "Generating Test Files of A Specific Size"
description: "While attempting to unit test the max upload size of files to CRM I needed to generates files of different sizes."
pubDate: 2019-04-11
category: misc
tags:
  - "testing"
  - "windows"
draft: false
originalBloggerUrl: /2019/04/generating-test-files-of-specific-size.html
---

While attempting to unit test the max upload size of files to CRM I needed to generates files of different sizes.  Since Windows XP came out Microsoft has included a utility called fsutil that you can run at the command line to do just this thing.  

fsutil file createnew filename filesizeinbytes
  

1. Open a Command Prompt (As Administrator)

2. Run the following command

```
fsutil file createnew "c:\temp\test5.txt" 5242880
```

If you need to convert from Megabytes to Bytes you can use this quick converter: [Megabytes to Bytes Converter](https://convertlive.com/u/convert/megabytes/to/bytes#5)
