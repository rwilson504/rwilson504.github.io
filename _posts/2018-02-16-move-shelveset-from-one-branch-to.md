---
layout: post
title: 'Move Shelveset from One Branch to Another '
date: '2018-02-16T09:46:00.002-05:00'
author: Rick Wilson
tags:
- TFS
modified_time: '2018-03-15T14:00:24.345-04:00'
thumbnail: https://2.bp.blogspot.com/--L2yE3YoVpA/WobtVTFKp-I/AAAAAAAA0is/Z3P3ySddZOUvDuquEBAWBl_DJ7deFuZtQCLcBGAs/s72-c/2018-02-16%2B09_39_47-rick.anycom.us%2B-%2BRemote%2BDesktop%2BConnection%2BManager%2Bv2.7.png
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7774871056477207082
blogger_orig_url: https://www.richardawilson.com/2018/02/move-shelveset-from-one-branch-to.html
---

This can be useful if you start working on the wrong branch and need to move your uncommitted code to the correct branch.

Pre-Reqs.
-You will need to have the TFS Power Tools installed.
https://www.microsoft.com/en-us/download/details.aspx?id=35775
-Make sure the path of your command prompt on your project path
eg. c:\TFS\Rick.Wilson\Web Resources
-Get latest on the source and target branches to avoid this error: "Unable to determine the workspace."
-Create your shelveset and make sure you don't have any pending changes in either branch to avoid this error: "An item with the same key has already been added"  

Instructions
-Shelve your changes
-Open a Visual Studio Command Prompt
-Run the following command

tfpt unshelve /migrate /source:"$/Project/CurrentBranch" /target:"$/Project/NewBranch" "Shelveset Name"

-A shelveset details window will come up, click the Unshelv button.
-Next the Unshelv/Merge window will come up, click the Auto-merg button.
 The command prompt will then start showing the merges into the new branch. [![](https://2.bp.blogspot.com/--L2yE3YoVpA/WobtVTFKp-I/AAAAAAAA0is/Z3P3ySddZOUvDuquEBAWBl_DJ7deFuZtQCLcBGAs/s320/2018-02-16%2B09_39_47-rick.anycom.us%2B-%2BRemote%2BDesktop%2BConnection%2BManager%2Bv2.7.png)](https://2.bp.blogspot.com/--L2yE3YoVpA/WobtVTFKp-I/AAAAAAAA0is/Z3P3ySddZOUvDuquEBAWBl_DJ7deFuZtQCLcBGAs/s1600/2018-02-16%2B09_39_47-rick.anycom.us%2B-%2BRemote%2BDesktop%2BConnection%2BManager%2Bv2.7.png)

