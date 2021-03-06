---
layout: post
title: ADFS 2.1 & 3.0 Config Debug Tracing
date: '2015-08-12T13:16:00.001-04:00'
author: Rick Wilson
tags:
- ADFS
- ADFS 2.1
- ADFS 3.0
modified_time: '2015-08-20T21:49:02.374-04:00'
thumbnail: http://lh3.googleusercontent.com/-W1eLAabu2Rc/Vct_dHa4xLI/AAAAAAAAQaY/FirBo3PtXqk/s72-c/ADFS2.13.0Tracing_thumb%25255B2%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-5471776695435706113
blogger_orig_url: https://www.richardawilson.com/2015/08/adfs-21-30-config-debug-tracing.html
---


1. Run CMD as Administrator  
2. WEVTUTIL sl "AD FS Tracing/Debug" /l:5  
3. Open the file “C:\Windows\ADFS\Microsoft.IdentityServer.Servicehost.exe.config”  
4. Find the following sections shown in the image
[![ADFS2.13.0Tracing](http://lh3.googleusercontent.com/-W1eLAabu2Rc/Vct_dHa4xLI/AAAAAAAAQaY/FirBo3PtXqk/ADFS2.13.0Tracing_thumb%25255B2%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-yq1wgH7-Lh0/Vct_ca-rAKI/AAAAAAAAQaU/ADdnQ01m_WU/s1600-h/ADFS2.13.0Tracing%25255B4%25255D.png)
5. Update the switchValues for **Microsoft.IdentityModel** and **System.ServiceModel** to **Verbose** instead of Off.  Also remove the comments from around the **system.serviceModel** section.
[![ADFS2.13.0TracingDone](http://lh3.googleusercontent.com/-FEd48A_ElIQ/Vct_eAKJVwI/AAAAAAAAQas/k6-Sr9W7Grk/ADFS2.13.0TracingDone_thumb%25255B2%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-3XVpsVBF9wU/Vct_diSMejI/AAAAAAAAQak/g-BzfRtpLEY/s1600-h/ADFS2.13.0TracingDone%25255B4%25255D.png)
6. Open Event Viewer.  
7. To open Event Viewer, click **Start**, point to **Programs**, point to **Administrative Tools**, and then click **Event Viewer**.  
8. On the **View** menu, click **Show Analytic and Debug Logs**.  
9. In the console tree, expand **Applications and Services Logs**, expand **AD FS Tracing**, and then click **Debug**.  
10. In the **Actions** pane, click **Enable Log**.  
11. Tracing for AD FS is now enabled.  
12. Restart the **Active Directory FederationServices **windows service. 
13. Open the AD FS Management tool 
14. Right click on the **Service** folder and select **Edit Federation Service Properties…**
[![ADFS Events](http://lh3.googleusercontent.com/-ATI_Y66fr5c/VdaDiOhQDSI/AAAAAAAAQjk/KUVM8-sBx6I/ADFS%252520Events_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Z2e4R2n-rL8/VdaDhdg3-sI/AAAAAAAAQjg/yEpJ0s25KOU/s1600-h/ADFS%252520Events%25255B3%25255D.png)
15. Select the Events tab and select all the checkboxes to make sure all errors will be displayed in the event log.
[![ADFS Events 2](http://lh3.googleusercontent.com/-x-ivWISshNo/VdaDjJBrAhI/AAAAAAAAQj4/dUOrTPocj8I/ADFS%252520Events%2525202_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-Q6EvVxNWfCw/VdaDigo0XyI/AAAAAAAAQjw/wm4ZCFTSiqE/s1600-h/ADFS%252520Events%2525202%25255B3%25255D.png)

