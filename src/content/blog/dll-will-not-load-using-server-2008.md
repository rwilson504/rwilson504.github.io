---
title: "DLL Will Not Load in FxCop on Windows Server 2008"
description: "I was attempting to install the SharePoint dispose checker into my FxCop program using the rules dll found here, <http://spdisposecheckstatic.codeplex.com/>.…"
pubDate: 2010-08-27
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhmg66YPnofvVoGbVjmQ2_Z5qGXM05WWsOJL0goJnW7JQTdFWZCRr_qzqxCM9kXuvIGefhFLwdFQfqNGvSxyLBtMQQdXN6l-YdTOEaGfxfCDiUW43xzv2sFTnvnkfm1dJp_z0V1tIGo8rQ/s400/dllnoload1.jpg"
category: power-apps
tags:
  - "development"
  - "sharepoint-2007-development"
  - "windows-server-2008"
draft: false
originalBloggerUrl: /2010/08/dll-will-not-load-using-server-2008.html
---

I was attempting to install the SharePoint dispose checker into my FxCop program using the rules dll found here, <http://spdisposecheckstatic.codeplex.com/>.  After getting everything install I tried running FxCop and received the getting an error that the application could not properly load the assembly.  
  
  
**Fix**:   
  
-Close FxCop  
  
-Right click on the SPDisposeCheckRules.dll and go to the properties of the file.  
  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj1L8HuBB2HuABDAC4q-nZO5Qyt1LGmvAehhZmAjsn8MVHyCfo8gB73E85RzBiWlsDql-LVcShFy03USbnXmZ-5KSikNEvUreB5jTQ_OQamNUbGlD7JooSEnTz8D3z_2U7-7KT35nz8kaE/s320/dllnoload2.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj1L8HuBB2HuABDAC4q-nZO5Qyt1LGmvAehhZmAjsn8MVHyCfo8gB73E85RzBiWlsDql-LVcShFy03USbnXmZ-5KSikNEvUreB5jTQ_OQamNUbGlD7JooSEnTz8D3z_2U7-7KT35nz8kaE/s1600/dllnoload2.jpg)

-Click the 'Unlock' button on the General tab of the properties form.

  

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjOfmZIbq_trUFx0muZE7p95_mldnVN8hKjLWkMiePyWttU0-X6EWBbSCXovtddZDbdeYN3cs9JH6nSz7xB1PIQPFtrZ1swWdQgLfxy2N7N_H21H2o94HwM5tq36B3DmBqHepHUkaXswxA/s320/dllnoload3.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjOfmZIbq_trUFx0muZE7p95_mldnVN8hKjLWkMiePyWttU0-X6EWBbSCXovtddZDbdeYN3cs9JH6nSz7xB1PIQPFtrZ1swWdQgLfxy2N7N_H21H2o94HwM5tq36B3DmBqHepHUkaXswxA/s1600/dllnoload3.jpg)

  
-Fun FxCop again and the error should be gone.
