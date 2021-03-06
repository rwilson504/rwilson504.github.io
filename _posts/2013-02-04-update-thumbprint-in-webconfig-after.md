---
layout: post
title: Update Thumbprint in Web.Config After Updating ADFS 2.0 Certificate
date: '2013-02-04T14:55:00.001-05:00'
author: Rick Wilson
tags:
- Certificates
- ADFS 2.0
modified_time: '2013-02-04T14:55:57.778-05:00'
thumbnail: http://lh6.ggpht.com/-CvC7nAJKU58/URASS8h6-lI/AAAAAAAAHQk/BtNuC-0nrC8/s72-c/image_thumb%25255B1%25255D.png?imgmax=800
blogger_id: tag:blogger.com,1999:blog-8675696861245191896.post-7163673523768585934
blogger_orig_url: https://www.richardawilson.com/2013/02/update-thumbprint-in-webconfig-after.html
---


Recently I had to replace an expired certificate on my ADFS 2.0 machine.  I followed the instruction on the TechNet wiki found here.

[http://social.technet.microsoft.com/wiki/contents/articles/2554.ad-fs-2-0-how-to-replace-the-ssl-service-communications-token-signing-and-token-decrypting-certificates.aspx](http://social.technet.microsoft.com/wiki/contents/articles/2554.ad-fs-2-0-how-to-replace-the-ssl-service-communications-token-signing-and-token-decrypting-certificates.aspx)

The instructions were great but there is one more step that you need to complete before your website will connect correctly.

Once you have the thumbprint of the certificate you are using for ADFS 2.0 you must then update the web.config of each website that is utilizing ADFS for authentication.  Be careful when copying the thumbprint from the certificate properties window.  Make sure to remove all the spaces between the data before pasting it into the thumbprint property of the web.config.

[![image](http://lh6.ggpht.com/-CvC7nAJKU58/URASS8h6-lI/AAAAAAAAHQk/BtNuC-0nrC8/image_thumb%25255B1%25255D.png?imgmax=800)](http://lh3.ggpht.com/-BU6OeJnYNSM/URASSjG04-I/AAAAAAAAHQc/hLvKW_jOcuE/s1600-h/image%25255B3%25255D.png)

