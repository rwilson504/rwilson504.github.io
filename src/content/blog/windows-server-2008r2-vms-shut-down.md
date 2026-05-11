---
title: "Windows Server 2008R2 VMs Shut Down After 1 to 2 Hours"
description: "When created a lab environment to test ADFS 2.0 I utilized the Windows 2008R2 VM baselines distributed by Microsoft. After a few days I was told that I had to activate.…"
pubDate: 2010-11-04
updatedDate: 2011-02-21
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiL52dtrHM0YXpyR56qz6MQ8trr0uLZ3jXhhzwWjAi4WwpK1Pn0EQvZqlsT89tIQ8XKOnpVbIYWuGIE8Co-3zXXYxsn8OXWl5mSdjLKMhYFPMTnUrWdzK-NhPpc8r6jsX45K-KDOv8QWTE/s400/activate1.png"
category: misc
tags:
  - "windows-server-2008"
  - "windows-server-2008r2"
draft: false
originalBloggerUrl: /2010/11/windows-server-2008r2-vms-shut-down.html
---

When created a lab environment to test ADFS 2.0 I utilized the Windows 2008R2 VM baselines distributed by Microsoft.  After a few days I was told that I had to activate.  The VMs included a 180 day license for use but I didn't feel like adding another network adapter into Hyper-V to connect them to the internet.  I started having issues though where the servers would shut down every hour or so.  I though that maybe there was a memory issue and Hyper-V was shutting them down in order to free up RAM.  Turns out that if Server 2008R2 is not activated it automatically shuts down after a period of time.  After connecting the server to the internet and activating them the problem went away.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiL52dtrHM0YXpyR56qz6MQ8trr0uLZ3jXhhzwWjAi4WwpK1Pn0EQvZqlsT89tIQ8XKOnpVbIYWuGIE8Co-3zXXYxsn8OXWl5mSdjLKMhYFPMTnUrWdzK-NhPpc8r6jsX45K-KDOv8QWTE/s400/activate1.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiL52dtrHM0YXpyR56qz6MQ8trr0uLZ3jXhhzwWjAi4WwpK1Pn0EQvZqlsT89tIQ8XKOnpVbIYWuGIE8Co-3zXXYxsn8OXWl5mSdjLKMhYFPMTnUrWdzK-NhPpc8r6jsX45K-KDOv8QWTE/s1600/activate1.png)

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgObwcJJWqO2G_HZP1g0614x_ft5Hf_uHMC1tE9im-bPmP2PyPmB4IIHYxX04L1Vo5z8EPdTazIIhwd1Fp7e2SazfHMPoXtDjECMSplB-aNhV443z5kfeEcs4cUG9FwnW59zEiBDlI4cdo/s400/activate2.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgObwcJJWqO2G_HZP1g0614x_ft5Hf_uHMC1tE9im-bPmP2PyPmB4IIHYxX04L1Vo5z8EPdTazIIhwd1Fp7e2SazfHMPoXtDjECMSplB-aNhV443z5kfeEcs4cUG9FwnW59zEiBDlI4cdo/s1600/activate2.png)[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjfgXN_PSOvYpbK5SxxfYHmUs0VXV2she0_bHLrxMS2UtGiFKr1OcQRv9R3QmOEDDMskAKI8xYtdbvHUFdeV9buJPXVHIi-mD7TyePHYEjxsanCwMsCvTY2iWHfsBjumoRW-TQzWWxjEcg/s400/activate3.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjfgXN_PSOvYpbK5SxxfYHmUs0VXV2she0_bHLrxMS2UtGiFKr1OcQRv9R3QmOEDDMskAKI8xYtdbvHUFdeV9buJPXVHIi-mD7TyePHYEjxsanCwMsCvTY2iWHfsBjumoRW-TQzWWxjEcg/s1600/activate3.png)

  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhF9hn4WTroBJGaT0dXmf1Tj4rY8QZVD95sA2cbjE0Ws71WLZfYR5IakCPoIOzkU5ZlZ5ptxSmuYoDiJuMxKyOduDSafMwyVuLE3_JJm2PUVpNd39w0GAE11NcN91FSFsW-lu6HRFWp_pQ/s320/activate4.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhF9hn4WTroBJGaT0dXmf1Tj4rY8QZVD95sA2cbjE0Ws71WLZfYR5IakCPoIOzkU5ZlZ5ptxSmuYoDiJuMxKyOduDSafMwyVuLE3_JJm2PUVpNd39w0GAE11NcN91FSFsW-lu6HRFWp_pQ/s1600/activate4.png)

Finally the madness of the unknown shut downs has ended :)
