---
layout: post
title: Install/Update Certificate for Remote Desktop Gateway
date: '2013-02-04T11:08:00.001-05:00'
author: Rick Wilson
tags:
- Remote Desktop
- Windows Server 2008R2
- Certificates
- Windows Server 2008
modified_time: '2013-02-04T11:08:40.018-05:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7192689376247525512
blogger_orig_url: https://www.richardawilson.com/2013/02/installupdate-certificate-for-remote.html
---


 

To import a certificate to the RD Gateway server in the (Local Computer)/Personal Store 
---

1. 
Open the Certificates snap-in console. If you have not already added the Certificates snap-in console, you can do so by doing the following: 
1. Click **Start**, click **Run**, type **mmc**, and then click **OK**. 
2. If the **User Account Control** dialog box appears, confirm that the action it displays is what you want, and then click **Continue**.. 
3. On the **File** menu, click **Add/Remove Snap-in**. 
4. In the **Add or Remove Snap-ins** dialog box, in the **Available snap-ins** list, click **Certificates**, and then click **Add**. 
5. In the **Certificates snap-in** dialog box, click **Computer account**, and then click **Next**. 
6. In the **Select Computer** dialog box, click **Local computer: (the computer this console is running on)**, and then click **Finish**. 
7. In the **Add or Remove Snap-ins** dialog box, click **OK**.

2. 
In the Certificates snap-in console, in the console tree, expand **Certificates (Local Computer)**, and then click **Personal**.

3. 
Right-click the **Personal **folder, point to **All Tasks**, and then click **Import**.

4. 
On the **Welcome to the Certificate Import Wizard** page, click **Next**.

5. 
On the **File to Import** page, in the **File name** box, specify the name of the certificate that you want to import, and then click **Next**.

6. 
If the **Password** page appears, if you specified a password for the private key associated with the certificate earlier, type the password, and then click **Next**.

7. 
On the **Certificate Store** page, accept the default option, and then click **Next**.

8. 
On the **Completing the Certificate Import Wizard** page, confirm that the correct certificate has been selected.

9. 
Click **Finish**.

10. 
After the certificate import has successfully completed, a message appears confirming that the import was successful. Click **OK**.

11. 
With **Certificates** selected in the console tree, in the details pane, verify that the correct certificate appears in the list of certificates on the RD Gateway server. The certificate must be under the **Personal **store of the local computer.

To import a certificate to be used by the RD Gateway server 
---

1. 
**SERVE 2008 R2:** Open RD Gateway Manager. To open RD Gateway Manager, click **Start**, point to **Administrative Tools**, point to **Remote Desktop Services**, and then click **RD Gateway Manager**.

**SERVER 2008:** Open TS Gateway Manager.  To open TS Gateway Manager, click **Start**, point to **Administrative Tools**, point to **Terminal Services**, and then click **TS Gateway Manager**.

2. 
In the RD Gateway Manager console tree, right-click the local RD Gateway server, and then click **Properties**.

3. 
On the **SSL Certificate** tab, click **Select an existing certificate for SSL encryption (recommended)**, and then click **Browse Certificates**.

4. 
In the **Install Certificate** dialog box, click the certificate that you want to use, and then click **Install**.

5. 
Click **OK **to close the **Properties** dialog box for the RD Gateway Manager server.

6. 
If this is the first time that you have mapped the RD Gateway Manager certificate, after the certificate mapping is completed, you can verify that the mapping was successful by viewing the **RD Gateway Server Status** area in RD Gateway Manager. Under **Configuration Status and Configuration Tasks**, the warning stating that a server certificate is not yet installed or selected and the **View or modify certificate properties** hyperlink are no longer displayed.

