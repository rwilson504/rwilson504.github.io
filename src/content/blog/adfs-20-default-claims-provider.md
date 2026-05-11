---
title: "ADFS 2.0 Default Claims Provider"
description: "In situation where you have multiple Claims Providers the HomeRealDiscovery.aspx page may confuse users."
pubDate: 2012-06-07
heroImage: "/heroes/adfs-20-default-claims-provider.png"
heroImageAlt: "image"
category: power-apps
tags:
  - "adfs-2"
  - "authentication"
  - "web-application"
  - "web-config"
draft: false
originalBloggerUrl: /2012/06/adfs-20-default-claims-provider.html
---

In situation where you have multiple Claims Providers the HomeRealDiscovery.aspx page may confuse users.

As you can see here I have created a second claims provider called test. User may not know which one to use.

[![image](/images/adfs-20-default-claims-provider/01-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjACANoBqGOWzim_QU6tAcvCG8vFUryaQlSTsteu8jvsZDwiYgyC5Rci1yffF5Fdxr35QUmXmgAEy6xxiUubmDpKhSrn-uSQcxEKVK-hONFW40setJga4eacCJ1jyMGLDani5iy8mfiWrg/s1600-h/image40.png)

**FIX 1** – Well not really a fix as much as a way to reduce this issue.

One way to help with this confusion is by setting the **persistIdentityProviderInformation** enabled value to true and the lifetimeInDays value to something like 30 in the web.config located at **C:\inetpub\adfs\ls**.  This will allow users to only have to select their claim provider every 30 days.

[![image](/images/adfs-20-default-claims-provider/02-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhGB-rjPbe4EVSWSilKIHcioDLV2_QeoI8huSo8i39cKNxGkpAUzUqWgc2dYtsOLuQWXhLK6XJQbPrDo75ptNsokPXldsDl71Lajl3atkA6rxZiFpG6UiWY2EyqucaMGGnMiBgGtSVbbMA/s1600-h/image%25255B18%25255D.png)

**FIX 2** – Update your web application to allow for WHR parameter

Another way to allows users to divert the HomeRealDiscovery page is by adding functionality to your web application that allows the whr parameter to determine which claim provider will be used when doing the redirect to ADFS.  Again this code all goes into your web application and does not require any additional work on the ADFS website.

Add a reference to the Microsoft.IdentityModel in your web application

[![image](/images/adfs-20-default-claims-provider/03-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh7n9-Byk7C21wVHtwnQvhHAs6zAbt8oaxacd-BOP81viGb1mTCd13aUeMyqR2Xog7MxI6HPfxr2aVH-cN_B2JP0_U5FInf0dDjxO-hkoJXf5HqdQh_x26H_vF4GWjkuDLw4PLb9ytozx4/s1600-h/image%25255B2%25255D.png)

If you don’t already have a Global.asax file in your web application add a new item and select Global Application Class.

You will need to add an additional handler to the code behind of the Global.asax file.

[![image](/images/adfs-20-default-claims-provider/05-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEicctBR1YKaG0fDn8-y8hyphenhyphenqAtxpXvnt26zLTb-NxB_Wri0s2TejeHICQAZlmxb1LYnX-6_4rtMifhJlTtMokiMSwqIuP9UN0Ye8sGzM9OYecjpGZ2IjpwyXE4gnPx2hwfl5aj1n3830x3M/s1600-h/image41.png)

```
```
void WSFederationAuthenticationModule_RedirectingToIdentityProvider(object sender, RedirectingToIdentityProviderEventArgs e)
```

```
{
```

```
      e.SignInRequestMessage.HomeRealm = Request["whr"];
```

```
}
```
```

  

What’s great is that the Identity Model already knows what to do with this method, there is no more code to write.

  

Now just add the ?whr=identityID parameter to your applications url and you will no longer see the HomeRealDiscovery page but be automatically directed to the authentication method.

  

Let’s look at two example of how to use this.  For both of these my web application will be located at:

  

<https://mywebapp.contoso.com>

  

My STS (ADFS) server will be located at:

  

<https://sts.contoso.com>

  

**EXAMPLE 1:** Using the build in Active Directory Claims Provider

  

-First we will need to get the entityID of our claims provider.  To get this we will go to the FederationMetadata on the STS (ADFS) server at the following url:

  

[https://sts.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml](https://sts.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml "https://sts.contoso.com/FederationMetadata/2007-06/FederationMetadata.xml")

  

**NOTE**: Depending on your IE Version this page may come up blank.  If you do not see the XML on the page hit the compatibility view button in IE.  
[![image](/images/adfs-20-default-claims-provider/06-img.png "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimp82UFUOxp6gYPy0Jc3Wl6gZG7PYR-L2GGOONSUuRHs_HGXubFVSqTR-IcgRH7Vx5DvFpRInRl4CYfuut4NrOrp_29Nh1b5gljHkp3CwWwvmLMti0bo3s0G_rBdAnUOJZTDJAQY84mt0/s1600-h/image%25255B25%25255D.png)
