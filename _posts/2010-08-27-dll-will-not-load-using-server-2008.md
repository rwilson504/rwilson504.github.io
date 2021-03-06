---
layout: post
title: DLL Will Not Load in FxCop on Windows Server 2008
date: '2010-08-27T13:09:00.003-04:00'
author: Rick Wilson
tags:
- SharePoint 2007 Development
- Development
- Windows Server 2008
modified_time: '2010-08-27T13:11:54.184-04:00'
thumbnail: http://2.bp.blogspot.com/_mr9BzRLR2GQ/THfwSnJWVII/AAAAAAAAFEk/98VzGSUc-tw/s72-c/dllnoload1.jpg
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-8978614873606189430
blogger_orig_url: https://www.richardawilson.com/2010/08/dll-will-not-load-using-server-2008.html
---

I was attempting to install the SharePoint dispose checker into my FxCop program using the rules dll found here, [http://spdisposecheckstatic.codeplex.com/](http://spdisposecheckstatic.codeplex.com/).  After getting everything install I tried running FxCop and received the getting an error that the application could not properly load the assembly.

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/THfwSnJWVII/AAAAAAAAFEk/98VzGSUc-tw/s400/dllnoload1.jpg)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/THfwSnJWVII/AAAAAAAAFEk/98VzGSUc-tw/s1600/dllnoload1.jpg)

**Fix**: 

-Close FxCop

-Right click on the SPDisposeCheckRules.dll and go to the properties of the file.

[![](http://2.bp.blogspot.com/_mr9BzRLR2GQ/THfwQPbYE6I/AAAAAAAAFEU/psi_0NXdTJQ/s320/dllnoload2.jpg)](http://2.bp.blogspot.com/_mr9BzRLR2GQ/THfwQPbYE6I/AAAAAAAAFEU/psi_0NXdTJQ/s1600/dllnoload2.jpg)

-Click the 'Unlock' button on the General tab of the properties form.

[![](http://3.bp.blogspot.com/_mr9BzRLR2GQ/THfwRtpf1bI/AAAAAAAAFEc/1Nz2nzLmqnU/s320/dllnoload3.jpg)](http://3.bp.blogspot.com/_mr9BzRLR2GQ/THfwRtpf1bI/AAAAAAAAFEc/1Nz2nzLmqnU/s1600/dllnoload3.jpg)

-Fun FxCop again and the error should be gone.

