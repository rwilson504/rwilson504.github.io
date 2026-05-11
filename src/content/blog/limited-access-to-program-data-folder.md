---
title: "Limited Access to Program Data folder in AD for ADFS 2.0"
description: "If you work in an environment where you have no write access to the ‘Program Data’ folder in AD you can still install ADFS 2.0 but you will need to use the command prompt."
pubDate: 2012-06-06
category: power-apps
tags:
  - "adfs-2"
draft: false
originalBloggerUrl: /2012/06/limited-access-to-program-data-folder.html
---

If you work in an environment where you have no write access to the ‘Program Data’ folder in AD you can still install ADFS 2.0 but you will need to use the command prompt.

First Retrieve the Certificate Thumbprint for the Singing Cert and the Decrypt Cert.  Since this was a test machine I was using the same certificate for both, but in a production environment you will probably have separate certs for each.

#### To retrieve a certificate's thumbprint

1. Open the Microsoft Management Console (MMC) snap-in for certificates. (See [How to: View Certificates with the MMC Snap-in](http://msdn.microsoft.com/en-us/library/ms788967.aspx).)

   - In the **Console Root** window's left pane, click **Certificates (Local Computer)**.

     - Click the **Personal** folder to expand it.

       - Click the **Certificates** folder to expand it.

         - In the list of certificates, note the **Intended Purposes** heading. Find a certificate that lists **Client Authentication** as an intended purpose.

           - Double-click the certificate.

             - In the **Certificate** dialog box, click the **Details** tab.

               - Scroll through the list of fields and click **Thumbprint**.

                 - Copy the hexadecimal characters from the box. If this thumbprint is used in code for the **X509FindType**, remove the spaces between the hexadecimal numbers. For example, the thumbprint "a9 09 50 2d d8 2a e4 14 33 e6 f8 38 86 b0 0d 42 77 a3 2a 7b" should be specified as "a909502dd82ae41433e6f83886b00d4277a32a7b" in code.

#### Run the FSCONFIG Command to Create Farm

1. Open a command prompt.
2. Run the following command.  

   ```
   CD “C:\Program Files\Active Directory Federation Services 2.0\”
   ```
  
3. Run this command and substitute the values for your own ADFS setup.  

   ```
   FSCONFIG.exe CreateFarm /ServiceAccount "domain\account" /ServiceAccountPassword Password1 /FederationServiceName adfs.contoso.com /CleanConfig /SigningCertThumbprint "a909502dd82ae41433e6f83886b00d4277a32a7b" /DecryptCertThumbprint "a909502dd82ae41433e6f83886b00d4277a32a7b"
   ```
