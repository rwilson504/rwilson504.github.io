---
title: "Update Thumbprint in Web.Config After Updating ADFS 2.0 Certificate"
description: "Recently I had to replace an expired certificate on my ADFS 2.0 machine. I followed the instruction on the TechNet wiki found here."
pubDate: 2013-02-04
heroImage: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEikk1LD55uJCd1W0n1ZD9iX7ZmQuA-r2HzDCnNoDvr89U9KShb8UkK02rzjlQloNkiGGbMwDJdHTN-bdvDXFlm1W2QXwvZpLk8zbHsw8z7NH4P0-_CNfBjcJg_qwlKtCEimbT0urxL0PjU/?imgmax=800"
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

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEikk1LD55uJCd1W0n1ZD9iX7ZmQuA-r2HzDCnNoDvr89U9KShb8UkK02rzjlQloNkiGGbMwDJdHTN-bdvDXFlm1W2QXwvZpLk8zbHsw8z7NH4P0-_CNfBjcJg_qwlKtCEimbT0urxL0PjU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj4wAvPBQPpf6qbttL4TJ9BHn4VYJfVp82S4LBW-iGjxH6OYCvsKTU2o8saly7RpzLWdFD2ZMBL2P8QJ_nEt-rh7_kuXbGDKAaAUCf-hN90gUE3fgLQdfIIF9liFBMM444K_biBKErTGP8/s1600-h/image%25255B3%25255D.png)
