---
title: "Install/Update Certificate for Remote Desktop Gateway"
description: "To import a certificate to the RD Gateway server in the (Local Computer)/Personal Store"
pubDate: 2013-02-04
category: "windows"
tags:
  - "certificates"
  - "remote-desktop"
  - "windows-server-2008"
  - "windows-server-2008r2"
draft: false
originalBloggerUrl: /2013/02/installupdate-certificate-for-remote.html
---

To import a certificate to the RD Gateway server in the (Local Computer)/Personal Store 

---

1. Open the Certificates snap-in console. If you have not already added the Certificates snap-in console, you can do so by doing the following:
   1. Click **Start**, click **Run**, type **mmc**, and then click **OK**.- If the **User Account Control** dialog box appears, confirm that the action it displays is what you want, and then click **Continue**..- On the **File** menu, click **Add/Remove Snap-in**.- In the **Add or Remove Snap-ins** dialog box, in the **Available snap-ins** list, click **Certificates**, and then click **Add**.- In the **Certificates snap-in** dialog box, click **Computer account**, and then click **Next**.- In the **Select Computer** dialog box, click **Local computer: (the computer this console is running on)**, and then click **Finish**.- In the **Add or Remove Snap-ins** dialog box, click **OK**.- In the Certificates snap-in console, in the console tree, expand **Certificates (Local Computer)**, and then click **Personal**.

     - Right-click the **Personal** folder, point to **All Tasks**, and then click **Import**.

       - On the **Welcome to the Certificate Import Wizard** page, click **Next**.

         - On the **File to Import** page, in the **File name** box, specify the name of the certificate that you want to import, and then click **Next**.

           - If the **Password** page appears, if you specified a password for the private key associated with the certificate earlier, type the password, and then click **Next**.

             - On the **Certificate Store** page, accept the default option, and then click **Next**.

               - On the **Completing the Certificate Import Wizard** page, confirm that the correct certificate has been selected.

                 - Click **Finish**.

                   - After the certificate import has successfully completed, a message appears confirming that the import was successful. Click **OK**.

                     - With **Certificates** selected in the console tree, in the details pane, verify that the correct certificate appears in the list of certificates on the RD Gateway server. The certificate must be under the **Personal** store of the local computer.

To import a certificate to be used by the RD Gateway server 

---

1. **SERVE 2008 R2:** Open RD Gateway Manager. To open RD Gateway Manager, click **Start**, point to **Administrative Tools**, point to **Remote Desktop Services**, and then click **RD Gateway Manager**.  
     
   **SERVER 2008:** Open TS Gateway Manager.  To open TS Gateway Manager, click **Start**, point to **Administrative Tools**, point to **Terminal Services**, and then click **TS Gateway Manager**.

   - In the RD Gateway Manager console tree, right-click the local RD Gateway server, and then click **Properties**.

     - On the **SSL Certificate** tab, click **Select an existing certificate for SSL encryption (recommended)**, and then click **Browse Certificates**.

       - In the **Install Certificate** dialog box, click the certificate that you want to use, and then click **Install**.

         - Click **OK** to close the **Properties** dialog box for the RD Gateway Manager server.

           - If this is the first time that you have mapped the RD Gateway Manager certificate, after the certificate mapping is completed, you can verify that the mapping was successful by viewing the **RD Gateway Server Status** area in RD Gateway Manager. Under **Configuration Status and Configuration Tasks**, the warning stating that a server certificate is not yet installed or selected and the **View or modify certificate properties** hyperlink are no longer displayed.
