---
title: "CRM 2011 Email Router Configuration Wizard might fail during “loading data”"
description: "PROBLEM 1"
pubDate: 2015-06-29
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigdDjgvFXnbNrZTSjDZ_Hcog1MEDZd_ryLVtRqUYJMeu_OsI2PKIExOP5Wq-WD42fdUSJBL2zieF5HZ7sP352YaKD0QZnZAsIDXIVZ0mvCFcq81642JoOQ2hWf2Sq0Jb8caDrGjuHhSFU/?imgmax=800"
heroImageAlt: "022412_1608_CRM2011Emai1"
category: power-apps
tags: []
draft: false
originalBloggerUrl: /2015/06/crm-2011-email-router-configuration.html
---

**PROBLEM 1**

After you deployed the CRM 2011 on premise and the CRM e-mail router you may experience a problem when loading data from Email Router Configuration manager.

**Issue**  
When you hit the "load data" button on the "User, Queues, and Forward Mailboxes" Tab in the Email Router Configuration manager …

[![022412_1608_CRM2011Emai1](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigdDjgvFXnbNrZTSjDZ_Hcog1MEDZd_ryLVtRqUYJMeu_OsI2PKIExOP5Wq-WD42fdUSJBL2zieF5HZ7sP352YaKD0QZnZAsIDXIVZ0mvCFcq81642JoOQ2hWf2Sq0Jb8caDrGjuHhSFU/?imgmax=800 "022412_1608_CRM2011Emai1")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEisjdKQjDAG_UNLk6iZYGJgPFzu3fDyz7-CXLLUGghfd3z8ieJStzN0XnExL4U-8Mh_rbH2aHyqBtd8JPzHyWh8TvHtTDEsXmHld0fT9ZmPyRvbsRbWUwmg5scEGr-zhgTfrIJ7oXmHAVI/s1600-h/022412_1608_CRM2011Emai1%25255B5%25255D.png)

… the e-mail router might not be able to load the data. Within the  CRM platform trace the below error can be seen:

>Crm Exception: Message: The decryption key could not be obtained because HTTPS protocol is enforced, but not enabled. Enable HTTPS protocol, and try again., ErrorCode: -2147187707, InnerException: Microsoft.Crm.CrmException: The decryption key could not be obtained because HTTPS protocol is enforced, but not enabled. Enable HTTPS protocol, and try again.

at Microsoft.Crm.ObjectModel.EmailService.GetDecryptionKey(ExecutionContext context)

On the UI the following error will be reported:   
[![022412_1608_CRM2011Emai2](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEikeWBSJt0REFqRyCs2fHuHH7j8BES0ji3BUo1teiEjmur9ChHa34sEar7Wmrreo11tXoqq7P71gH4UsNmxyeBg4EzyiDysRLFyGY_21U48fWZor1Q7AlP5yONB5hPRAfb1BbGLUzwm5Zc/?imgmax=800 "022412_1608_CRM2011Emai2")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhPJlqzGRCEZEMgDh_W3akeis-S_NLaCIQHUsibhf__9E9OEKBu9NVX0fgilU0bVxFECmQ9qqumsLNzgV4Fm0B2XMK8p_5uj6h8JPCszFq4KIZJ_SkYTFdrA45eJBx-UAmthYP2iGJjuyA/s1600-h/022412_1608_CRM2011Emai2%25255B2%25255D.png)

**Cause**  
The e-mail router expects a HTTPS connection to the CRM website and if SSL is not enabled on the website the request will fail.

**Workaround**  
Add the registry key "DisableSecureDecryptionKey" on the CRM Server. If you configure the value to 1 the email router configuration manager will explicitly check for HTTP.

1. Click **Start** , click **Run** , type **regedit** , and then click OK .   
2. Locate and then click the following registry key:

HKEY\_LOCAL\_MACHINE\SOFTWARE\Microsoft\MSCRM

3. On the Edit menu, click New , and then click **DWORD** Value .   
4. Set the name of the subkey to **DisableSecureDecryptionKey** .   
5. Right-click DisableSecureDecryptionKey, and then click Modify .   
6. In the Value data box, type **1** in the Value data field, and then click OK .   
7. On the File menu, click Exit .

Greetings from the CRM team

<http://blogs.msdn.com/b/emeadcrmsupport/archive/2011/05/26/crm-2011-email-router-configuration-wizard-might-fail-during-loading-data.aspx>

**PROBLEM 2**

Make sure the e-mail user is in the PrivUserGroup security group in AD.  He cannot just be part of a group that is already in the PrivUserGroup the user account must be explicity in the PrivUserGroup.
