---
title: "ADFS 2.0 Default Claims Provider"
description: "In situation where you have multiple Claims Providers the HomeRealDiscovery.aspx page may confuse users."
pubDate: 2012-06-07
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

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiVFb-38g22syLXf2fCiJsstVWecff24PMZ9L2Sy9LYqn7wqmwadQOGKfA_LA9vBRzd-2HAac-_Fw2pyPQKSO9A4TAR3H2vox-RA6r4vpLdyYvCksRW0ZsojEviEx7S7hSx5rvA1mK_hMo/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhuVV2KyCTTt64O3r01Ft1ww98usnntVLszBgjLTs1cCWJDmejDfuclGW1FL4mzLX9mqJZ-VshrfDDqkb23ifTXSya-Qiy9TJkkA-4hFFRnE6RwU28TmPlcjMlQBxEqgKglmsoXLnZyfHw/s1600-h/image39.png)

As you can see here I have created a second claims provider called test. User may not know which one to use.

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjluJYVoLMizOnAdme8v5nBPDSNk5N97pZYC1yRwOJKwUYWLygIz1I3Ybo4sTeWTFjWs984LtwtTWQXCBt7qtiJSaxlrA_vgWT_jcJMVzEp2CkWrwN-l4vP7LwlJ0E1T8tjiUyDrttK4HQ/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjACANoBqGOWzim_QU6tAcvCG8vFUryaQlSTsteu8jvsZDwiYgyC5Rci1yffF5Fdxr35QUmXmgAEy6xxiUubmDpKhSrn-uSQcxEKVK-hONFW40setJga4eacCJ1jyMGLDani5iy8mfiWrg/s1600-h/image40.png)

**FIX 1** – Well not really a fix as much as a way to reduce this issue.

One way to help with this confusion is by setting the **persistIdentityProviderInformation** enabled value to true and the lifetimeInDays value to something like 30 in the web.config located at **C:\inetpub\adfs\ls**.  This will allow users to only have to select their claim provider every 30 days.

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgsphNPINHQGMu-mkR0bmOew_4VDe6JC6cDXHdZmPX2IDn-56KDKrnKEyAXhmYnzODsGU8sZc7Mdj8G7jF2kMBZnoYUNme-L7TWIsjUGnjHd8Z2HlDwlhjb_gw3sCACdhrBe6JRWdUuip4/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhGB-rjPbe4EVSWSilKIHcioDLV2_QeoI8huSo8i39cKNxGkpAUzUqWgc2dYtsOLuQWXhLK6XJQbPrDo75ptNsokPXldsDl71Lajl3atkA6rxZiFpG6UiWY2EyqucaMGGnMiBgGtSVbbMA/s1600-h/image%25255B18%25255D.png)

**FIX 2** – Update your web application to allow for WHR parameter

Another way to allows users to divert the HomeRealDiscovery page is by adding functionality to your web application that allows the whr parameter to determine which claim provider will be used when doing the redirect to ADFS.  Again this code all goes into your web application and does not require any additional work on the ADFS website.

Add a reference to the Microsoft.IdentityModel in your web application

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgvCqKl8feJwHkBlUwUYwaPTltNM3x9_dBipC7L1YoI66tlXDLtlEftGX1kIHMn_85f45Rjgq8o5j0rntEs874aVofkVQDk1ggJCUBIQ52cNav-NvIJZvgrajffdf2U4YmfTkS4GQXG9aM/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh7n9-Byk7C21wVHtwnQvhHAs6zAbt8oaxacd-BOP81viGb1mTCd13aUeMyqR2Xog7MxI6HPfxr2aVH-cN_B2JP0_U5FInf0dDjxO-hkoJXf5HqdQh_x26H_vF4GWjkuDLw4PLb9ytozx4/s1600-h/image%25255B2%25255D.png)

If you don’t already have a Global.asax file in your web application add a new item and select Global Application Class.

![](http://www.siue.edu/~dbock/cmis460/Module%2008%20--%20Manage%20State/Module08-ManageState_files/image011.jpg)

You will need to add an additional handler to the code behind of the Global.asax file.

[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjHSibXy3I7dCf_OEkauzdkxKw3duu3f3H89Ix_QhcXljK9_UYnNcRoPyII1TWxJ1smrsHudAD2pBg-KZZx-oPyZhXetHcEZV4_o41kYlSA9KhAU1giaVWw65-ccw4NbNL2aIFg-pMhwVw/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEicctBR1YKaG0fDn8-y8hyphenhyphenqAtxpXvnt26zLTb-NxB_Wri0s2TejeHICQAZlmxb1LYnX-6_4rtMifhJlTtMokiMSwqIuP9UN0Ye8sGzM9OYecjpGZ2IjpwyXE4gnPx2hwfl5aj1n3830x3M/s1600-h/image41.png)

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
[![image](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjsGcX7aCC8mCmxdSs8nd9oM4EZNFdUkAMfRdA-bVDxF4DEOz_R4my2BCV8a3d2o5u6_yJNe6u35he85vZgxpVq90dcrLdD8-hTSiW1_seYIsHCzpvw_yP7zHGfJ58JEGE1hOpQ0at_ruU/?imgmax=800 "image")](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimp82UFUOxp6gYPy0Jc3Wl6gZG7PYR-L2GGOONSUuRHs_HGXubFVSqTR-IcgRH7Vx5DvFpRInRl4CYfuut4NrOrp_29Nh1b5gljHkp3CwWwvmLMti0bo3s0G_rBdAnUOJZTDJAQY84mt0/s1600-h/image%25255B25%25255D.png)
