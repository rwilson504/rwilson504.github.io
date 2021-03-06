---
layout: post
title: Limited Access to Program Data folder in AD for ADFS 2.0
date: '2012-06-06T16:11:00.001-04:00'
author: Rick Wilson
tags:
- ADFS 2.0
modified_time: '2012-06-06T16:17:34.395-04:00'
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-2403246148854102403
blogger_orig_url: https://www.richardawilson.com/2012/06/limited-access-to-program-data-folder.html
---


If you work in an environment where you have no write access to the ‘Program Data’ folder in AD you can still install ADFS 2.0 but you will need to use the command prompt.

First Retrieve the Certificate Thumbprint for the Singing Cert and the Decrypt Cert.  Since this was a test machine I was using the same certificate for both, but in a production environment you will probably have separate certs for each.

#### To retrieve a certificate's thumbprint

1. 
Open the Microsoft Management Console (MMC) snap-in for certificates. (See [How to: View Certificates with the MMC Snap-in](http://msdn.microsoft.com/en-us/library/ms788967.aspx).)

2. 
In the **Console Root** window's left pane, click **Certificates (Local Computer)**.

3. 
Click the **Personal** folder to expand it.

4. 
Click the **Certificates** folder to expand it.

5. 
In the list of certificates, note the **Intended Purposes** heading. Find a certificate that lists **Client Authentication** as an intended purpose.

6. 
Double-click the certificate.

7. 
In the **Certificate** dialog box, click the **Details** tab.

8. 
Scroll through the list of fields and click **Thumbprint**.

9. 
Copy the hexadecimal characters from the box. If this thumbprint is used in code for the **X509FindType**, remove the spaces between the hexadecimal numbers. For example, the thumbprint "a9 09 50 2d d8 2a e4 14 33 e6 f8 38 86 b0 0d 42 77 a3 2a 7b" should be specified as "a909502dd82ae41433e6f83886b00d4277a32a7b" in code.

#### Run the FSCONFIG Command to Create Farm

1. Open a command prompt.
2. Run the following command.

    CD “C:\Program Files\Active Directory Federation Services 2.0\”

.csharpcode, .csharpcode pre<br />{<br />	font-size: small;<br />	color: black;<br />	font-family: consolas, "Courier New", courier, monospace;<br />	background-color: #ffffff;<br />	/*white-space: pre;*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br />	background-color: #f4f4f4;<br />	width: 100%;<br />	margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />

3. Run this command and substitute the values for your own ADFS setup.

    FSCONFIG.exe CreateFarm /ServiceAccount "domain\account" /ServiceAccountPassword Password1 /FederationServiceName adfs.contoso.com /CleanConfig /SigningCertThumbprint "a909502dd82ae41433e6f83886b00d4277a32a7b" /DecryptCertThumbprint "a909502dd82ae41433e6f83886b00d4277a32a7b"

.csharpcode, .csharpcode pre<br />{<br />	font-size: small;<br />	color: black;<br />	font-family: consolas, "Courier New", courier, monospace;<br />	background-color: #ffffff;<br />	/*white-space: pre;*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br />	background-color: #f4f4f4;<br />	width: 100%;<br />	margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />

.csharpcode, .csharpcode pre<br />{<br />	font-size: small;<br />	color: black;<br />	font-family: consolas, "Courier New", courier, monospace;<br />	background-color: #ffffff;<br />	/*white-space: pre;*/<br />}<br />.csharpcode pre { margin: 0em; }<br />.csharpcode .rem { color: #008000; }<br />.csharpcode .kwrd { color: #0000ff; }<br />.csharpcode .str { color: #006080; }<br />.csharpcode .op { color: #0000c0; }<br />.csharpcode .preproc { color: #cc6633; }<br />.csharpcode .asp { background-color: #ffff00; }<br />.csharpcode .html { color: #800000; }<br />.csharpcode .attr { color: #ff0000; }<br />.csharpcode .alt <br />{<br />	background-color: #f4f4f4;<br />	width: 100%;<br />	margin: 0em;<br />}<br />.csharpcode .lnum { color: #606060; }<br />

