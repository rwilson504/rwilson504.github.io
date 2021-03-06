---
layout: post
title: CRM 2011 Email Router Configuration Wizard might fail during “loading data”
date: '2015-06-29T15:07:00.001-04:00'
author: Rick Wilson
tags: 
modified_time: '2015-06-29T15:07:44.060-04:00'
thumbnail: http://lh3.googleusercontent.com/-EptIB869NHM/VZGXdjsXJcI/AAAAAAAAPWw/Vz9k1mj-MHU/s72-c/022412_1608_CRM2011Emai1_thumb%25255B3%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-6727530437625630922
blogger_orig_url: https://www.richardawilson.com/2015/06/crm-2011-email-router-configuration.html
---


  

**PROBLEM 1**

After you deployed the CRM 2011 on premise and the CRM e-mail router you may experience a problem when loading data from Email Router Configuration manager. 

**Issue**
When you hit the "load data" button on the "User, Queues, and Forward Mailboxes" Tab in the Email Router Configuration manager … 

[![022412_1608_CRM2011Emai1](http://lh3.googleusercontent.com/-EptIB869NHM/VZGXdjsXJcI/AAAAAAAAPWw/Vz9k1mj-MHU/022412_1608_CRM2011Emai1_thumb%25255B3%25255D.png?imgmax=800)](http://lh3.googleusercontent.com/-f7Q3yuSnY9g/VZGXc_benrI/AAAAAAAAPWo/xcaTIck0nPc/s1600-h/022412_1608_CRM2011Emai1%25255B5%25255D.png)

… the e-mail router might not be able to load the data. Within the  CRM platform trace the below error can be seen:  

>Crm Exception: Message: The decryption key could not be obtained because HTTPS protocol is enforced, but not enabled. Enable HTTPS protocol, and try again., ErrorCode: -2147187707, InnerException: Microsoft.Crm.CrmException: The decryption key could not be obtained because HTTPS protocol is enforced, but not enabled. Enable HTTPS protocol, and try again. 

at Microsoft.Crm.ObjectModel.EmailService.GetDecryptionKey(ExecutionContext context)  

On the UI the following error will be reported: 
[![022412_1608_CRM2011Emai2](http://lh3.googleusercontent.com/-gvwM6r6qaJM/VZGXft4eO5I/AAAAAAAAPXA/gGxh9_kK8WE/022412_1608_CRM2011Emai2_thumb.png?imgmax=800)](http://lh3.googleusercontent.com/-4yRrVUmvX0g/VZGXe9_m7zI/AAAAAAAAPW4/Pe4_GOl5XuQ/s1600-h/022412_1608_CRM2011Emai2%25255B2%25255D.png)

**Cause**
The e-mail router expects a HTTPS connection to the CRM website and if SSL is not enabled on the website the request will fail. 

**Workaround**
Add the registry key "DisableSecureDecryptionKey" on the CRM Server. If you configure the value to 1 the email router configuration manager will explicitly check for HTTP. 

1. Click **Start** , click **Run** , type **regedit** , and then click OK . 
2. Locate and then click the following registry key:  

HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSCRM 

3. On the Edit menu, click New , and then click **DWORD** Value . 
4. Set the name of the subkey to **DisableSecureDecryptionKey** . 
5. Right-click DisableSecureDecryptionKey, and then click Modify . 
6. In the Value data box, type** 1** in the Value data field, and then click OK . 
7. On the File menu, click Exit .  

Greetings from the CRM team 

[http://blogs.msdn.com/b/emeadcrmsupport/archive/2011/05/26/crm-2011-email-router-configuration-wizard-might-fail-during-loading-data.aspx](http://blogs.msdn.com/b/emeadcrmsupport/archive/2011/05/26/crm-2011-email-router-configuration-wizard-might-fail-during-loading-data.aspx)

**PROBLEM 2**

Make sure the e-mail user is in the PrivUserGroup security group in AD.  He cannot just be part of a group that is already in the PrivUserGroup the user account must be explicity in the PrivUserGroup.      

