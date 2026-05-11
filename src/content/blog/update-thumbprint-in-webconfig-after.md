---
title: "Update Thumbprint in Web.Config After Updating ADFS 2.0 Certificate"
description: "Recently I had to replace an expired certificate on my ADFS 2.0 machine. I followed the instruction on the TechNet wiki found here."
pubDate: 2013-02-04
heroImage: "/heroes/update-thumbprint-in-webconfig-after.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "adfs-2"
  - "certificates"
draft: false
originalBloggerUrl: /2013/02/update-thumbprint-in-webconfig-after.html
---

Recently I had to replace an expired certificate on my ADFS 2.0 machine.  I followed the instruction on the TechNet wiki found here.

[http://social.technet.microsoft.com/wiki/contents/articles/2554.ad-fs-2-0-how-to-replace-the-ssl-service-communications-token-signing-and-token-decrypting-certificates.aspx](http://social.technet.microsoft.com/wiki/contents/articles/2554.ad-fs-2-0-how-to-replace-the-ssl-service-communications-token-signing-and-token-decrypting-certificates.aspx "http://social.technet.microsoft.com/wiki/contents/articles/2554.ad-fs-2-0-how-to-replace-the-ssl-service-communications-token-signing-and-token-decrypting-certificates.aspx")

The instructions were great but there is one more step that you need to complete before your website will connect correctly.

Once you have the thumbprint of the certificate you are using for ADFS 2.0 you must then update the web.config of each website that is utilizing ADFS for authentication.  Be careful when copying the thumbprint from the certificate properties window.  Make sure to remove all the spaces between the data before pasting it into the thumbprint property of the web.config.
